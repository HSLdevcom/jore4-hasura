import {
  JourneyPattern,
  ScheduledStopPointInJourneyPattern,
} from '@datasets-generic/types';
import { basicRoute, tempRouteWithOtherLinks } from './routes';
import { scheduledStopPointsOfBasicJourneyPattern } from './scheduled-stop-points';

export const basicJourneyPattern: JourneyPattern = {
  journey_pattern_id: '285723ef-159f-40fb-a3cb-e8101f40ce8a',
  on_route_id: basicRoute.route_id,
};

export const journeyPatternOnTempRoute: JourneyPattern = {
  journey_pattern_id: 'a7865270-b2bd-4fa6-b639-b4bad6dcec8d',
  on_route_id: tempRouteWithOtherLinks.route_id,
};

export const journeyPatterns: JourneyPattern[] = [basicJourneyPattern];
export const journeyPatternsWithTempRoute: JourneyPattern[] = [
  basicJourneyPattern,
  journeyPatternOnTempRoute,
];

export const scheduledStopPointInBasicJourneyPattern: ScheduledStopPointInJourneyPattern[] =
  [
    {
      journey_pattern_id: basicJourneyPattern.journey_pattern_id,
      scheduled_stop_point_label:
        scheduledStopPointsOfBasicJourneyPattern[0].label,
      scheduled_stop_point_sequence: 1,
      is_used_as_timing_point: true,
      is_loading_time_allowed: false,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    },
    {
      journey_pattern_id: basicJourneyPattern.journey_pattern_id,
      scheduled_stop_point_label:
        scheduledStopPointsOfBasicJourneyPattern[1].label,
      scheduled_stop_point_sequence: 2,
      is_used_as_timing_point: true,
      is_loading_time_allowed: false,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    },
    {
      journey_pattern_id: basicJourneyPattern.journey_pattern_id,
      scheduled_stop_point_label:
        scheduledStopPointsOfBasicJourneyPattern[2].label,
      scheduled_stop_point_sequence: 3,
      is_used_as_timing_point: true,
      is_loading_time_allowed: false,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    },
    {
      journey_pattern_id: basicJourneyPattern.journey_pattern_id,
      scheduled_stop_point_label:
        scheduledStopPointsOfBasicJourneyPattern[3].label,
      scheduled_stop_point_sequence: 4,
      is_used_as_timing_point: true,
      is_loading_time_allowed: false,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    },
  ];

export const scheduledStopPointInTempJourneyPatternWithoutConflictingOrderStop: Partial<ScheduledStopPointInJourneyPattern>[] =
  scheduledStopPointInBasicJourneyPattern
    .filter(
      (scheduledStopPointInJourneyPattern) =>
        scheduledStopPointInJourneyPattern.scheduled_stop_point_sequence !== 3,
    )
    .map((scheduledStopPointInJourneyPattern, index) => ({
      ...scheduledStopPointInJourneyPattern,
      journey_pattern_id: undefined,
      scheduled_stop_point_sequence: index,
    }));

export const scheduledStopPointInTempJourneyPatternWithoutConflictingInfraLinkStop: Partial<ScheduledStopPointInJourneyPattern>[] =
  scheduledStopPointInBasicJourneyPattern
    .filter(
      (scheduledStopPointInJourneyPattern) =>
        scheduledStopPointInJourneyPattern.scheduled_stop_point_sequence !== 2,
    )
    .map((scheduledStopPointInJourneyPattern, index) => ({
      ...scheduledStopPointInJourneyPattern,
      journey_pattern_id: undefined,
      scheduled_stop_point_sequence: index,
    }));

export const scheduledStopPointInTempJourneyPatternWithSameStops: Partial<ScheduledStopPointInJourneyPattern>[] =
  scheduledStopPointInBasicJourneyPattern.map(
    (scheduledStopPointInJourneyPattern) => ({
      ...scheduledStopPointInJourneyPattern,
      journey_pattern_id: undefined,
    }),
  );

export const scheduledStopPointInJourneyPattern: ScheduledStopPointInJourneyPattern[] =
  scheduledStopPointInBasicJourneyPattern;
export const scheduledStopPointInJourneyPatternWithTempRoute: ScheduledStopPointInJourneyPattern[] =
  [
    ...scheduledStopPointInBasicJourneyPattern,
    ...scheduledStopPointInTempJourneyPatternWithSameStops.map(
      (stopInJourneyPattern) => {
        // Create clone the scheduledStopPointInJourneyPattern object and set our custom properties on the clone.
        // Note that we need Object.assign({}, ...) to leave the original object untouched. (If we would
        // modify it, other tests would fail because of that.)
        return {
          ...stopInJourneyPattern,
          journey_pattern_id: journeyPatternOnTempRoute.journey_pattern_id,
        } as ScheduledStopPointInJourneyPattern;
      },
    ),
  ];
