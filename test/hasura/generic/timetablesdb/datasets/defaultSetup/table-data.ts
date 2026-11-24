import { GenericTimetablesDbTables } from '../schema';
import { journeyPatternRefs } from './journey-pattern-refs';
import { timetabledPassingTimes } from './passing-times';
import { scheduledStopPointsInJourneyPatternRef } from './stop-points';
import { vehicleJourneys } from './vehicle-journeys';
import { vehicleScheduleFrames } from './vehicle-schedules-frames';
import { vehicleServiceBlocks } from './vehicle-service-blocks';
import { vehicleServices } from './vehicle-services';

export const defaultGenericTimetablesDbData: TableData<GenericTimetablesDbTables>[] =
  [
    {
      name: 'timetables.vehicle_schedule_frame',
      data: vehicleScheduleFrames,
    },
    {
      name: 'timetables.vehicle_service',
      data: vehicleServices,
    },
    {
      name: 'timetables.block',
      data: vehicleServiceBlocks,
    },
    {
      name: 'timetables.journey_pattern_ref',
      data: journeyPatternRefs,
    },
    {
      name: 'timetables.scheduled_stop_point_in_journey_pattern_ref',
      data: scheduledStopPointsInJourneyPatternRef,
    },
    {
      name: 'timetables.vehicle_journey',
      data: vehicleJourneys,
    },
    {
      name: 'timetables.timetabled_passing_time',
      data: timetabledPassingTimes,
    },
  ];
