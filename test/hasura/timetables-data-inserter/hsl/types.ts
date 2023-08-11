import {
  HslVehicleScheduleFrame,
  SubstituteOperatingDayByLineType,
  SubstituteOperatingPeriod,
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

export type SubstituteOperatingPeriodInput =
  Partial<SubstituteOperatingPeriod> & {
    _substitute_operating_day_by_line_types?: Record<
      string,
      SubstituteOperatingDayByLineTypeInput
    >;
  };

export type SubstituteOperatingPeriodOutput =
  Required<SubstituteOperatingPeriod> & {
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
