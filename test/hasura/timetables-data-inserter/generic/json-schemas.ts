import { DateTime, Duration } from 'luxon';
import { z } from 'zod';
import { TypeOfLine } from 'generic/networkdb/datasets/types';
import {
  RouteDirection,
  TimetablePriority,
} from 'generic/timetablesdb/datasets/types';
import { defaultDayTypeIds } from '../day-types';

// TODO: could add some validation?
export const dateSchema = z
  .string()
  .transform((dateTime) => DateTime.fromISO(dateTime));

export const dateTimeSchema = z
  .string()
  .datetime({ offset: true })
  .transform((dateTime) => DateTime.fromISO(dateTime));

export const durationSchema = z
  .string()
  .transform((duration) => Duration.fromISO(duration))
  .refine((duration) => duration.isValid);

export const localizedStringSchema = z
  .object({
    fi_FI: z.string(),
    sv_FI: z.string(),
  })
  .strict()
  .transform((name) => name as LocalizedString);

// Design choice: pass these enums by key value instead of the final value. Makes reading the easier.
// TODO: could this be done automagically? Should contain all possible keys of TimetablePriority.
// Currently fails with invalid keys like supposed to, but does not detect new keys.
const timetablePriorities = [
  'Standard',
  'Temporary',
  'Special',
  'Draft',
  'Staging',
] as const;

const defaultDayTypeIdKeys = [
  'MONDAY_THURSDAY',
  'MONDAY_FRIDAY',
  'MONDAY',
  'TUESDAY',
  'WEDNESDAY',
  'THURSDAY',
  'FRIDAY',
  'SATURDAY',
  'SUNDAY',
] as const;

const stopPointSchema = z
  .object({
    scheduled_stop_point_label: z.string(),
    scheduled_stop_point_sequence: z.number(),
    timing_place_label: z.string().optional(),
  })
  .strict();

const journeyPatternRefSchema = z
  .object({
    journey_pattern_ref_id: z.string().uuid().optional(),
    journey_pattern_id: z.string().uuid().optional(),
    observation_timestamp: dateTimeSchema.optional(),
    snapshot_timestamp: dateTimeSchema.optional(),
    type_of_line: z.nativeEnum(TypeOfLine).optional(),
    route_label: z.string().optional(),
    route_direction: z.nativeEnum(RouteDirection).optional(),
    route_validity_start: dateSchema.optional(),
    route_validity_end: dateSchema.optional(),

    _stop_points: z.array(stopPointSchema).optional(),
  })
  .strict();

export const timetabledPassingTimeSchema = z
  .object({
    timetabled_passing_time_id: z.string().uuid().optional(),
    arrival_time: durationSchema.nullable().optional(),
    departure_time: durationSchema.nullable().optional(),
    vehicle_journey_id: z.string().uuid().optional(),
    scheduled_stop_point_in_journey_pattern_ref_id: z
      .string()
      .uuid()
      .optional(),
    _scheduled_stop_point_label: z.string(),
  })
  .strict();

export const vehicleJourneySchema = z
  .object({
    vehicle_journey_id: z.string().uuid().optional(),
    block_id: z.string().uuid().optional(),
    journey_pattern_ref_id: z.string().uuid().optional(),

    _journey_pattern_ref_name: z.string(),
    _passing_times: z.array(timetabledPassingTimeSchema).optional(),
  })
  .strict();

export const vehicleServiceBlockSchema = z
  .object({
    block_id: z.string().uuid().optional(),
    vehicle_service_id: z.string().uuid().optional(),

    _vehicle_journeys: z.record(vehicleJourneySchema).optional(),
  })
  .strict();

export const vehicleServiceSchema = z
  .object({
    vehicle_service_id: z.string().uuid().optional(),
    day_type_id: z
      .enum(defaultDayTypeIdKeys)
      .transform((dayTypeIdKey) => defaultDayTypeIds[dayTypeIdKey])
      .or(z.string().uuid()),
    vehicle_schedule_frame_id: z.string().uuid().optional(),

    _blocks: z.record(vehicleServiceBlockSchema).optional(),
  })
  .strict();

export const vehicleScheduleFrameSchema = z
  .object({
    vehicle_schedule_frame_id: z.string().uuid().optional(),
    label: z.string().optional(),
    // Note: ideally name and name_18n would be mutually exclusive, but there doesn't seem to be a way to implement that with zod.
    name: z.string().optional(),
    name_i18n: localizedStringSchema.optional(),
    validity_start: dateSchema.optional(),
    validity_end: dateSchema.optional(),
    priority: z
      .enum(timetablePriorities)
      .transform((priority) => TimetablePriority[priority])
      .optional(),
    created_at: dateTimeSchema.optional(),

    _vehicle_services: z.record(vehicleServiceSchema).optional(),
  })
  .strict();

export const genericTimetablesJsonSchema = z
  .object({
    _vehicle_schedule_frames: z.record(vehicleScheduleFrameSchema).optional(),
    _journey_pattern_refs: z.record(journeyPatternRefSchema).optional(),
  })
  .strict();
