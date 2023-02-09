import {
  journeyPatternRefProps,
  scheduledStopInJourneyPatternRefProps,
  timetabledPassingTimeProps,
  vehicleJourneyProps,
  vehicleScheduleFrameProps,
  vehicleServiceProps,
} from './types';

export const genericTimetablesDbTables = [
  'journey_pattern.journey_pattern_ref',
  'passing_times.timetabled_passing_time',
  'service_pattern.scheduled_stop_point_in_journey_pattern_ref',
  'vehicle_journey.vehicle_journey',
  'vehicle_schedule.vehicle_schedule_frame',
  'vehicle_service.block',
  'vehicle_service.vehicle_service',
] as const;
export type GenericTimetablesDbTables =
  (typeof genericTimetablesDbTables)[number];

export const genericTimetablesDbSchema: TableSchemaMap<GenericTimetablesDbTables> =
  {
    'journey_pattern.journey_pattern_ref': {
      name: 'journey_pattern.journey_pattern_ref',
      props: journeyPatternRefProps,
    },
    'passing_times.timetabled_passing_time': {
      name: 'passing_times.timetabled_passing_time',
      props: timetabledPassingTimeProps,
    },
    'service_pattern.scheduled_stop_point_in_journey_pattern_ref': {
      name: 'service_pattern.scheduled_stop_point_in_journey_pattern_ref',
      props: scheduledStopInJourneyPatternRefProps,
    },
    'vehicle_journey.vehicle_journey': {
      name: 'vehicle_journey.vehicle_journey',
      props: vehicleJourneyProps,
    },
    'vehicle_schedule.vehicle_schedule_frame': {
      name: 'vehicle_schedule.vehicle_schedule_frame',
      props: vehicleScheduleFrameProps,
    },

    'vehicle_service.block': {
      name: 'vehicle_service.block',
      props: vehicleServiceProps,
    },
    'vehicle_service.vehicle_service': {
      name: 'vehicle_service.vehicle_service',
      props: vehicleServiceProps,
    },
  };
