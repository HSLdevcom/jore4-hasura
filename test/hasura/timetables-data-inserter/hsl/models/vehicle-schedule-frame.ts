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

  return {
    booking_label: buildName(vehicleScheduleFrame as EntityName).fi_FI,
    booking_description_i18n: undefined,
    ...genericFrame,
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
