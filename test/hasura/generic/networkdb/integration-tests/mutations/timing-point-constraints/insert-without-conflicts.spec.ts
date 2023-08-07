import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { expectNoErrorResponse } from '@util/response';
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

describe('Inserting scheduled_stop_point_on_journey_pattern without constraint conflicts', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, routesAndJourneyPatternsTableData));

  describe('No timing point settings set', () => {
    it('should insert without conflicts', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(baseScheduledStopPoint) },
      });
      expectNoErrorResponse(response);
    });
  });
  describe('used as timing point but not as regulated timing point', () => {
    it('should insert without conflicts', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation({
            ...baseScheduledStopPoint,
            is_used_as_timing_point: true,
          }),
        },
      });
      expectNoErrorResponse(response);
    });
  });
  describe('used as timing point and as regulated timing point', () => {
    it('should insert without conflicts', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation({
            ...baseScheduledStopPoint,
            is_used_as_timing_point: true,
            is_regulated_timing_point: true,
          }),
        },
      });
      expectNoErrorResponse(response);
    });
  });
  describe('used as timing point, regulated timing point and loading time is allowed', () => {
    it('should insert without conflicts', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: {
          query: buildMutation({
            ...baseScheduledStopPoint,
            is_used_as_timing_point: true,
            is_regulated_timing_point: true,
            is_loading_time_allowed: true,
          }),
        },
      });
      expectNoErrorResponse(response);
    });
  });
});
