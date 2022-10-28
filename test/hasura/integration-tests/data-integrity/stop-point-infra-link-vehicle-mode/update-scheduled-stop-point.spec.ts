import * as rp from 'request-promise';
import * as pg from 'pg';
import * as config from '@config';
import * as dataset from '@util/dataset';
import { scheduledStopPoints } from '@datasets/defaultSetup/scheduled-stop-points';
import { ScheduledStopPoint, ScheduledStopPointProps } from '@datasets/types';
import '@util/matchers';
import { getPropNameArray, queryTable, setupDb } from '@datasets/setup';
import { expectErrorResponse } from '@util/response';
import { infrastructureLinks } from '@datasets/defaultSetup/infrastructure-links';

const createCompleteUpdated = (
  toBeUpdated: Partial<ScheduledStopPoint>,
): ScheduledStopPoint => ({
  ...scheduledStopPoints[2],
  ...toBeUpdated,
});

const buildMutation = (toBeUpdated: Partial<ScheduledStopPoint>) => `
  mutation {
    update_service_pattern_scheduled_stop_point(
      where: {
        scheduled_stop_point_id: {_eq: "${
          createCompleteUpdated(toBeUpdated).scheduled_stop_point_id
        }"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated, ['direction'])}
    ) {
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

  beforeEach(() => setupDb(dbConnectionPool));

  describe('with infra link id referencing link with incompatible sub mode "generic_ferry"', () => {
    const toBeUpdated: Partial<ScheduledStopPoint> = {
      located_on_infrastructure_link_id:
        infrastructureLinks[3].infrastructure_link_id,
    };

    it('should return error response', async () => {
      await rp
        .post({
          ...config.hasuraRequestTemplate,
          body: { query: buildMutation(toBeUpdated) },
        })
        .then(
          expectErrorResponse(
            'scheduled stop point vehicle mode must be compatible with allowed infrastructure link vehicle submodes',
          ),
        );
    });

    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeUpdated) },
      });

      const response = await queryTable(
        dbConnectionPool,
        'service_pattern.scheduled_stop_point',
      );

      expect(response.rowCount).toEqual(scheduledStopPoints.length);

      expect(response.rows).toEqual(
        expect.arrayContaining(
          dataset.asDbGeometryObjectArray(scheduledStopPoints, [
            'measured_location',
          ]),
        ),
      );
    });
  });

  describe('with infra link id referencing link with compatible sub mode "generic_bus"', () => {
    const toBeUpdated: Partial<ScheduledStopPoint> = {
      located_on_infrastructure_link_id:
        infrastructureLinks[0].infrastructure_link_id,
    };

    it('should return correct response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeUpdated) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            update_service_pattern_scheduled_stop_point: {
              returning: [
                dataset.asGraphQlDateObject(createCompleteUpdated(toBeUpdated)),
              ],
            },
          },
        }),
      );
    });

    it('should update correct row in the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeUpdated) },
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
              createCompleteUpdated(toBeUpdated),
              ...scheduledStopPoints.filter(
                (scheduledStopPoint) =>
                  scheduledStopPoint.scheduled_stop_point_id !=
                  createCompleteUpdated(toBeUpdated).scheduled_stop_point_id,
              ),
            ],
            ['measured_location'],
          ),
        ),
      );
    });
  });
});
