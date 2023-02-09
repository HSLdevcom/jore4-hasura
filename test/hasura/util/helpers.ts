import { DateTime } from 'luxon';

export function throwError(msg: string): never {
  throw new Error(msg);
}

export const newDateTime = (year: number, month: number, date: number) => {
  const newDate = DateTime.local(year, month, date);

  if (!newDate.isValid) {
    throwError(
      `Could not build valid DateTime with input ${year}-${month}-${date}: ${newDate.invalidReason}, ${newDate.invalidExplanation}`,
    );
  }

  return newDate;
};

export const nextDay = (date: DateTime) => {
  return date.plus({ day: 1 });
};

export const prevDay = (date: DateTime) => {
  return date.minus({ day: 1 });
};
