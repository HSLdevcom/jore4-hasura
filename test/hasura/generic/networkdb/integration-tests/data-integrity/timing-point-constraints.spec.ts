import * as config from '@config';
import * as dataset from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { post } from '@util/fetch-request';
import { expectErrorResponse, expectNoErrorResponse } from '@util/response';
import { getPropNameArray, setupDb } from '@util/setup';
import { scheduledStopPoints } from 'generic/networkdb/datasets/defaultSetup';
import {
  journeyPatterns,
  routesAndJourneyPatternsTableData,
  scheduledStopPointInJourneyPattern,
} from 'generic/networkdb/datasets/routesAndJourneyPatterns';
import {
  ScheduledStopPointInJourneyPattern,
  scheduledStopPointInJourneyPatternProps,
} from 'generic/networkdb/datasets/types';

const baseScheduledStopPoint: Partial<ScheduledStopPointInJourneyPattern> = {
  scheduled_stop_point_sequence: 0,
  journey_pattern_id: journeyPatterns[0].journey_pattern_id,
  scheduled_stop_point_label: scheduledStopPoints[0].label,
  is_used_as_timing_point: false,
  is_regulated_timing_point: false,
  is_loading_time_allowed: false,
};

const buildInsertMutation = (
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

const buildUpdateMutation = (
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

describe('Timing point constraints on scheduled_stop_point_on_journey_pattern', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, routesAndJourneyPatternsTableData));

  describe('with conflicts', () => {
    describe('loading time allowed but is not regulated timing point', () => {
      it('should not insert', async () => {
        const response = await post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildInsertMutation({
              ...baseScheduledStopPoint,
              is_loading_time_allowed: true,
            }),
          },
        });

        expectErrorResponse('Check constraint violation.')(response);
        expectErrorResponse('ck_is_regulated_timing_point_state')(response);
      });

      it('should not update', async () => {
        const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
          is_used_as_timing_point: false,
          is_regulated_timing_point: false,
          is_loading_time_allowed: true,
        };

        const response = await post({
          ...config.hasuraRequestTemplate,
          body: { query: buildUpdateMutation(toBeUpdated) },
        });

        expectErrorResponse('Check constraint violation.')(response);
        expectErrorResponse('ck_is_regulated_timing_point_state')(response);
      });
    });

    describe('used as timing point and loading time is allowed but not set as regulated timing point', () => {
      it('should not insert', async () => {
        const response = await post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildInsertMutation({
              ...baseScheduledStopPoint,
              is_used_as_timing_point: true,
              is_loading_time_allowed: true,
            }),
          },
        });

        expectErrorResponse('Check constraint violation.')(response);
        expectErrorResponse('ck_is_regulated_timing_point_state')(response);
      });

      it('should not update', async () => {
        const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
          is_used_as_timing_point: true,
          is_regulated_timing_point: false,
          is_loading_time_allowed: true,
        };

        const response = await post({
          ...config.hasuraRequestTemplate,
          body: { query: buildUpdateMutation(toBeUpdated) },
        });

        expectErrorResponse('Check constraint violation.')(response);
        expectErrorResponse('ck_is_regulated_timing_point_state')(response);
      });
    });

    describe('used as regulated timing point but not set as timing point', () => {
      it('should not insert', async () => {
        const response = await post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildInsertMutation({
              ...baseScheduledStopPoint,
              is_regulated_timing_point: true,
            }),
          },
        });

        expectErrorResponse('Check constraint violation.')(response);
        expectErrorResponse('ck_is_used_as_timing_point_state')(response);
      });

      it('should not update', async () => {
        const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
          is_used_as_timing_point: false,
          is_regulated_timing_point: true,
          is_loading_time_allowed: false,
        };

        const response = await post({
          ...config.hasuraRequestTemplate,
          body: { query: buildUpdateMutation(toBeUpdated) },
        });

        expectErrorResponse('Check constraint violation.')(response);
        expectErrorResponse('ck_is_used_as_timing_point_state')(response);
      });
    });

    describe('used as regulated timing point, allowed loading time but is not set as timing point', () => {
      it('should not insert', async () => {
        const response = await post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildInsertMutation({
              ...baseScheduledStopPoint,
              is_regulated_timing_point: true,
              is_loading_time_allowed: true,
            }),
          },
        });

        expectErrorResponse('Check constraint violation.')(response);
        expectErrorResponse('ck_is_used_as_timing_point_state')(response);
      });

      it('should not update', async () => {
        const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
          is_used_as_timing_point: false,
          is_regulated_timing_point: true,
          is_loading_time_allowed: true,
        };

        const response = await post({
          ...config.hasuraRequestTemplate,
          body: { query: buildUpdateMutation(toBeUpdated) },
        });

        expectErrorResponse('Check constraint violation.')(response);
        expectErrorResponse('ck_is_used_as_timing_point_state')(response);
      });
    });
  });

  describe('without conflicts', () => {
    describe('All timing point settings are set to false', () => {
      it('should insert without conflicts', async () => {
        const response = await post({
          ...config.hasuraRequestTemplate,
          body: { query: buildInsertMutation(baseScheduledStopPoint) },
        });

        expectNoErrorResponse(response);
      });

      it('should update without conflicts', async () => {
        const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
          is_used_as_timing_point: false,
          is_regulated_timing_point: false,
          is_loading_time_allowed: false,
        };

        const response = await post({
          ...config.hasuraRequestTemplate,
          body: { query: buildUpdateMutation(toBeUpdated) },
        });

        expectNoErrorResponse(response);
      });
    });

    describe('used as timing point but not as regulated timing point', () => {
      it('should insert without conflicts', async () => {
        const response = await post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildInsertMutation({
              ...baseScheduledStopPoint,
              is_used_as_timing_point: true,
            }),
          },
        });

        expectNoErrorResponse(response);
      });

      it('should update without conflicts', async () => {
        const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
          is_used_as_timing_point: true,
          is_regulated_timing_point: false,
          is_loading_time_allowed: false,
        };

        const response = await post({
          ...config.hasuraRequestTemplate,
          body: { query: buildUpdateMutation(toBeUpdated) },
        });

        expectNoErrorResponse(response);
      });
    });

    describe('used as timing point and as regulated timing point', () => {
      it('should insert without conflicts', async () => {
        const response = await post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildInsertMutation({
              ...baseScheduledStopPoint,
              is_used_as_timing_point: true,
              is_regulated_timing_point: true,
            }),
          },
        });

        expectNoErrorResponse(response);
      });

      it('should update without conflicts', async () => {
        const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
          is_used_as_timing_point: true,
          is_regulated_timing_point: true,
          is_loading_time_allowed: false,
        };

        const response = await post({
          ...config.hasuraRequestTemplate,
          body: { query: buildUpdateMutation(toBeUpdated) },
        });

        expectNoErrorResponse(response);
      });
    });

    describe('used as timing point, regulated timing point and loading time is allowed', () => {
      it('should insert without conflicts', async () => {
        const response = await post({
          ...config.hasuraRequestTemplate,
          body: {
            query: buildInsertMutation({
              ...baseScheduledStopPoint,
              is_used_as_timing_point: true,
              is_regulated_timing_point: true,
              is_loading_time_allowed: true,
            }),
          },
        });

        expectNoErrorResponse(response);
      });

      it('should update without conflicts', async () => {
        const toBeUpdated: Partial<ScheduledStopPointInJourneyPattern> = {
          is_used_as_timing_point: true,
          is_regulated_timing_point: true,
          is_loading_time_allowed: true,
        };

        const response = await post({
          ...config.hasuraRequestTemplate,
          body: { query: buildUpdateMutation(toBeUpdated) },
        });

        expectNoErrorResponse(response);
      });
    });
  });
});
