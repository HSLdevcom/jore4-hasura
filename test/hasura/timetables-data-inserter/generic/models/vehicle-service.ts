import { defaultDayTypeIds } from 'generic/timetablesdb/datasets/defaultSetup/day-types';
import {
  VehicleScheduleFrame,
  VehicleService,
} from 'generic/timetablesdb/datasets/types';
import { omit } from 'lodash';
import { TimetablesDatasetInput } from 'timetables-data-inserter/types';
import { assignId } from 'timetables-data-inserter/utils';
import { VehicleServiceInput, VehicleServiceOutput } from '../types';
import { processBlock } from './block';

export const processVehicleService = (
  vehicleService: VehicleServiceInput,
  parentVehicleScheduleFrame: Pick<
    VehicleScheduleFrame,
    'vehicle_schedule_frame_id'
  >,
  datasetInput: TimetablesDatasetInput,
): VehicleServiceOutput => {
  const idField = 'vehicle_service_id';
  const result = assignId(vehicleService, idField);

  const blocks = result._blocks || {};
  const processedBlocks = Object.fromEntries(
    Object.values(blocks).map((child, i) => [
      Object.keys(blocks)[i],
      processBlock(child, result, datasetInput),
    ]),
  );

  return {
    day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
    ...result,
    vehicle_schedule_frame_id:
      parentVehicleScheduleFrame.vehicle_schedule_frame_id,
    _blocks: processedBlocks,
  };
};

export const vehicleServiceToDbFormat = (
  vehicleService: VehicleServiceOutput,
): VehicleService => {
  return omit(vehicleService, '_blocks');
};
