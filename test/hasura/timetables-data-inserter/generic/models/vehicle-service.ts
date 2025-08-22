import { omit } from 'lodash';
import {
  VehicleScheduleFrame,
  VehicleService,
} from 'generic/timetablesdb/datasets/types';
import { defaultDayTypeIds } from 'timetables-data-inserter/day-types';
import { TimetablesDatasetInput } from 'timetables-data-inserter/types';
import { assignId } from 'timetables-data-inserter/utils';
import {
  GenericVehicleServiceInput,
  GenericVehicleServiceOutput,
} from '../types';
import { processGenericBlock } from './block';

const getVehicleServiceDefaults = () => ({
  day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
});

export const processGenericVehicleService = (
  vehicleService: GenericVehicleServiceInput,
  parentVehicleScheduleFrame: Pick<
    VehicleScheduleFrame,
    'vehicle_schedule_frame_id'
  >,
  datasetInput: TimetablesDatasetInput,
): GenericVehicleServiceOutput => {
  const idField = 'vehicle_service_id';
  const result = assignId(vehicleService, idField);

  const blocks = result._blocks || {};
  const processedBlocks = Object.fromEntries(
    Object.values(blocks).map((child, i) => [
      Object.keys(blocks)[i],
      processGenericBlock(child, result, datasetInput),
    ]),
  );

  return {
    ...getVehicleServiceDefaults(),
    ...result,
    vehicle_schedule_frame_id:
      parentVehicleScheduleFrame.vehicle_schedule_frame_id,
    _blocks: processedBlocks,
  };
};

export const vehicleServiceToDbFormat = (
  vehicleService: GenericVehicleServiceOutput,
): VehicleService => {
  return omit(vehicleService, '_blocks');
};
