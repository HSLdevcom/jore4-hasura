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
];

export const scheduledStopPointInJourneyPattern: ScheduledStopPointInJourneyPattern[] =
  [
    {
      journey_pattern_id: journeyPatterns[0].journey_pattern_id,
      scheduled_stop_point_id: scheduledStopPoints[0].scheduled_stop_point_id,
      scheduled_stop_point_sequence: 100,
      is_timing_point: true,
      is_via_point: false,
    },
    {
      journey_pattern_id: journeyPatterns[0].journey_pattern_id,
      scheduled_stop_point_id: scheduledStopPoints[1].scheduled_stop_point_id,
      scheduled_stop_point_sequence: 200,
      is_timing_point: false,
      is_via_point: true,
    },
    {
      journey_pattern_id: journeyPatterns[0].journey_pattern_id,
      scheduled_stop_point_id: scheduledStopPoints[2].scheduled_stop_point_id,
      scheduled_stop_point_sequence: 300,
      is_timing_point: true,
      is_via_point: false,
    },
    {
      journey_pattern_id: journeyPatterns[1].journey_pattern_id,
      scheduled_stop_point_id: scheduledStopPoints[3].scheduled_stop_point_id,
      scheduled_stop_point_sequence: 100,
      is_timing_point: true,
      is_via_point: false,
    },
    {
      journey_pattern_id: journeyPatterns[1].journey_pattern_id,
      scheduled_stop_point_id: scheduledStopPoints[4].scheduled_stop_point_id,
      scheduled_stop_point_sequence: 200,
      is_timing_point: true,
      is_via_point: false,
    },
    {
      journey_pattern_id: journeyPatterns[2].journey_pattern_id,
      scheduled_stop_point_id: scheduledStopPoints[6].scheduled_stop_point_id,
      scheduled_stop_point_sequence: 100,
      is_timing_point: true,
      is_via_point: false,
    },
    {
      journey_pattern_id: journeyPatterns[2].journey_pattern_id,
      scheduled_stop_point_id: scheduledStopPoints[7].scheduled_stop_point_id,
      scheduled_stop_point_sequence: 200,
      is_timing_point: false,
      is_via_point: true,
    },
    {
      journey_pattern_id: journeyPatterns[2].journey_pattern_id,
      scheduled_stop_point_id: scheduledStopPoints[8].scheduled_stop_point_id,
      scheduled_stop_point_sequence: 300,
      is_timing_point: true,
      is_via_point: false,
    },
  ];
