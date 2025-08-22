import { DateTime } from 'luxon';
import { vehicleScheduleFrames } from 'generic/timetablesdb/datasets/defaultSetup';
import { TimetablePriority } from 'generic/timetablesdb/datasets/types';
import { buildHslVehicleScheduleFrame } from '../factories';
import { HslVehicleScheduleFrame } from '../types';

export const hslVehicleScheduleFramesByName = {
  specialAscensionDay2023: buildHslVehicleScheduleFrame({
    vehicle_schedule_frame_id: '52c5afdb-9a04-4aed-8769-4bdb761aa6f6',
    validity_start: DateTime.fromISO('2023-05-18'),
    validity_end: DateTime.fromISO('2023-05-18'),
    priority: TimetablePriority.Special,
    name: 'Helatorstai 2023',
    created_at: DateTime.fromISO('2022-02-01T02:34:56.789+02:00'),
  }),
};

export const hslVehicleScheduleFrames: HslVehicleScheduleFrame[] =
  vehicleScheduleFrames
    .map(buildHslVehicleScheduleFrame)
    .concat(Object.values(hslVehicleScheduleFramesByName));
