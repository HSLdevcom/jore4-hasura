import {
  JourneyPattern,
  ScheduledStopPointInJourneyPattern,
} from '@datasets/types';
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
      is_timing_point: true,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    },
    {
      journey_pattern_id: basicJourneyPattern.journey_pattern_id,
      scheduled_stop_point_label:
        scheduledStopPointsOfBasicJourneyPattern[1].label,
      scheduled_stop_point_sequence: 2,
      is_timing_point: true,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    },
    {
      journey_pattern_id: basicJourneyPattern.journey_pattern_id,
      scheduled_stop_point_label:
        scheduledStopPointsOfBasicJourneyPattern[2].label,
      scheduled_stop_point_sequence: 3,
      is_timing_point: true,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    },
    {
      journey_pattern_id: basicJourneyPattern.journey_pattern_id,
      scheduled_stop_point_label:
        scheduledStopPointsOfBasicJourneyPattern[3].label,
      scheduled_stop_point_sequence: 4,
      is_timing_point: true,
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
      (scheduledStopPointInJourneyPattern) => {
        if (
          scheduledStopPointInJourneyPattern.scheduled_stop_point_label ===
            undefined ||
          scheduledStopPointInJourneyPattern.scheduled_stop_point_sequence ===
            undefined ||
          scheduledStopPointInJourneyPattern.is_timing_point === undefined ||
          scheduledStopPointInJourneyPattern.is_via_point === undefined
        ) {
          throw new TypeError(
            'Invalid entry in scheduledStopPointInTempJourneyPatternWithoutConflictingInfraLinkStop',
          );
        }
        return Object.assign({}, scheduledStopPointInJourneyPattern, {
          journey_pattern_id: journeyPatternOnTempRoute.journey_pattern_id,
          scheduled_stop_point_label:
            scheduledStopPointInJourneyPattern.scheduled_stop_point_label,
          scheduled_stop_point_sequence:
            scheduledStopPointInJourneyPattern.scheduled_stop_point_sequence,
          is_timing_point: scheduledStopPointInJourneyPattern.is_timing_point,
          is_via_point: scheduledStopPointInJourneyPattern.is_via_point,
        });
      },
    ),
  ];