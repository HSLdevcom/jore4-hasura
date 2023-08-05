import { HslTimetablesDbTables } from 'hsl/timetablesdb/datasets/schema';
import {
  journeyPatternRefToDbFormat,
  scheduledStopPointToDbFormat,
  timetabledPassingTimeToDbFormat,
  vehicleJourneyToDbFormat,
  vehicleServiceBlockToDbFormat,
  vehicleServiceToDbFormat,
} from 'timetables-data-inserter/generic/models';
import { flattenDatasetBase } from 'timetables-data-inserter/generic/table-data';
import {
  hslVehicleScheduleFrameToDbFormat,
  substituteOperatingDayByLineTypeToDbFormat,
} from './models';
import {
  HslTimetablesDatasetOutput,
  HslVehicleScheduleFrameOutput,
} from './types';

export const flattenHslDataset = <T extends HslTimetablesDatasetOutput>(
  dataset: T,
) => {
  const flattened = flattenDatasetBase(dataset);
  const substituteOperatingPeriods = Object.values(
    dataset._substitute_operating_periods || {},
  );
  const substituteOperatingDayByLineTypeIds =
    substituteOperatingPeriods.flatMap((period) =>
      Object.values(period._substitute_operating_day_by_line_types || {}),
    );
  return {
    ...flattened,
    vehicleScheduleFrames:
      flattened.vehicleScheduleFrames as HslVehicleScheduleFrameOutput[],
    substituteOperatingPeriods,
    substituteOperatingDayByLineTypeIds,
  };
};

export const createHslTableData = (
  builtDataset: HslTimetablesDatasetOutput,
): TableData<HslTimetablesDbTables>[] => {
  const flattenedDataset = flattenHslDataset(builtDataset);

  const tableData: TableData<HslTimetablesDbTables>[] = [
    {
      name: 'vehicle_schedule.vehicle_schedule_frame',
      data: flattenedDataset.vehicleScheduleFrames.map(
        hslVehicleScheduleFrameToDbFormat,
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
    // TODO: service_calendar.substitute_operating_period
    {
      name: 'service_calendar.substitute_operating_day_by_line_type',
      data: flattenedDataset.substituteOperatingDayByLineTypeIds.map(
        substituteOperatingDayByLineTypeToDbFormat,
      ),
    },
  ];

  return tableData;
};
