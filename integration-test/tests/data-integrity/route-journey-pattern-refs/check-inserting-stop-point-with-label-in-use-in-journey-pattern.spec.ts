import * as pg from 'pg';
import * as config from '@config';
import '@util/matchers';
import { getPropNameArray, queryTable, setupDb } from '@datasets/setup';
import { route116TableConfig } from '@datasets/route116';
import {
  scheduledStopPoints,
  scheduledStopPointWithSameLabelAndOnSameLink,
  scheduledStopPointWithSameLabelOnLinkAfterNextStop,
  scheduledStopPointWithSameLabelOnLinkAfterNextStopWithNonOverlappingValidityTime,
  scheduledStopPointWithSameLabelOnLinkOfPrevStopAfterPrevStop,
  scheduledStopPointWithSameLabelOnLinkOfPrevStopBeforePrevStop,
  scheduledStopPointWithSameLabelOnPrevLink,
  scheduledStopPointWithSameLabelOnSameLinkAfterNextStop,
} from '@datasets/route116/scheduled-stop-points';
import {
  CheckInfraLinkStopRefsWithNewScheduledStopPointArgs,
  JourneyPatternProps,
  ScheduledStopPoint,
} from '@datasets/types';
import * as dataset from '@util/dataset';
import * as rp from 'request-promise';
import { asDbGeometryObjectArray } from '@util/dataset';
import { journeyPatterns } from '@datasets/route116/journey-patterns';

const buildQuery = (toBeInserted: Partial<ScheduledStopPoint>) => {
  const checkInfraLinkStopRefsWithNewScheduledStopPointArgs: CheckInfraLinkStopRefsWithNewScheduledStopPointArgs =
    {
      replace_scheduled_stop_point_id: null,
      new_located_on_infrastructure_link_id:
        toBeInserted.located_on_infrastructure_link_id!,
      new_measured_location: toBeInserted.measured_location!,
      new_direction: toBeInserted.direction!,
      new_label: toBeInserted.label!,
      new_validity_start: toBeInserted.validity_start!,
      new_validity_end: toBeInserted.validity_end!,
      new_priority: toBeInserted.priority!,
    };

  return `
  query {
    journey_pattern_check_infra_link_stop_refs_with_new_scheduled_stop_point(args: ${dataset.toGraphQlObject(
      checkInfraLinkStopRefsWithNewScheduledStopPointArgs,
      ['new_direction'],
    )}) {
      ${getPropNameArray(JourneyPatternProps).join(',')}
    }
  }
`;
};

describe('Checking inserting a stop point with a label in use in a journey pattern', () => {
  let dbConnectionPool: pg.Pool;

  beforeAll(() => {
    dbConnectionPool = new pg.Pool(config.databaseConfig);
  });

  afterAll(() => dbConnectionPool.end());

  beforeEach(() => setupDb(dbConnectionPool, route116TableConfig));

  const shouldNotModifyDatabase = (toBeInserted: Partial<ScheduledStopPoint>) =>
    it('should not modify the database', async () => {
      await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildQuery(toBeInserted) },
      });

      const stopResponse = await queryTable(
        dbConnectionPool,
        'service_pattern.scheduled_stop_point',
        route116TableConfig,
      );

      expect(stopResponse.rowCount).toEqual(scheduledStopPoints.length);
      expect(stopResponse.rows).toEqual(
        expect.arrayContaining(
          asDbGeometryObjectArray(scheduledStopPoints, ['measured_location']),
        ),
      );
    });

  const shouldReturnExpectedResponse = (
    toBeInserted: Partial<ScheduledStopPoint>,
    expectedJourneyPatterns: string[],
  ) =>
    it('should return expected response', async () => {
      const response = await rp.post({
        ...config.hasuraRequestTemplate,
        body: { query: buildQuery(toBeInserted) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            journey_pattern_check_infra_link_stop_refs_with_new_scheduled_stop_point:
              expect.arrayContaining(
                expectedJourneyPatterns.map((journeyPatternId) => ({
                  journey_pattern_id: journeyPatternId,
                  on_route_id: expect.any(String),
                })),
              ),
          },
        }),
      );

      expect(
        response.data
          .journey_pattern_check_infra_link_stop_refs_with_new_scheduled_stop_point
          .length,
      ).toEqual(expectedJourneyPatterns.length);
    });

  describe('with different priority, the same label and on the same link as another stop', () => {
    shouldReturnExpectedResponse(
      scheduledStopPointWithSameLabelAndOnSameLink,
      [],
    );
    shouldNotModifyDatabase(scheduledStopPointWithSameLabelAndOnSameLink);
  });

  describe('with different priority, the same label and on the link previous to the link of another stop', () => {
    shouldReturnExpectedResponse(scheduledStopPointWithSameLabelOnPrevLink, []);
    shouldNotModifyDatabase(scheduledStopPointWithSameLabelOnPrevLink);
  });

  describe('with different priority, the same label, on the same link as this and the next stop, after the next stop', () => {
    shouldReturnExpectedResponse(
      scheduledStopPointWithSameLabelOnSameLinkAfterNextStop,
      [journeyPatterns[0].journey_pattern_id],
    );
    shouldNotModifyDatabase(
      scheduledStopPointWithSameLabelOnSameLinkAfterNextStop,
    );
  });

  describe('with draft priority, the same label, on the same link as this and the next stop, after the next stop', () => {
    const scheduledStopPointWithSameLabelOnSameLinkAfterNextStopWithDraftPriority =
      {
        ...scheduledStopPointWithSameLabelOnSameLinkAfterNextStop,
        priority: 30,
      };

    shouldReturnExpectedResponse(
      scheduledStopPointWithSameLabelOnSameLinkAfterNextStopWithDraftPriority,
      [],
    );
    shouldNotModifyDatabase(
      scheduledStopPointWithSameLabelOnSameLinkAfterNextStopWithDraftPriority,
    );
  });

  describe('with different priority, the same label and on a link after the link of the next stop with non-overlapping validity time', () => {
    shouldReturnExpectedResponse(
      scheduledStopPointWithSameLabelOnLinkAfterNextStopWithNonOverlappingValidityTime,
      [],
    );
    shouldNotModifyDatabase(
      scheduledStopPointWithSameLabelOnLinkAfterNextStopWithNonOverlappingValidityTime,
    );
  });

  describe('with different priority, the same label and on a link after the link of the next stop with overlapping validity time', () => {
    shouldReturnExpectedResponse(
      scheduledStopPointWithSameLabelOnLinkAfterNextStop,
      [journeyPatterns[0].journey_pattern_id],
    );
    shouldNotModifyDatabase(scheduledStopPointWithSameLabelOnLinkAfterNextStop);
  });

  describe('with draft priority, the same label and on a link after the link of the next stop with overlapping validity time', () => {
    const scheduledStopPointWithSameLabelOnLinkAfterNextStopWithDraftPriority =
      {
        ...scheduledStopPointWithSameLabelOnLinkAfterNextStop,
        priority: 30,
      };

    shouldReturnExpectedResponse(
      scheduledStopPointWithSameLabelOnLinkAfterNextStopWithDraftPriority,
      [],
    );
    shouldNotModifyDatabase(
      scheduledStopPointWithSameLabelOnLinkAfterNextStopWithDraftPriority,
    );
  });

  describe('with different priority, the same label, on the same link as the previous stop, after the previous stop', () => {
    shouldReturnExpectedResponse(
      scheduledStopPointWithSameLabelOnLinkOfPrevStopAfterPrevStop,
      [],
    );
    shouldNotModifyDatabase(scheduledStopPointWithSameLabelOnLinkAfterNextStop);
  });

  describe('with different priority, the same label, on the same link as the previous stop, before the previous stop', () => {
    shouldReturnExpectedResponse(
      scheduledStopPointWithSameLabelOnLinkOfPrevStopBeforePrevStop,
      [journeyPatterns[0].journey_pattern_id],
    );
    shouldNotModifyDatabase(
      scheduledStopPointWithSameLabelOnLinkOfPrevStopBeforePrevStop,
    );
  });

  describe('with draft priority, the same label, on the same link as the previous stop, before the previous stop', () => {
    const scheduledStopPointWithSameLabelOnLinkOfPrevStopBeforePrevStopWithDraftPriority =
      {
        ...scheduledStopPointWithSameLabelOnLinkOfPrevStopBeforePrevStop,
        priority: 30,
      };

    shouldReturnExpectedResponse(
      scheduledStopPointWithSameLabelOnLinkOfPrevStopBeforePrevStopWithDraftPriority,
      [],
    );
    shouldNotModifyDatabase(
      scheduledStopPointWithSameLabelOnLinkOfPrevStopBeforePrevStopWithDraftPriority,
    );
  });
});
