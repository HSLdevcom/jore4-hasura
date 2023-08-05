import { TypeOfLine } from 'generic/timetablesdb/datasets/types';
import { DayOfWeek } from 'hsl/timetablesdb/datasets/types';
import {
  dateSchema,
  durationSchema,
  genericTimetablesJsonSchema,
  vehicleScheduleFrameSchema as genericVehicleScheduleFrameSchema,
  localizedStringSchema,
} from 'timetables-data-inserter/generic/json-schemas';
import { z } from 'zod';

// Borrowed from related Luxon issue discussion: https://github.com/moment/luxon/issues/353#issuecomment-1262828949
// eslint-disable-next-line @typescript-eslint/no-explicit-any
const validTimezones = (Intl as any).supportedValuesOf('timeZone');
export const timezoneSchema = z
  .string()
  .refine((timezone) => validTimezones.includes(timezone));

const hslVehicleScheduleFramesSchema = genericVehicleScheduleFrameSchema.extend(
  {
    booking_label: z.string().optional(),
    booking_description_i18n: localizedStringSchema.optional(),
  },
);

const substituteOperatingDayByLineTypeSchema = z.object({
  substitute_operating_day_by_line_type_id: z.string().uuid().optional(),
  type_of_line: z.nativeEnum(TypeOfLine).optional(),
  superseded_date: dateSchema.optional(),
  substitute_day_of_week: z.nativeEnum(DayOfWeek).nullable().optional(),
  begin_time: durationSchema.nullable().optional(),
  end_time: durationSchema.nullable().optional(),
  timezone: timezoneSchema.optional(),
});

const substituteOperatingPeriodSchema = z.object({
  _substitute_operating_day_by_line_types: z
    .record(substituteOperatingDayByLineTypeSchema)
    .optional(),
});

export const hslTimetablesJsonSchema = genericTimetablesJsonSchema.extend({
  _vehicle_schedule_frames: z.record(hslVehicleScheduleFramesSchema).optional(),
  _substitute_operating_periods: z
    .record(substituteOperatingPeriodSchema)
    .optional(),
});
