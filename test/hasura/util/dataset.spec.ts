import { serializeInsertValue, toGraphQlObject } from '@util/dataset';

const zonedDateTime = Temporal.Instant.from(
  '2023-07-01T00:00:00Z',
).toZonedDateTimeISO('Europe/Helsinki');

describe('dataset serialization', () => {
  describe('serializeInsertValue', () => {
    it('serializes zoned date times without a time zone annotation', () => {
      expect(serializeInsertValue(zonedDateTime)).toBe(
        '2023-07-01T03:00:00+03:00',
      );
    });

    it('serializes the other temporal types', () => {
      expect(serializeInsertValue(Temporal.PlainDate.from('2023-01-01'))).toBe(
        '2023-01-01',
      );
      expect(serializeInsertValue(Temporal.Duration.from('PT7H55M'))).toBe(
        'PT7H55M',
      );
      expect(serializeInsertValue(Temporal.PlainTime.from('10:00'))).toBe(
        '10:00:00',
      );
      expect(
        serializeInsertValue(Temporal.PlainDateTime.from('2023-01-01T10:00')),
      ).toBe('2023-01-01T10:00:00');
    });

    it('passes other values through', () => {
      expect(serializeInsertValue('label')).toBe('label');
      expect(serializeInsertValue(null)).toBeNull();
    });
  });

  describe('toGraphQlObject', () => {
    it('serializes zoned date times without a time zone annotation', () => {
      expect(toGraphQlObject({ created_at: zonedDateTime })).toBe(
        '{created_at:"2023-07-01T03:00:00+03:00"}',
      );
    });

    it('serializes the other temporal types', () => {
      // Passing enumProps, as the production call sites do: with an empty list
      // the enum regex degenerates and strips quotes from any single-word
      // value, which is a pre-existing quirk unrelated to temporal handling.
      expect(
        toGraphQlObject(
          {
            validity_start: Temporal.PlainDate.from('2023-01-01'),
            arrival_time: Temporal.Duration.from('PT7H55M'),
          },
          ['type_of_line'],
        ),
      ).toBe('{validity_start:"2023-01-01",arrival_time:"PT7H55M"}');
    });
  });
});
