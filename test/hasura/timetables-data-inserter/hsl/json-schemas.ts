import { z } from 'zod';
import { TypeOfLine } from 'generic/timetablesdb/datasets/types';
import { DayOfWeek } from 'hsl/timetablesdb/datasets/types';
import {
  dateSchema,
  durationSchema,
  genericTimetablesJsonSchema,
  vehicleJourneySchema as genericVehicleJourneySchema,
  vehicleScheduleFrameSchema as genericVehicleScheduleFrameSchema,
  vehicleServiceBlockSchema as genericVehicleServiceBlockSchema,
  vehicleServiceSchema as genericVehicleServiceSchema,
  localizedStringSchema,
} from 'timetables-data-inserter/generic/json-schemas';

// Borrowed from related Luxon issue discussion: https://github.com/moment/luxon/issues/353#issuecomment-1262828949
// eslint-disable-next-line @typescript-eslint/no-explicit-any
const validTimezones = (Intl as any).supportedValuesOf('timeZone');
export const timezoneSchema = z
  .string()
  .refine((timezone) => validTimezones.includes(timezone));

export const hslVehicleJourneySchema = genericVehicleJourneySchema.extend({
  contract_number: z.string().optional(),
});

export const hslVehicleServiceBlockSchema =
  genericVehicleServiceBlockSchema.extend({
    _vehicle_journeys: z.record(hslVehicleJourneySchema).optional(),
  });

export const hslVehicleServiceSchema = genericVehicleServiceSchema.extend({
  _blocks: z.record(hslVehicleServiceBlockSchema).optional(),
});

const hslVehicleScheduleFramesSchema = genericVehicleScheduleFrameSchema.extend(
  {
    booking_label: z.string().optional(),
    booking_description_i18n: localizedStringSchema.optional(),
    _vehicle_services: z.record(hslVehicleServiceSchema).optional(),
  },
);

const substituteOperatingDayByLineTypeSchema = z
  .object({
    substitute_operating_day_by_line_type_id: z.string().uuid().optional(),
    type_of_line: z.nativeEnum(TypeOfLine).optional(),
    superseded_date: dateSchema.optional(),
    substitute_day_of_week: z.nativeEnum(DayOfWeek).nullable().optional(),
    begin_time: durationSchema.nullable().optional(),
    end_time: durationSchema.nullable().optional(),
    timezone: timezoneSchema.optional(),
  })
  .strict();

const substituteOperatingPeriodSchema = z
  .object({
    _substitute_operating_day_by_line_types: z
      .record(substituteOperatingDayByLineTypeSchema)
      .optional(),
  })
  .strict();

export const hslTimetablesJsonSchema = genericTimetablesJsonSchema.extend({
  _vehicle_schedule_frames: z.record(hslVehicleScheduleFramesSchema).optional(),
  _substitute_operating_periods: z
    .record(substituteOperatingPeriodSchema)
    .optional(),
});
