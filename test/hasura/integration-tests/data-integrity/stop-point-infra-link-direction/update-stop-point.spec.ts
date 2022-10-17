import * as config from '@config';
import { infrastructureLinks } from '@datasets/defaultSetup/infrastructure-links';
import { scheduledStopPoints } from '@datasets/defaultSetup/scheduled-stop-points';
import {
  getPropNameArray,
  getTableConfigArray,
  queryTable,
  setupDb,
} from '@datasets/setup';
import {
  LinkDirection,
  ScheduledStopPoint,
  ScheduledStopPointProps,
} from '@datasets/types';
import * as dataset from '@util/dataset';
import { asDbGeometryObjectArray } from '@util/dataset';
import '@util/matchers';
import { expectErrorResponse } from '@util/response';
import * as pg from 'pg';
import * as rp from 'request-promise';

const buildMutation = (
  stopPointId: string,
  toBeUpdated: Partial<ScheduledStopPoint>,
) => `
  mutation {
    update_service_pattern_scheduled_stop_point(
      where: {
        scheduled_stop_point_id: {_eq: "${stopPointId}"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated, ['direction'])}) {
      returning {
        ${getPropNameArray(ScheduledStopPointProps).join(',')}
      }
    }
  }
`;

describe('Update scheduled stop point', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() =>
    setupDb(
      dbConnectionPool,
      getTableConfigArray([
        'infrastructure_network.infrastructure_link',
        'infrastructure_network.vehicle_submode_on_infrastructure_link',
        'service_pattern.scheduled_stop_point_invariant',
        'service_pattern.scheduled_stop_point',
        'service_pattern.vehicle_mode_on_scheduled_stop_point',
        'route.line',
        'route.route',
      ]),
    ),
  );

  describe("whose direction conflicts with its infrastructure link's direction", () => {
    const shouldReturnErrorResponse = (
      stopPointId: string,
      toBeUpdated: Partial<ScheduledStopPoint>,
    ) =>
      it('should return error response', async () => {
        await rp
          .post({
            ...config.hasuraRequestTemplate,
            body: { query: buildMutation(stopPointId, toBeUpdated) },
          })
          .then(
            expectErrorResponse(
              'scheduled stop point direction must be compatible with infrastructure link direction',
            ),
          );
      });

    const shouldNotModifyDatabase = (
      stopPointId: string,
      toBeUpdated: Partial<ScheduledStopPoint>,
    ) =>
      it('should not modify the database', async () => {
        await rp.post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(stopPointId, toBeUpdated) },
        });

        const response = await queryTable(
          dbConnectionPool,
          'service_pattern.scheduled_stop_point',
        );

        expect(response.rowCount).toEqual(scheduledStopPoints.length);
        expect(response.rows).toEqual(
          expect.arrayContaining(
            asDbGeometryObjectArray(scheduledStopPoints, ['measured_location']),
          ),
        );
      });

    describe('infrastructure link direction "forward", stop point direction "backward"', () => {
      const toBeUpdated = {
        direction: LinkDirection.Backward,
      };

      shouldReturnErrorResponse(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated,
      );

      shouldNotModifyDatabase(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated,
      );
    });

    describe('infrastructure link direction "backward", stop point direction "forward"', () => {
      const toBeUpdated = {
        located_on_infrastructure_link_id:
          infrastructureLinks[2].infrastructure_link_id,
      };

      shouldReturnErrorResponse(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated,
      );

      shouldNotModifyDatabase(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated,
      );
    });

    describe('infrastructure link direction "forward", stop point direction "bidirectional"', () => {
      const toBeUpdated = {
        direction: LinkDirection.BiDirectional,
      };

      shouldReturnErrorResponse(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated,
      );

      shouldNotModifyDatabase(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated,
      );
    });

    describe('infrastructure link direction "backward", stop point direction "bidirectional"', () => {
      const toBeUpdated = {
        located_on_infrastructure_link_id:
          infrastructureLinks[2].infrastructure_link_id,
        direction: LinkDirection.BiDirectional,
      };

      shouldReturnErrorResponse(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated,
      );

      shouldNotModifyDatabase(
        scheduledStopPoints[0].scheduled_stop_point_id,
        toBeUpdated,
      );
    });

    describe("whose direction does NOT conflict with its infrastructure link's direction", () => {
      const shouldReturnCorrectResponse = (
        original: ScheduledStopPoint,
        toBeUpdated: Partial<ScheduledStopPoint>,
      ) =>
        it('should return correct response', async () => {
          const response = await rp.post({
            ...config.hasuraRequestTemplate,
            body: {
              query: buildMutation(
                original.scheduled_stop_point_id,
                toBeUpdated,
              ),
            },
          });

          expect(response).toEqual(
            expect.objectContaining({
              data: {
                update_service_pattern_scheduled_stop_point: {
                  returning: [
                    dataset.asGraphQlTimestampObject({
                      ...original,
                      ...toBeUpdated,
                    }),
                  ],
                },
              },
            }),
          );
        });

      const shouldUpdateCorrectRowInDatabase = (
        original: ScheduledStopPoint,
        toBeUpdated: Partial<ScheduledStopPoint>,
      ) =>
        it('should update correct row in the database', async () => {
          await rp.post({
            ...config.hasuraRequestTemplate,
            body: {
              query: buildMutation(
                original.scheduled_stop_point_id,
                toBeUpdated,
              ),
            },
          });

          const response = await queryTable(
            dbConnectionPool,
            'service_pattern.scheduled_stop_point',
          );

          expect(response.rowCount).toEqual(scheduledStopPoints.length);

          expect(response.rows).toEqual(
            expect.arrayContaining(
              dataset.asDbGeometryObjectArray(
                [
                  { ...original, ...toBeUpdated },
                  ...scheduledStopPoints.filter(
                    (scheduledStopPoint) =>
                      scheduledStopPoint.scheduled_stop_point_id !=
                      original.scheduled_stop_point_id,
                  ),
                ],
                ['measured_location'],
              ),
            ),
          );
        });

      describe('infrastructure link direction "forward", stop point direction "forward"', () => {
        const toBeUpdated = {
          located_on_infrastructure_link_id:
            infrastructureLinks[0].infrastructure_link_id,
          direction: LinkDirection.Forward,
        };

        shouldReturnCorrectResponse(scheduledStopPoints[1], toBeUpdated);

        shouldUpdateCorrectRowInDatabase(scheduledStopPoints[1], toBeUpdated);
      });

      describe('infrastructure link direction "backward", stop point direction "backward"', () => {
        const toBeUpdated = {
          located_on_infrastructure_link_id:
            infrastructureLinks[2].infrastructure_link_id,
          direction: LinkDirection.Backward,
        };

        shouldReturnCorrectResponse(scheduledStopPoints[2], toBeUpdated);

        shouldUpdateCorrectRowInDatabase(scheduledStopPoints[2], toBeUpdated);
      });

      describe('infrastructure link direction "bidirectional", stop point direction "forward"', () => {
        const toBeUpdated = {
          located_on_infrastructure_link_id:
            infrastructureLinks[1].infrastructure_link_id,
        };

        shouldReturnCorrectResponse(scheduledStopPoints[2], toBeUpdated);

        shouldUpdateCorrectRowInDatabase(scheduledStopPoints[2], toBeUpdated);
      });

      describe('infrastructure link direction "bidirectional", stop point direction "backward"', () => {
        const toBeUpdated = {
          located_on_infrastructure_link_id:
            infrastructureLinks[1].infrastructure_link_id,
        };

        shouldReturnCorrectResponse(scheduledStopPoints[1], toBeUpdated);

        shouldUpdateCorrectRowInDatabase(scheduledStopPoints[1], toBeUpdated);
      });

      describe('infrastructure link direction "bidirectional", stop point direction "bidirectional"', () => {
        const toBeUpdated = {
          direction: LinkDirection.BiDirectional,
        };

        shouldReturnCorrectResponse(scheduledStopPoints[1], toBeUpdated);

        shouldUpdateCorrectRowInDatabase(scheduledStopPoints[1], toBeUpdated);
      });
    });
  });
});
