/* eslint-disable camelcase */
import {
  buildName,
  buildVehicleScheduleFrame,
} from 'generic/timetablesdb/datasets/factories';
import { VehicleScheduleFrame } from 'generic/timetablesdb/datasets/types';
import { HslVehicleScheduleFrame } from './types';

type VehicleScheduleFrameParams = Parameters<
  typeof buildVehicleScheduleFrame
>[0];

export const buildHslVehicleScheduleFrame = (
  input: VehicleScheduleFrameParams & Partial<HslVehicleScheduleFrame>,
): HslVehicleScheduleFrame => {
  const { booking_label, booking_description_i18n, ...rest } = input;
  return {
    ...buildVehicleScheduleFrame(rest as VehicleScheduleFrame),
    booking_label: booking_label || buildName(input).fi_FI,
    booking_description_i18n,
  };
};
