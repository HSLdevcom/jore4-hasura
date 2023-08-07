import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { expectNoErrorResponse } from '@util/response';
import { getPropNameArray, setupDb } from '@util/setup';
import {
  routesAndJourneyPatternsTableData,
  scheduledStopPointInJourneyPattern,
} from 'generic/networkdb/datasets/routesAndJourneyPatterns';
import {
  ScheduledStopPointInJourneyPattern,
  scheduledStopPointInJourneyPatternProps,
} from 'generic/networkdb/datasets/types';
import * as rp from 'request-promise';

const buildMutation = (
  toBeUpdated: Partial<ScheduledStopPointInJourneyPattern>,
) => `
  mutation {
    update_journey_pattern_scheduled_stop_point_in_journey_pattern_by_pk(
      pk_columns: {
        journey_pattern_id: "${
          scheduledStopPointInJourneyPattern[0].journey_pattern_id
        }",
        scheduled_stop_point_sequence: "${
          scheduledStopPointInJourneyPattern[0].scheduled_stop_point_sequence
        }"
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated)}
      ) {

          ${getPropNameArray(scheduledStopPointInJourneyPatternProps).join(',')}

      }
    }
`;

describe('updating scheduled_stop_point_on_journey_pattern without constraint conflicts', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, routesAndJourneyPatternsTableData));

  describe('Set all timing point settings to false', () => {
    it('should insert without conflicts', async () => {
      const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
        is_used_as_timing_point: false,
        is_regulated_timing_point: false,
        is_loading_time_allowed: false,
      };

      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeUpdated) },
      });

      expectNoErrorResponse(response);
    });
  });
  describe('Set as timing point', () => {
    it('should insert without conflicts', async () => {
      const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
        is_used_as_timing_point: true,
        is_regulated_timing_point: false,
        is_loading_time_allowed: false,
      };

      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeUpdated) },
      });

      expectNoErrorResponse(response);
    });
  });
  describe('Set as timing point and as regulated timing point', () => {
    it('should insert without conflicts', async () => {
      const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
        is_used_as_timing_point: true,
        is_regulated_timing_point: true,
        is_loading_time_allowed: false,
      };

      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeUpdated) },
      });

      expectNoErrorResponse(response);
    });
  });
  describe('Set all timing point settings to true', () => {
    it('should insert without conflicts', async () => {
      const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
        is_used_as_timing_point: true,
        is_regulated_timing_point: true,
        is_loading_time_allowed: true,
      };

      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeUpdated) },
      });

      expectNoErrorResponse(response);
    });
  });
});
