import * as config from '@config';
import * as dataset from '@util/dataset';
import { serializeMatcherInput, serializeMatcherInputs } from '@util/dataset';
import { closeDbConnection, createDbConnection, DbConnection } from '@util/db';
import { post } from '@util/fetch-request';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import {
  route116TableConfig,
  scheduledStopPoints,
  scheduledStopPointWithSameLabelAndOnSameLink,
  scheduledStopPointWithSameLabelOnLinkAfterNextStop,
  scheduledStopPointWithSameLabelOnLinkAfterNextStopWithNonOverlappingValidityTime,
  scheduledStopPointWithSameLabelOnLinkOfPrevStopAfterPrevStop,
  scheduledStopPointWithSameLabelOnLinkOfPrevStopBeforePrevStop,
  scheduledStopPointWithSameLabelOnPrevLink,
  scheduledStopPointWithSameLabelOnSameLinkAfterNextStop,
} from 'generic/networkdb/datasets/route116';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import {
  ScheduledStopPoint,
  scheduledStopPointProps,
  VehicleMode,
} from 'generic/networkdb/datasets/types';

const VEHICLE_MODE = VehicleMode.Bus;

const buildMutation = (toBeInserted: Partial<ScheduledStopPoint>) => `
  mutation {
    insert_service_pattern_scheduled_stop_point(objects: ${dataset.toGraphQlObject(
      {
        ...toBeInserted,
        vehicle_mode_on_scheduled_stop_point: {
          data: {
            vehicle_mode: VEHICLE_MODE,
          },
        },
      },
      ['direction', 'vehicle_mode'],
    )}) {
      returning {
        ${getPropNameArray(scheduledStopPointProps).join(',')}
      }
    }
  }
`;

describe('Inserting a stop point with a label in use in a journey pattern', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() => setupDb(dbConnection, route116TableConfig));

  const shouldReturnErrorResponse = (
    toBeInserted: Partial<ScheduledStopPoint>,
  ) =>
    it('should return error response', async () => {
      await post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      }).then(
        expectErrorResponse(
          "route's and journey pattern's traversal paths must match each other",
        ),
      );
    });

  const shouldNotModifyDatabase = (toBeInserted: Partial<ScheduledStopPoint>) =>
    it('should not modify the database', async () => {
      await post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      const stopResponse = await queryTable(
        dbConnection,
        genericNetworkDbSchema['service_pattern.scheduled_stop_point'],
      );

      expect(stopResponse.rowCount).toEqual(scheduledStopPoints.length);
      expect(stopResponse.rows).toEqual(
        expect.arrayContaining(serializeMatcherInputs(scheduledStopPoints)),
      );
    });

  const shouldReturnCorrectResponse = (
    toBeInserted: Partial<ScheduledStopPoint>,
  ) =>
    it('should return correct response', async () => {
      const response = await post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      expect(response).toEqual(
        expect.objectContaining({
          data: {
            insert_service_pattern_scheduled_stop_point: {
              returning: [
                {
                  ...dataset.asGraphQlDateObject(toBeInserted),
                  scheduled_stop_point_id: expect.any(String),
                },
              ],
            },
          },
        }),
      );

      // check the new ID is a valid UUID
      expect(
        response.data.insert_service_pattern_scheduled_stop_point.returning[0]
          .scheduled_stop_point_id,
      ).toBeValidUuid();
    });

  const shouldInsertCorrectRowIntoDatabase = (
    toBeInserted: Partial<ScheduledStopPoint>,
  ) =>
    it('should insert correct row into the database', async () => {
      await post({
        ...config.hasuraRequestTemplate,
        body: { query: buildMutation(toBeInserted) },
      });

      const response = await queryTable(
        dbConnection,
        genericNetworkDbSchema['service_pattern.scheduled_stop_point'],
      );

      expect(response.rowCount).toEqual(scheduledStopPoints.length + 1);

      expect(response.rows).toEqual(
        expect.arrayContaining([
          {
            ...serializeMatcherInput(toBeInserted),
            scheduled_stop_point_id: expect.any(String),
          },
          ...serializeMatcherInputs(scheduledStopPoints),
        ]),
      );
    });

  describe('with different priority, the same label and on the same link as another stop', () => {
    shouldReturnCorrectResponse(scheduledStopPointWithSameLabelAndOnSameLink);
    shouldInsertCorrectRowIntoDatabase(
      scheduledStopPointWithSameLabelAndOnSameLink,
    );
  });

  describe('with different priority, the same label and on the link previous to the link of another stop', () => {
    shouldReturnCorrectResponse(scheduledStopPointWithSameLabelOnPrevLink);
    shouldInsertCorrectRowIntoDatabase(
      scheduledStopPointWithSameLabelOnPrevLink,
    );
  });

  describe('with different priority, the same label, on the same link as this and the next stop, after the next stop', () => {
    shouldReturnErrorResponse(
      scheduledStopPointWithSameLabelOnSameLinkAfterNextStop,
    );
    shouldNotModifyDatabase(
      scheduledStopPointWithSameLabelOnSameLinkAfterNextStop,
    );
  });

  describe('with different priority, the same label, on the same link as this and the next stop, after the next stop with draft priority', () => {
    const scheduledStopPointWithSameLabelOnSameLinkAfterNextStopWithDraftPriority =
      {
        ...scheduledStopPointWithSameLabelOnSameLinkAfterNextStop,
        priority: 30,
      };

    shouldReturnCorrectResponse(
      scheduledStopPointWithSameLabelOnSameLinkAfterNextStopWithDraftPriority,
    );
    shouldInsertCorrectRowIntoDatabase(
      scheduledStopPointWithSameLabelOnSameLinkAfterNextStopWithDraftPriority,
    );
  });

  describe('with different priority, the same label and on a link after the link of the next stop with non-overlapping validity time', () => {
    shouldReturnCorrectResponse(
      scheduledStopPointWithSameLabelOnLinkAfterNextStopWithNonOverlappingValidityTime,
    );
    shouldInsertCorrectRowIntoDatabase(
      scheduledStopPointWithSameLabelOnLinkAfterNextStopWithNonOverlappingValidityTime,
    );
  });

  describe('with different priority, the same label and on a link after the link of the next stop with overlapping validity time', () => {
    shouldReturnErrorResponse(
      scheduledStopPointWithSameLabelOnLinkAfterNextStop,
    );
    shouldNotModifyDatabase(scheduledStopPointWithSameLabelOnLinkAfterNextStop);
  });

  describe('with different priority, the same label and on a link after the link of the next stop with overlapping validity time with draft priority', () => {
    const scheduledStopPointWithSameLabelOnLinkAfterNextStopWithDraftPriority =
      {
        ...scheduledStopPointWithSameLabelOnLinkAfterNextStop,
        priority: 30,
      };

    shouldReturnCorrectResponse(
      scheduledStopPointWithSameLabelOnLinkAfterNextStopWithDraftPriority,
    );
    shouldInsertCorrectRowIntoDatabase(
      scheduledStopPointWithSameLabelOnLinkAfterNextStopWithDraftPriority,
    );
  });

  describe('with different priority, the same label, on the same link as the previous stop, after the previous stop', () => {
    shouldReturnCorrectResponse(
      scheduledStopPointWithSameLabelOnLinkOfPrevStopAfterPrevStop,
    );
    shouldInsertCorrectRowIntoDatabase(
      scheduledStopPointWithSameLabelOnLinkOfPrevStopAfterPrevStop,
    );
  });

  describe('with different priority, the same label, on the same link as the previous stop, before the previous stop', () => {
    shouldReturnErrorResponse(
      scheduledStopPointWithSameLabelOnLinkOfPrevStopBeforePrevStop,
    );
    shouldNotModifyDatabase(
      scheduledStopPointWithSameLabelOnLinkOfPrevStopBeforePrevStop,
    );
  });

  describe('with different priority, the same label, on the same link as the previous stop, before the previous stop with draft priority', () => {
    const scheduledStopPointWithSameLabelOnLinkOfPrevStopBeforePrevStopWithDraftPriority =
      {
        ...scheduledStopPointWithSameLabelOnLinkOfPrevStopBeforePrevStop,
        priority: 30,
      };

    shouldReturnCorrectResponse(
      scheduledStopPointWithSameLabelOnLinkOfPrevStopBeforePrevStopWithDraftPriority,
    );
    shouldInsertCorrectRowIntoDatabase(
      scheduledStopPointWithSameLabelOnLinkOfPrevStopBeforePrevStopWithDraftPriority,
    );
  });
});
