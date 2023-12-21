import {
  HslVehicleScheduleFrame,
  SubstituteOperatingDayByLineType,
  SubstituteOperatingPeriod,
} from 'hsl/timetablesdb/datasets/types';
import {
  GenericTimetablesDatasetInput,
  GenericTimetablesDatasetOutput,
  GenericVehicleJourneyInput,
  GenericVehicleJourneyOutput,
  GenericVehicleScheduleFrameInput,
  GenericVehicleScheduleFrameOutput,
  GenericVehicleServiceBlockInput,
  GenericVehicleServiceBlockOutput,
  GenericVehicleServiceInput,
  GenericVehicleServiceOutput,
} from 'timetables-data-inserter/generic/types';

export type HslVehicleScheduleFrameInput = Omit<
  GenericVehicleScheduleFrameInput,
  '_vehicle_services'
> & { _vehicle_services?: Record<string, HslVehicleServiceInput> } & Partial<
    Pick<HslVehicleScheduleFrame, 'booking_label' | 'booking_description_i18n'>
  >;

export type HslVehicleScheduleFrameOutput = Omit<
  GenericVehicleScheduleFrameOutput,
  '_vehicle_services'
> & { _vehicle_services: Record<string, HslVehicleServiceOutput> } & Pick<
    HslVehicleScheduleFrame,
    'booking_label' | 'booking_description_i18n'
  >;

export type HslVehicleServiceInput = Omit<
  GenericVehicleServiceInput,
  '_blocks'
> & { _blocks?: Record<string, HslVehicleServiceBlockInput> };

export type HslVehicleServiceOutput = Omit<
  GenericVehicleServiceOutput,
  '_blocks'
> & { _blocks: Record<string, HslVehicleServiceBlockOutput> };

export type HslVehicleServiceBlockInput = Omit<
  GenericVehicleServiceBlockInput,
  '_vehicle_journeys'
> & { _vehicle_journeys?: Record<string, HslVehicleJourneyInput> };

export type HslVehicleServiceBlockOutput = Omit<
  GenericVehicleServiceBlockOutput,
  '_vehicle_journeys'
> & { _vehicle_journeys: Record<string, HslVehicleJourneyOutput> };

export type HslVehicleJourneyInput = GenericVehicleJourneyInput;

export type HslVehicleJourneyOutput = GenericVehicleJourneyOutput;

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
