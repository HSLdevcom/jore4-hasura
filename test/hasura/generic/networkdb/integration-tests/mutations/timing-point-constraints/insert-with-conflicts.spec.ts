import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, setupDb } from '@util/setup';
import { scheduledStopPoints } from 'generic/networkdb/datasets/defaultSetup';
import {
  journeyPatterns,
  routesAndJourneyPatternsTableData,
} from 'generic/networkdb/datasets/routesAndJourneyPatterns';
import {
  ScheduledStopPointInJourneyPattern,
  scheduledStopPointInJourneyPatternProps,
} from 'generic/networkdb/datasets/types';
import * as rp from 'request-promise';

const baseScheduledStopPoint: Partial<ScheduledStopPointInJourneyPattern> = {
  scheduled_stop_point_sequence: 0,
  journey_pattern_id: journeyPatterns[0].journey_pattern_id,
  scheduled_stop_point_label: scheduledStopPoints[0].label,
  is_used_as_timing_point: false,
  is_regulated_timing_point: false,
  is_loading_time_allowed: false,
};

const buildMutation = (
  toBeInserted: Partial<ScheduledStopPointInJourneyPattern>,
) => `
  mutation {
    insert_journey_pattern_scheduled_stop_point_in_journey_pattern(objects: ${dataset.toGraphQlObject(
      {
        ...toBeInserted,
      },
    )}) {
      returning {
        ${getPropNameArray(scheduledStopPointInJourneyPatternProps).join(',')}
      }
    }
  }
`;

describe('Inserting scheduled_stop_point_on_journey_pattern with constraint conflicts', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, routesAndJourneyPatternsTableData));

  describe('loading time allowed but is not regulated timing point', () => {
    it('should not insert', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation({
            ...baseScheduledStopPoint,
            is_loading_time_allowed: true,
          }),
        },
      });
      expectErrorResponse('Check constraint violation.')(response);
      expectErrorResponse('ck_is_regulated_timing_point_state')(response);
    });
  });
  describe('used as timing point and loading time is allowed but not set as regulated timing point', () => {
    it('should not insert', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation({
            ...baseScheduledStopPoint,
            is_used_as_timing_point: true,
            is_loading_time_allowed: true,
          }),
        },
      });
      expectErrorResponse('Check constraint violation.')(response);
      expectErrorResponse('ck_is_regulated_timing_point_state')(response);
    });
  });
  describe('used as regulated timing point but not set as timing point', () => {
    it('should not insert', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation({
            ...baseScheduledStopPoint,
            is_regulated_timing_point: true,
          }),
        },
      });
      expectErrorResponse('Check constraint violation.')(response);
      expectErrorResponse('ck_is_used_as_timing_point_state')(response);
    });
  });
  describe('used as regulated timing point, allowed loading time but is not set as timing point', () => {
    it('should not insert', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation({
            ...baseScheduledStopPoint,
            is_regulated_timing_point: true,
            is_loading_time_allowed: true,
          }),
        },
      });
      expectErrorResponse('Check constraint violation.')(response);
      expectErrorResponse('ck_is_used_as_timing_point_state')(response);
    });
  });
});