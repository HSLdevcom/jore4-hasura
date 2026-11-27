import {
  journeyPatternRefProps,
  journeyPatternsInVehicleServiceProps,
  scheduledStopInJourneyPatternRefProps,
  timetabledPassingTimeProps,
  vehicleJourneyProps,
  vehicleScheduleFrameProps,
  vehicleServiceBlockProps,
  vehicleServiceProps,
} from './types';

export const genericTimetablesDbTables = [
  'timetables.journey_pattern_ref',
  'timetables.timetabled_passing_time',
  'timetables.scheduled_stop_point_in_journey_pattern_ref',
  'timetables.vehicle_journey',
  'timetables.vehicle_schedule_frame',
  'timetables.block',
  'timetables.vehicle_service',
  'timetables.journey_patterns_in_vehicle_service',
] as const;
export type GenericTimetablesDbTables =
  (typeof genericTimetablesDbTables)[number];

export const genericTimetablesDbSchema: TableSchemaMap<GenericTimetablesDbTables> =
  {
    'timetables.journey_pattern_ref': {
      name: 'timetables.journey_pattern_ref',
      props: journeyPatternRefProps,
    },
    'timetables.timetabled_passing_time': {
      name: 'timetables.timetabled_passing_time',
      props: timetabledPassingTimeProps,
    },
    'timetables.scheduled_stop_point_in_journey_pattern_ref': {
      name: 'timetables.scheduled_stop_point_in_journey_pattern_ref',
      props: scheduledStopInJourneyPatternRefProps,
    },
    'timetables.vehicle_journey': {
      name: 'timetables.vehicle_journey',
      props: vehicleJourneyProps,
    },
    'timetables.vehicle_schedule_frame': {
      name: 'timetables.vehicle_schedule_frame',
      props: vehicleScheduleFrameProps,
    },
    'timetables.block': {
      name: 'timetables.block',
      props: vehicleServiceBlockProps,
    },
    'timetables.vehicle_service': {
      name: 'timetables.vehicle_service',
      props: vehicleServiceProps,
    },
    'timetables.journey_patterns_in_vehicle_service': {
      name: 'timetables.journey_patterns_in_vehicle_service',
      props: journeyPatternsInVehicleServiceProps,
    },
  };
