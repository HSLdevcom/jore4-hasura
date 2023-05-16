import { vehicleScheduleFrames } from 'generic/timetablesdb/datasets/defaultSetup';
import { buildHslVehicleScheduleFrame } from '../factories';
import { HslVehicleScheduleFrame } from '../types';

export const hslVehicleScheduleFrames: HslVehicleScheduleFrame[] =
  vehicleScheduleFrames.map(buildHslVehicleScheduleFrame);
