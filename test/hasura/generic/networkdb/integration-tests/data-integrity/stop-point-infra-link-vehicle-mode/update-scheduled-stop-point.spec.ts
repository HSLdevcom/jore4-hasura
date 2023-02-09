import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import { defaultGenericNetworkDbData } from 'generic/networkdb/datasets/defaultSetup';
import { infrastructureLinks } from 'generic/networkdb/datasets/defaultSetup/infrastructure-links';
import { scheduledStopPoints } from 'generic/networkdb/datasets/defaultSetup/scheduled-stop-points';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import {
  ScheduledStopPoint,
  scheduledStopPointProps,
} from 'generic/networkdb/datasets/types';
import * as rp from 'request-promise';

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
        ${getPropNameArray(scheduledStopPointProps).join(',')}
      }
    }
  }
`;

describe('Update scheduled stop point', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, defaultGenericNetworkDbData));

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
        dbConnection,
        genericNetworkDbSchema['service_pattern.scheduled_stop_point'],
      );

      expect(response.rowCount).toEqual(scheduledStopPoints.length);

      expect(response.rows).toEqual(
        expect.arrayContaining(
          dataset.serializeMatcherInputs(scheduledStopPoints),
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
        dbConnection,
        genericNetworkDbSchema['service_pattern.scheduled_stop_point'],
      );

      expect(response.rowCount).toEqual(scheduledStopPoints.length);

      expect(response.rows).toEqual(
        expect.arrayContaining(
          dataset.serializeMatcherInputs([
            createCompleteUpdated(toBeUpdated),
            ...scheduledStopPoints.filter(
              (scheduledStopPoint) =>
                scheduledStopPoint.scheduled_stop_point_id !==
                createCompleteUpdated(toBeUpdated).scheduled_stop_point_id,
            ),
          ]),
        ),
      );
    });
  });
});
