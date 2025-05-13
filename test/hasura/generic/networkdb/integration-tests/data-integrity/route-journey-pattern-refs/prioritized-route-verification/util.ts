import * as config from '@config';
import * as dataset from '@util/dataset';
import { serializeMatcherInput, serializeMatcherInputs } from '@util/dataset';
import { DbConnection } from '@util/db';
import { post, FetchResponse } from '@util/fetch-request';
import { expectErrorResponse } from '@util/response';
import { getPropNameArray, queryTable } from '@util/setup';
import { scheduledStopPoints } from 'generic/networkdb/datasets/prioritizedRouteVerification';
import { genericNetworkDbSchema } from 'generic/networkdb/datasets/schema';
import {
  CheckInfraLinkStopRefsWithNewScheduledStopPointArgs,
  InfrastructureLinkAlongRoute,
  journeyPatternProps,
  Route,
  routeProps,
  ScheduledStopPoint,
  ScheduledStopPointInJourneyPattern,
  scheduledStopPointProps,
  VehicleMode,
} from 'generic/networkdb/datasets/types';

const VEHICLE_MODE = VehicleMode.Bus;

const buildInsertStopMutation = (toBeInserted: Partial<ScheduledStopPoint>) => `
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

const buildDeleteStopMutation = (label: string, priority: number) => `
  mutation {
    delete_service_pattern_scheduled_stop_point(
      where: {
        _and: [
          { label: { _eq: "${label}" } },
          { priority: { _eq: ${priority} } }
        ]
      }
    ) {
      returning {
        ${getPropNameArray(scheduledStopPointProps).join(',')}
      }
    }
  }
`;

const buildInsertRouteMutation = (
  route: Partial<Route>,
  infraLinks: Partial<InfrastructureLinkAlongRoute>[],
  scheduledStopPointsInJourneyPattern: Partial<ScheduledStopPointInJourneyPattern>[],
) => `
  mutation {
    insert_route_route(objects: ${dataset.toGraphQlObject(
      {
        ...route,
        infrastructure_links_along_route: {
          data: infraLinks,
        },
        route_journey_patterns: {
          data: [
            {
              scheduled_stop_point_in_journey_patterns: {
                data: scheduledStopPointsInJourneyPattern,
              },
            },
          ],
        },
      },
      ['direction'],
    )}) {
      returning {
        ${getPropNameArray(routeProps).join(',')}
      }
    }
  }
`;

const buildReplaceJourneyPatternMutation = (
  route: Partial<Route>,
  scheduledStopPointsInJourneyPattern: Partial<ScheduledStopPointInJourneyPattern>[],
) => `
  mutation {
    delete_journey_pattern_journey_pattern(
      where: { on_route_id: { _eq: "${route.route_id}" } }
    ) {
      returning {
        ${getPropNameArray(journeyPatternProps).join(',')}
      }
    }
    insert_journey_pattern_journey_pattern(objects: ${dataset.toGraphQlObject({
      on_route_id: route.route_id,
      scheduled_stop_point_in_journey_patterns: {
        data: scheduledStopPointsInJourneyPattern,
      },
    })}
    ) {
      returning {
        ${getPropNameArray(journeyPatternProps).join(',')}
      }
    }
  }
`;

const buildDeleteRouteMutation = (routeId: string) => `
  mutation {
    delete_route_route(
      where: { route_id: { _eq: "${routeId}" } }
    ) {
      returning {
        ${getPropNameArray(routeProps).join(',')}
      }
    }
  }
`;

const buildCheckInfraLinkStopRefsForStopPointRemovalQuery = (
  scheduledStopPoint: Partial<ScheduledStopPoint>,
) => {
  const checkInfraLinkStopRefsWithNewScheduledStopPointArgs: CheckInfraLinkStopRefsWithNewScheduledStopPointArgs =
    {
      replace_scheduled_stop_point_id:
        scheduledStopPoint.scheduled_stop_point_id!, // eslint-disable-line @typescript-eslint/no-non-null-assertion
      new_located_on_infrastructure_link_id: null,
      new_measured_location: null,
      new_direction: null,
      new_label: null,
      new_validity_start: null,
      new_validity_end: null,
      new_priority: null,
    };

  return `
  query {
    journey_pattern_check_infra_link_stop_refs_with_new_scheduled_stop_point(args: ${dataset.toGraphQlObject(
      checkInfraLinkStopRefsWithNewScheduledStopPointArgs,
      ['new_direction'],
    )}) {
      ${getPropNameArray(journeyPatternProps).join(',')}
    }
  }
`;
};

export const insertStopPoint = (toBeInserted: Partial<ScheduledStopPoint>) =>
  post({
    ...config.hasuraRequestTemplate,
    body: { query: buildInsertStopMutation(toBeInserted) },
  });

export const deleteStopPoint = (label: string, priority: number) =>
  post({
    ...config.hasuraRequestTemplate,
    body: { query: buildDeleteStopMutation(label, priority) },
  });

export const insertRoute = (
  route: Partial<Route>,
  infraLinks: Partial<InfrastructureLinkAlongRoute>[],
  scheduledStopPointsInJourneyPattern: Partial<ScheduledStopPointInJourneyPattern>[],
) =>
  post({
    ...config.hasuraRequestTemplate,
    body: {
      query: buildInsertRouteMutation(
        route,
        infraLinks,
        scheduledStopPointsInJourneyPattern,
      ),
    },
  });

export const deleteRoute = (routeId: string) =>
  post({
    ...config.hasuraRequestTemplate,
    body: {
      query: buildDeleteRouteMutation(routeId),
    },
  });

export const replaceJourneyPattern = (
  route: Partial<Route>,
  scheduledStopPointsInJourneyPattern: Partial<ScheduledStopPointInJourneyPattern>[],
) =>
  post({
    ...config.hasuraRequestTemplate,
    body: {
      query: buildReplaceJourneyPatternMutation(
        route,
        scheduledStopPointsInJourneyPattern,
      ),
    },
  });

export const checkInfraLinkStopRefsForStopPointRemoval = (
  scheduledStopPoint: Partial<ScheduledStopPoint>,
) =>
  post({
    ...config.hasuraRequestTemplate,
    body: {
      query:
        buildCheckInfraLinkStopRefsForStopPointRemovalQuery(scheduledStopPoint),
    },
  });

export const shouldReturnErrorResponse = expectErrorResponse(
  "route's and journey pattern's traversal paths must match each other",
);

export const shouldNotModifyScheduledStopPointsInDatabase = async (
  dbConnection: DbConnection,
) => {
  const stopResponse = await queryTable(
    dbConnection,
    genericNetworkDbSchema['service_pattern.scheduled_stop_point'],
  );

  expect(stopResponse.rowCount).toEqual(scheduledStopPoints.length);
  expect(stopResponse.rows).toEqual(
    expect.arrayContaining(serializeMatcherInputs(scheduledStopPoints)),
  );
};

export const shouldReturnCorrectScheduledStopPointResponse = (
  toBeInserted: Partial<ScheduledStopPoint>,
  response: FetchResponse,
) => {
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
};

export const shouldInsertScheduledStopPointCorrectlyIntoDatabase = async (
  dbConnection: DbConnection,
  toBeInserted: Partial<ScheduledStopPoint>,
) => {
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
};

export const shouldReturnCorrectInsertRouteResponse = (
  route: Partial<Route>,
  infraLinks: Partial<InfrastructureLinkAlongRoute>[],
  scheduledStopPointsInJourneyPattern: Partial<ScheduledStopPointInJourneyPattern>[],
  response: ExplicitAny,
) => {
  expect(response).toEqual(
    expect.objectContaining({
      data: {
        insert_route_route: {
          returning: [
            {
              ...dataset.asGraphQlDateObject(route),
              route_id: expect.any(String),
            },
          ],
        },
      },
    }),
  );

  // check the new ID is a valid UUID
  expect(
    response.data.insert_route_route.returning[0].route_id,
  ).toBeValidUuid();
};

export const shouldReturnCorrectReplaceJourneyPatternResponse = (
  route: Partial<Route>,
  response: ExplicitAny,
) => {
  expect(response).toEqual(
    expect.objectContaining({
      data: {
        delete_journey_pattern_journey_pattern: {
          returning: [
            {
              journey_pattern_id: expect.any(String),
              on_route_id: route.route_id,
            },
          ],
        },
        insert_journey_pattern_journey_pattern: {
          returning: [
            {
              journey_pattern_id: expect.any(String),
              on_route_id: route.route_id,
            },
          ],
        },
      },
    }),
  );

  // check the new ID is a valid UUID
  expect(
    response.data.insert_journey_pattern_journey_pattern.returning[0]
      .journey_pattern_id,
  ).toBeValidUuid();
};
