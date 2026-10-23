import { dateSchema, dateTimeSchema, durationSchema } from './json-schemas';

describe('Temporal JSON schemas', () => {
  it('parses dates', () => {
    expect(dateSchema.parse('2023-01-02')).toEqual(
      Temporal.PlainDate.from('2023-01-02'),
    );
  });

  it('rejects date times as dates instead of silently dropping their offset', () => {
    expect(dateSchema.safeParse('2023-01-02T23:00:00Z').success).toBe(false);
  });

  it('parses offset date times in the Helsinki time zone', () => {
    expect(dateTimeSchema.parse('2023-07-01T00:00:00Z')).toEqual(
      Temporal.ZonedDateTime.from('2023-07-01T03:00:00+03:00[Europe/Helsinki]'),
    );
  });

  it('parses valid durations', () => {
    expect(durationSchema.parse('PT7H55M')).toEqual(
      Temporal.Duration.from('PT7H55M'),
    );
  });

  it('reports invalid durations as validation errors', () => {
    expect(durationSchema.safeParse('not-a-duration').success).toBe(false);
  });
});
