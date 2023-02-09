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
      name: 'vehicle_schedule.vehicle_schedule_frame',
      data: vehicleScheduleFrames,
    },
    {
      name: 'vehicle_service.vehicle_service',
      data: vehicleServices,
    },
    {
      name: 'vehicle_service.block',
      data: vehicleServiceBlocks,
    },
    {
      name: 'journey_pattern.journey_pattern_ref',
      data: journeyPatternRefs,
    },
    {
      name: 'service_pattern.scheduled_stop_point_in_journey_pattern_ref',
      data: scheduledStopPointsInJourneyPatternRef,
    },
    {
      name: 'vehicle_journey.vehicle_journey',
      data: vehicleJourneys,
    },
    {
      name: 'passing_times.timetabled_passing_time',
      data: timetabledPassingTimes,
    },
  ];
