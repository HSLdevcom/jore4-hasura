import {
  JourneyPatternRef,
  ScheduledStopInJourneyPatternRef,
  TimetabledPassingTime,
  VehicleJourney,
  VehicleScheduleFrame,
  VehicleService,
  VehicleServiceBlock,
} from 'generic/timetablesdb/datasets/types';

// TODO: we should be able to assign at least sequence automagically.
export type ScheduledStopInJourneyPatternRefInput = RequiredKeys<
  Partial<ScheduledStopInJourneyPatternRef>,
  'scheduled_stop_point_label' | 'scheduled_stop_point_sequence'
>;

export type ScheduledStopInJourneyPatternRefOutput =
  Required<ScheduledStopInJourneyPatternRef>;

export type JourneyPatternRefInput = Partial<JourneyPatternRef> & {
  _stop_points?: ScheduledStopInJourneyPatternRefInput[];
};

export type JourneyPatternRefOutput = JourneyPatternRef & {
  _stop_points: ScheduledStopInJourneyPatternRefOutput[];
};

export type TimetabledPassingTimeInput = Partial<TimetabledPassingTime> & {
  _scheduled_stop_point_label: string;
};

export type TimetabledPassingTimeOutput = TimetabledPassingTime;

export type VehicleJourneyInput = Partial<VehicleJourney> & {
  _journey_pattern_ref_name: string;

  _passing_times?: TimetabledPassingTimeInput[];
};

export type VehicleJourneyOutput = Required<VehicleJourney> & {
  _passing_times: TimetabledPassingTimeOutput[];
};

export type VehicleServiceBlockInput = Partial<VehicleServiceBlock> & {
  _vehicle_journeys?: Record<string, VehicleJourneyInput>;
};

export type VehicleServiceBlockOutput = Required<VehicleServiceBlock> & {
  _vehicle_journeys: Record<string, VehicleJourneyOutput>;
};

export type VehicleServiceInput = Partial<VehicleService> & {
  _blocks?: Record<string, VehicleServiceBlockInput>;
};

export type VehicleServiceOutput = Required<VehicleService> & {
  _blocks: Record<string, VehicleServiceBlockOutput>;
};

export type GenericVehicleScheduleFrameInput = Partial<VehicleScheduleFrame> & {
  // Note: to be compatible with EntityName, the "name" should be mutually exclusive with "name_i18n".
  // Decided not to implement that since it caused problems with zod schemas. Thus, some type castings are needed related to this.
  name?: string;
  _vehicle_services?: Record<string, VehicleServiceInput>;
};

export type GenericVehicleScheduleFrameOutput = VehicleScheduleFrame & {
  _vehicle_services: Record<string, VehicleServiceOutput>;
};

export type GenericTimetablesDatasetInput = {
  _vehicle_schedule_frames?: Record<string, GenericVehicleScheduleFrameInput>;
  _journey_pattern_refs?: Record<string, JourneyPatternRefInput>;
};

export type GenericTimetablesDatasetOutput = {
  _vehicle_schedule_frames: Record<string, GenericVehicleScheduleFrameOutput>;
  _journey_pattern_refs: Record<string, JourneyPatternRefOutput>;
};
