/* eslint-disable camelcase */
import {
  buildName,
  buildVehicleScheduleFrame,
} from 'generic/timetablesdb/datasets/factories';
import { HslVehicleScheduleFrame } from './types';

type BuildVehicleScheduleFrameParams = Parameters<
  typeof buildVehicleScheduleFrame
>[0];

export const buildHslVehicleScheduleFrame = (
  input: BuildVehicleScheduleFrameParams & Partial<HslVehicleScheduleFrame>,
): HslVehicleScheduleFrame => {
  const { booking_label, booking_description_i18n, ...rest } = input;
  return {
    ...buildVehicleScheduleFrame(rest),
    booking_label: booking_label || buildName(input).fi_FI,
    booking_description_i18n,
  };
};
