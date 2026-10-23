import { parseDateTime, serializeDateTime } from '@util/time';

describe('Temporal equality testers', () => {
  it('compares plain dates by value', () => {
    expect(Temporal.PlainDate.from('2023-01-01')).toEqual(
      Temporal.PlainDate.from('2023-01-01'),
    );
    expect(Temporal.PlainDate.from('2023-01-01')).not.toEqual(
      Temporal.PlainDate.from('2023-01-02'),
    );
  });

  it('compares zoned date times by value', () => {
    expect(parseDateTime('2023-01-01T00:00:00Z')).toEqual(
      parseDateTime('2023-01-01T02:00:00+02:00'),
    );
    expect(parseDateTime('2023-01-01T00:00:00Z')).not.toEqual(
      parseDateTime('2023-01-01T00:00:01Z'),
    );
  });

  it('compares durations by value and against strings', () => {
    expect(Temporal.Duration.from('PT1H')).toEqual(
      Temporal.Duration.from('PT1H'),
    );
    expect(Temporal.Duration.from('PT1H')).not.toEqual(
      Temporal.Duration.from('PT2H'),
    );
    expect(Temporal.Duration.from('PT1H')).toEqual('PT1H');
  });

  it('compares equivalent durations with different units as equal', () => {
    expect(Temporal.Duration.from('PT1H')).toEqual(
      Temporal.Duration.from('PT60M'),
    );
    expect(Temporal.Duration.from('P1D')).toEqual(
      Temporal.Duration.from('PT24H'),
    );
    expect(Temporal.Duration.from('PT1H')).toEqual('PT60M');
  });

  it('compares durations with calendar units without a reference point', () => {
    expect(Temporal.Duration.from('P1M')).toEqual(
      Temporal.Duration.from('P1M'),
    );
    expect(Temporal.Duration.from('P1M')).not.toEqual(
      Temporal.Duration.from('P30D'),
    );
  });

  it('does not consider a duration equal to a non-duration string', () => {
    expect(Temporal.Duration.from('PT1H')).not.toEqual('not-a-duration');
  });

  it('compares temporal types that are not yet used in datasets by value', () => {
    expect(Temporal.PlainTime.from('10:00')).toEqual(
      Temporal.PlainTime.from('10:00'),
    );
    expect(Temporal.PlainTime.from('10:00')).not.toEqual(
      Temporal.PlainTime.from('23:59'),
    );

    expect(Temporal.Instant.from('2023-01-01T00:00:00Z')).not.toEqual(
      Temporal.Instant.from('2024-06-06T12:00:00Z'),
    );
    expect(Temporal.PlainDateTime.from('2023-01-01T00:00')).not.toEqual(
      Temporal.PlainDateTime.from('2030-09-09T09:09'),
    );
    expect(Temporal.PlainYearMonth.from('2023-01')).not.toEqual(
      Temporal.PlainYearMonth.from('2023-02'),
    );
    expect(Temporal.PlainMonthDay.from('01-01')).not.toEqual(
      Temporal.PlainMonthDay.from('01-02'),
    );
  });

  it('does not consider different temporal types equal', () => {
    expect(Temporal.PlainDate.from('2023-01-01')).not.toEqual(
      Temporal.PlainDateTime.from('2023-01-01T00:00'),
    );
  });

  it('serializes zoned date times without a time zone annotation', () => {
    expect(serializeDateTime(parseDateTime('2023-07-01T00:00:00Z'))).toBe(
      '2023-07-01T03:00:00+03:00',
    );
  });
});
