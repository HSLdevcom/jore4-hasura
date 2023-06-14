import {
  HslVehicleScheduleFrame,
  SubstituteOperatingDayByLineType,
} from 'hsl/timetablesdb/datasets/types';
import {
  GenericTimetablesDatasetInput,
  GenericTimetablesDatasetOutput,
  GenericVehicleScheduleFrameInput,
  GenericVehicleScheduleFrameOutput,
} from 'timetables-data-inserter/generic/types';

export type HslVehicleScheduleFrameInput = GenericVehicleScheduleFrameInput &
  Partial<
    Pick<HslVehicleScheduleFrame, 'booking_label' | 'booking_description_i18n'>
  >;

export type HslVehicleScheduleFrameOutput = GenericVehicleScheduleFrameOutput &
  Pick<HslVehicleScheduleFrame, 'booking_label' | 'booking_description_i18n'>;

type SubstituteOperatingDayByLineTypeWithoutGenerated = Omit<
  SubstituteOperatingDayByLineType,
  'begin_datetime' | 'end_datetime'
>;
export type SubstituteOperatingDayByLineTypeInput =
  Partial<SubstituteOperatingDayByLineTypeWithoutGenerated>;
export type SubstituteOperatingDayByLineTypeOutput =
  Required<SubstituteOperatingDayByLineTypeWithoutGenerated>;

// TODO: Partial<SubstituteOperatingPeriod> &
export type SubstituteOperatingPeriodInput = {
  _substitute_operating_day_by_line_types?: Record<
    string,
    SubstituteOperatingDayByLineTypeInput
  >;
};
// TODO: Required<SubstituteOperatingPeriod> &
export type SubstituteOperatingPeriodOutput = {
  _substitute_operating_day_by_line_types: Record<
    string,
    SubstituteOperatingDayByLineTypeOutput
  >;
};

export type HslTimetablesDatasetInput = Omit<
  GenericTimetablesDatasetInput,
  '_vehicle_schedule_frames'
> & {
  _vehicle_schedule_frames?: Record<string, HslVehicleScheduleFrameInput>;
  _substitute_operating_periods?: Record<
    string,
    SubstituteOperatingPeriodInput
  >;
};

export type HslTimetablesDatasetOutput = Omit<
  GenericTimetablesDatasetOutput,
  '_vehicle_schedule_frames'
> & {
  _vehicle_schedule_frames: Record<string, HslVehicleScheduleFrameOutput>;
  _substitute_operating_periods: Record<
    string,
    SubstituteOperatingPeriodOutput
  >;
};
