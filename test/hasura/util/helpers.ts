import { DateTime } from 'luxon';

export function throwError(msg: string): never {
  throw new Error(msg);
}

export const newDateTime = (year: number, month: number, date: number) => {
  return DateTime.local(year, month, date);
};

export const nextDay = (date: DateTime) => {
  return date.plus({ day: 1 });
};

export const prevDay = (date: DateTime) => {
  return date.minus({ day: 1 });
};
