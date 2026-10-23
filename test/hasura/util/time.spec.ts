import {
  isTemporalValue,
  parseTimestamp,
  replaceTemporalJsonValue,
  serializeDateTime,
} from '@util/time';

describe('time utilities', () => {
  describe('parseTimestamp', () => {
    it('interprets a timestamp without a time zone as Helsinki time', () => {
      expect(serializeDateTime(parseTimestamp('2023-07-01 03:00:00'))).toBe(
        '2023-07-01T03:00:00+03:00',
      );
    });

    it('accepts the space separated format Postgres uses', () => {
      expect(parseTimestamp('2023-01-01 12:00:00')).toEqual(
        parseTimestamp('2023-01-01T12:00:00'),
      );
    });
  });

  describe('isTemporalValue', () => {
    it('recognizes every temporal type', () => {
      expect(isTemporalValue(Temporal.PlainDate.from('2023-01-01'))).toBe(true);
      expect(isTemporalValue(Temporal.Duration.from('PT1H'))).toBe(true);
      expect(isTemporalValue(Temporal.PlainTime.from('10:00'))).toBe(true);
      expect(
        isTemporalValue(Temporal.Instant.from('2023-01-01T00:00:00Z')),
      ).toBe(true);
    });

    it('does not recognize other values', () => {
      expect(isTemporalValue('2023-01-01')).toBe(false);
      expect(isTemporalValue(new Date())).toBe(false);
      expect(isTemporalValue(null)).toBe(false);
    });
  });

  describe('replaceTemporalJsonValue', () => {
    it('serializes zoned date times without a time zone annotation', () => {
      const value = {
        created_at: Temporal.Instant.from(
          '2023-07-01T00:00:00Z',
        ).toZonedDateTimeISO('Europe/Helsinki'),
      };

      expect(JSON.stringify(value, replaceTemporalJsonValue)).toBe(
        '{"created_at":"2023-07-01T03:00:00+03:00"}',
      );
    });

    it('leaves other temporal types to their own serialization', () => {
      const value = {
        validity_start: Temporal.PlainDate.from('2023-01-01'),
        arrival_time: Temporal.Duration.from('PT7H55M'),
      };

      expect(JSON.stringify(value, replaceTemporalJsonValue)).toBe(
        '{"validity_start":"2023-01-01","arrival_time":"PT7H55M"}',
      );
    });
  });
});
