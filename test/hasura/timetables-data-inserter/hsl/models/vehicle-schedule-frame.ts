import { EntityName, buildName } from 'generic/timetablesdb/datasets/factories';
import { HslVehicleScheduleFrame } from 'hsl/timetablesdb/datasets/types';
import { pick } from 'lodash';
import {
  genericVehicleScheduleFrameToDbFormat,
  processGenericVehicleScheduleFrame,
} from 'timetables-data-inserter/generic/models';
import {
  HslTimetablesDatasetInput,
  HslVehicleScheduleFrameInput,
  HslVehicleScheduleFrameOutput,
} from '../types';
import { processHslVehicleService } from './vehicle-service';

const getVehicleScheduleFrameDefaults = (vehicleScheduleFrame: EntityName) => ({
  booking_label: buildName(vehicleScheduleFrame).fi_FI,
});

export const processHslVehicleScheduleFrame = <
  T extends HslVehicleScheduleFrameInput,
>(
  vehicleScheduleFrame: T,
  datasetInput: HslTimetablesDatasetInput,
): HslVehicleScheduleFrameOutput => {
  const genericFrame = processGenericVehicleScheduleFrame(
    vehicleScheduleFrame,
    datasetInput,
  );
  const result = genericFrame;

  const vehicleServices = vehicleScheduleFrame._vehicle_services || {};
  const processedVehicleServices = Object.fromEntries(
    Object.values(vehicleServices).map((child, i) => [
      Object.keys(vehicleServices)[i],
      processHslVehicleService(child, result, datasetInput),
    ]),
  );

  return {
    ...getVehicleScheduleFrameDefaults(vehicleScheduleFrame as EntityName),
    ...result,
    _vehicle_services: processedVehicleServices,
  };
};

export const hslVehicleScheduleFrameToDbFormat = (
  vehicleScheduleFrame: HslVehicleScheduleFrameOutput,
): HslVehicleScheduleFrame => {
  return {
    ...genericVehicleScheduleFrameToDbFormat(vehicleScheduleFrame),
    ...pick(vehicleScheduleFrame, 'booking_label', 'booking_description_i18n'),
  };
};
