import { defaultJourneyPatternRefsByName } from './journey-pattern-refs';
import {
  christmas2022VehicleScheduleFrame,
  summer2023VehicleScheduleFrame,
  winter2022VehicleScheduleFrame,
} from './vehicle-schedule-frames';

export const defaultTimetablesDataset = {
  _vehicle_schedule_frames: {
    winter2022: winter2022VehicleScheduleFrame,
    christmas2022: christmas2022VehicleScheduleFrame,
    summer2023: summer2023VehicleScheduleFrame,
  },

  _journey_pattern_refs: defaultJourneyPatternRefsByName,
};
