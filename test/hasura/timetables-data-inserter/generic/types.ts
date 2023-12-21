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
export type GenericScheduledStopInJourneyPatternRefInput =
  Partial<ScheduledStopInJourneyPatternRef> & {
    scheduled_stop_point_label: string;
    scheduled_stop_point_sequence: number;
    timing_place_label?: string | null;
  };

export type GenericScheduledStopInJourneyPatternRefOutput =
  Required<ScheduledStopInJourneyPatternRef>;

export type GenericJourneyPatternRefInput = Partial<JourneyPatternRef> & {
  _stop_points?: GenericScheduledStopInJourneyPatternRefInput[];
};

export type GenericJourneyPatternRefOutput = JourneyPatternRef & {
  _stop_points: GenericScheduledStopInJourneyPatternRefOutput[];
};

export type GenericTimetabledPassingTimeInput =
  Partial<TimetabledPassingTime> & {
    _scheduled_stop_point_label: string;
  };

export type GenericTimetabledPassingTimeOutput = TimetabledPassingTime;

export type GenericVehicleJourneyInput = Partial<VehicleJourney> & {
  _journey_pattern_ref_name: string;

  _passing_times?: GenericTimetabledPassingTimeInput[];
};

export type GenericVehicleJourneyOutput = Required<VehicleJourney> & {
  _passing_times: GenericTimetabledPassingTimeOutput[];
};

export type GenericVehicleServiceBlockInput = Partial<VehicleServiceBlock> & {
  _vehicle_journeys?: Record<string, GenericVehicleJourneyInput>;
};

export type GenericVehicleServiceBlockOutput = Required<VehicleServiceBlock> & {
  _vehicle_journeys: Record<string, GenericVehicleJourneyOutput>;
};

export type GenericVehicleServiceInput = Partial<VehicleService> & {
  _blocks?: Record<string, GenericVehicleServiceBlockInput>;
};

export type GenericVehicleServiceOutput = Required<VehicleService> & {
  _blocks: Record<string, GenericVehicleServiceBlockOutput>;
};

export type GenericVehicleScheduleFrameInput = Partial<VehicleScheduleFrame> & {
  // Note: to be compatible with EntityName, the "name" should be mutually exclusive with "name_i18n".
  // Decided not to implement that since it caused problems with zod schemas. Thus, some type castings are needed related to this.
  name?: string;
  _vehicle_services?: Record<string, GenericVehicleServiceInput>;
};

export type GenericVehicleScheduleFrameOutput = VehicleScheduleFrame & {
  _vehicle_services: Record<string, GenericVehicleServiceOutput>;
};

export type GenericTimetablesDatasetInput = {
  _vehicle_schedule_frames?: Record<string, GenericVehicleScheduleFrameInput>;
  _journey_pattern_refs?: Record<string, GenericJourneyPatternRefInput>;
};

export type GenericTimetablesDatasetOutput = {
  _vehicle_schedule_frames: Record<string, GenericVehicleScheduleFrameOutput>;
  _journey_pattern_refs: Record<string, GenericJourneyPatternRefOutput>;
};
