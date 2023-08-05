import { GenericTimetablesDbTables } from 'generic/timetablesdb/datasets/schema';
import { HslTimetablesDatasetOutput } from 'timetables-data-inserter/hsl/types';
import {
  genericVehicleScheduleFrameToDbFormat,
  journeyPatternRefToDbFormat,
  scheduledStopPointToDbFormat,
  timetabledPassingTimeToDbFormat,
  vehicleJourneyToDbFormat,
  vehicleServiceBlockToDbFormat,
  vehicleServiceToDbFormat,
} from './models';
import {
  GenericTimetablesDatasetOutput,
  GenericVehicleScheduleFrameOutput,
} from './types';

export const flattenDatasetBase = (
  dataset: GenericTimetablesDatasetOutput | HslTimetablesDatasetOutput,
) => {
  const vehicleScheduleFrames = Object.values(
    dataset._vehicle_schedule_frames || {},
  );
  const vehicleServices = vehicleScheduleFrames.flatMap((vsf) =>
    Object.values(vsf._vehicle_services || {}),
  );
  const blocks = vehicleServices.flatMap((vsf) =>
    Object.values(vsf._blocks || {}),
  );
  const vehicleJourneys = blocks.flatMap((vsf) =>
    Object.values(vsf._vehicle_journeys || {}),
  );
  const passingTimes = vehicleJourneys.flatMap(
    (vsf) => vsf._passing_times || [],
  );
  const journeyPatternRefs = Object.values(dataset._journey_pattern_refs || {});
  const stopPoints = journeyPatternRefs.flatMap((jpr) => jpr._stop_points);

  return {
    vehicleScheduleFrames,
    vehicleServices,
    blocks,
    vehicleJourneys,
    passingTimes,
    journeyPatternRefs,
    stopPoints,
  };
};

export const flattenGenericDataset = (
  dataset: GenericTimetablesDatasetOutput,
) => {
  const flattened = flattenDatasetBase(dataset);
  return {
    ...flattened,
    vehicleScheduleFrames:
      flattened.vehicleScheduleFrames as GenericVehicleScheduleFrameOutput[],
  };
};

export const createGenericTableData = (
  builtDataset: GenericTimetablesDatasetOutput,
): TableData<GenericTimetablesDbTables>[] => {
  const flattenedDataset = flattenGenericDataset(builtDataset);

  const tableData: TableData<GenericTimetablesDbTables>[] = [
    {
      name: 'vehicle_schedule.vehicle_schedule_frame',
      data: flattenedDataset.vehicleScheduleFrames.map(
        genericVehicleScheduleFrameToDbFormat,
      ),
    },
    {
      name: 'vehicle_service.vehicle_service',
      data: flattenedDataset.vehicleServices.map(vehicleServiceToDbFormat),
    },
    {
      name: 'vehicle_service.block',
      data: flattenedDataset.blocks.map(vehicleServiceBlockToDbFormat),
    },
    {
      name: 'journey_pattern.journey_pattern_ref',
      data: flattenedDataset.journeyPatternRefs.map(
        journeyPatternRefToDbFormat,
      ),
    },
    {
      name: 'service_pattern.scheduled_stop_point_in_journey_pattern_ref',
      data: flattenedDataset.stopPoints.map(scheduledStopPointToDbFormat),
    },
    {
      name: 'vehicle_journey.vehicle_journey',
      data: flattenedDataset.vehicleJourneys.map(vehicleJourneyToDbFormat),
    },
    {
      name: 'passing_times.timetabled_passing_time',
      data: flattenedDataset.passingTimes.map(timetabledPassingTimeToDbFormat),
    },
  ];

  return tableData;
};
