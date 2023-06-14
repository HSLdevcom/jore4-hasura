import { EntityName, buildName } from 'generic/timetablesdb/datasets/factories';
import {
  TimetablePriority,
  VehicleScheduleFrame,
} from 'generic/timetablesdb/datasets/types';
import { omit } from 'lodash';
import { DateTime } from 'luxon';
import { assignId } from 'timetables-data-inserter/utils';
import {
  GenericTimetablesDatasetInput,
  GenericVehicleScheduleFrameInput,
  GenericVehicleScheduleFrameOutput,
} from '../types';
import { processVehicleService } from './vehicle-service';

export const processGenericVehicleScheduleFrame = (
  vehicleScheduleFrame: GenericVehicleScheduleFrameInput,
  datasetInput: GenericTimetablesDatasetInput,
): GenericVehicleScheduleFrameOutput => {
  const idField = 'vehicle_schedule_frame_id';
  const result = assignId(vehicleScheduleFrame, idField);

  const vehicleServices = result._vehicle_services || {};
  const processedVehicleServices = Object.fromEntries(
    Object.values(vehicleServices).map((child, i) => [
      Object.keys(vehicleServices)[i],
      processVehicleService(child, result, datasetInput),
    ]),
  );

  return {
    label: buildName(result as EntityName).fi_FI,
    name_i18n: buildName(result as EntityName),
    validity_start: DateTime.fromISO('2023-01-01'),
    validity_end: DateTime.fromISO('2023-12-31'),
    priority: TimetablePriority.Standard,
    ...omit(result, 'name'),
    _vehicle_services: processedVehicleServices,
  };
};

export const genericVehicleScheduleFrameToDbFormat = (
  vehicleScheduleFrame: GenericVehicleScheduleFrameOutput,
): VehicleScheduleFrame => {
  return {
    ...omit(vehicleScheduleFrame, '_vehicle_services'),
  };
};
