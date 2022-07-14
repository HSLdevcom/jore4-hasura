import {
  JourneyPattern,
  ScheduledStopPointInJourneyPattern,
} from '@datasets/types';
import { routes } from './routes';
import { scheduledStopPoints } from './scheduled-stop-points';

export const journeyPatterns: JourneyPattern[] = [
  {
    journey_pattern_id: '285723ef-159f-40fb-a3cb-e8101f40ce8a',
    on_route_id: routes[0].route_id,
  },
  {
    journey_pattern_id: '0a906946-be10-4541-80ab-48f3de8baedd',
    on_route_id: routes[1].route_id,
  },
  {
    journey_pattern_id: 'fa11a09a-23c8-4bb0-b319-847f56aec05a',
    on_route_id: routes[5].route_id,
  },
  {
    journey_pattern_id: 'dac8139e-9793-4e5f-b4d6-285412e43799',
    on_route_id: routes[6].route_id,
  },
];

export const scheduledStopPointInJourneyPattern: ScheduledStopPointInJourneyPattern[] =
  [
    {
      journey_pattern_id: journeyPatterns[0].journey_pattern_id,
      scheduled_stop_point_label: scheduledStopPoints[0].label,
      scheduled_stop_point_sequence: 100,
      is_timing_point: true,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    },
    {
      journey_pattern_id: journeyPatterns[0].journey_pattern_id,
      scheduled_stop_point_label: scheduledStopPoints[1].label,
      scheduled_stop_point_sequence: 200,
      is_timing_point: false,
      is_via_point: true,
      via_point_name_i18n: { fi_FI: 'via FI', sv_FI: 'via SV' },
      via_point_short_name_i18n: {
        fi_FI: 'via short FI',
        sv_FI: 'via short SV',
      },
    },
    {
      journey_pattern_id: journeyPatterns[0].journey_pattern_id,
      scheduled_stop_point_label: scheduledStopPoints[2].label,
      scheduled_stop_point_sequence: 300,
      is_timing_point: true,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    },
    {
      journey_pattern_id: journeyPatterns[1].journey_pattern_id,
      scheduled_stop_point_label: scheduledStopPoints[3].label,
      scheduled_stop_point_sequence: 100,
      is_timing_point: true,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    },
    {
      journey_pattern_id: journeyPatterns[1].journey_pattern_id,
      scheduled_stop_point_label: scheduledStopPoints[4].label,
      scheduled_stop_point_sequence: 200,
      is_timing_point: true,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    },
    {
      journey_pattern_id: journeyPatterns[2].journey_pattern_id,
      scheduled_stop_point_label: scheduledStopPoints[6].label,
      scheduled_stop_point_sequence: 100,
      is_timing_point: true,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    },
    {
      journey_pattern_id: journeyPatterns[2].journey_pattern_id,
      scheduled_stop_point_label: scheduledStopPoints[7].label,
      scheduled_stop_point_sequence: 200,
      is_timing_point: false,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    },
    {
      journey_pattern_id: journeyPatterns[2].journey_pattern_id,
      scheduled_stop_point_label: scheduledStopPoints[8].label,
      scheduled_stop_point_sequence: 300,
      is_timing_point: true,
      is_via_point: true,
      via_point_name_i18n: { fi_FI: 'via another FI', sv_FI: 'via another SV' },
      via_point_short_name_i18n: {
        fi_FI: 'via another short FI',
        sv_FI: 'via another short SV',
      },
    },
    {
      journey_pattern_id: journeyPatterns[3].journey_pattern_id,
      scheduled_stop_point_label: scheduledStopPoints[3].label,
      scheduled_stop_point_sequence: 100,
      is_timing_point: true,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    },
    {
      journey_pattern_id: journeyPatterns[3].journey_pattern_id,
      scheduled_stop_point_label: scheduledStopPoints[1].label,
      scheduled_stop_point_sequence: 200,
      is_timing_point: false,
      is_via_point: true,
      via_point_name_i18n: { fi_FI: 'via FI', sv_FI: 'via SV' },
      via_point_short_name_i18n: {
        fi_FI: 'via short FI',
        sv_FI: 'via short SV',
      },
    },
    {
      journey_pattern_id: journeyPatterns[3].journey_pattern_id,
      scheduled_stop_point_label: scheduledStopPoints[2].label,
      scheduled_stop_point_sequence: 300,
      is_timing_point: true,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    },
  ];
