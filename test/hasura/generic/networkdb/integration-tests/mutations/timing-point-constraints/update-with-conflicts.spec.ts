import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { expectErrorResponse } from '@util/response';
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

  describe('loading time allowed but is not regulated timing point', () => {
    it('should not update', async () => {
      const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
        is_used_as_timing_point: false,
        is_regulated_timing_point: false,
        is_loading_time_allowed: true,
      };

      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeUpdated) },
      });

      expectErrorResponse('Check constraint violation.')(response);
      expectErrorResponse('ck_is_regulated_timing_point_state')(response);
    });
  });
  describe('used as timing point and loading time is allowed but not set as regulated timing point', () => {
    it('should not update', async () => {
      const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
        is_used_as_timing_point: true,
        is_regulated_timing_point: false,
        is_loading_time_allowed: true,
      };

      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeUpdated) },
      });

      expectErrorResponse('Check constraint violation.')(response);
      expectErrorResponse('ck_is_regulated_timing_point_state')(response);
    });
  });
  describe('used as regulated timing point but not set as timing point', () => {
    it('should not update', async () => {
      const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
        is_used_as_timing_point: false,
        is_regulated_timing_point: true,
        is_loading_time_allowed: false,
      };

      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeUpdated) },
      });

      expectErrorResponse('Check constraint violation.')(response);
      expectErrorResponse('ck_is_used_as_timing_point_state')(response);
    });
  });
  describe('used as regulated timing point, allowed loading time but is not set as timing point', () => {
    it('should not update', async () => {
      const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
        is_used_as_timing_point: false,
        is_regulated_timing_point: true,
        is_loading_time_allowed: true,
      };

      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeUpdated) },
      });

      expectErrorResponse('Check constraint violation.')(response);
      expectErrorResponse('ck_is_used_as_timing_point_state')(response);
    });
  });
});
