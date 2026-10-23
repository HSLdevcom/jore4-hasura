export const TIME_ZONE = 'Europe/Helsinki';

const temporalConstructors = [
  Temporal.Duration,
  Temporal.Instant,
  Temporal.PlainDate,
  Temporal.PlainDateTime,
  Temporal.PlainMonthDay,
  Temporal.PlainTime,
  Temporal.PlainYearMonth,
  Temporal.ZonedDateTime,
];

export function isTemporalValue(
  value: unknown,
): value is { toString(): string } {
  return temporalConstructors.some(
    (temporalConstructor) => value instanceof temporalConstructor,
  );
}

export function parseDate(value: string): Temporal.PlainDate {
  return Temporal.PlainDate.from(value);
}

export function parseDateTime(value: string): Temporal.ZonedDateTime {
  return Temporal.Instant.from(value).toZonedDateTimeISO(TIME_ZONE);
}

// "timestamp without time zone" carries no offset. Postgres hands these out in
// the database's local time, which for our databases is Helsinki time.
export function parseTimestamp(value: string): Temporal.ZonedDateTime {
  return Temporal.PlainDateTime.from(value).toZonedDateTime(TIME_ZONE);
}

export function serializeDateTime(value: Temporal.ZonedDateTime): string {
  return value.toString({ timeZoneName: 'never' });
}

// Temporal.ZonedDateTime.toJSON() appends a "[Europe/Helsinki]" annotation,
// which neither Hasura nor Postgres accepts. Used as a JSON.stringify replacer,
// this substitutes a plain offset timestamp instead. The original value has to
// be read from the holder, since the replacer only sees the toJSON() result.
export function replaceTemporalJsonValue(
  this: object,
  key: string,
  value: unknown,
): unknown {
  const originalValue = Reflect.get(this, key);
  return originalValue instanceof Temporal.ZonedDateTime
    ? serializeDateTime(originalValue)
    : value;
}
