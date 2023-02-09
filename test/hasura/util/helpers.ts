import { DateTime } from 'luxon';

export function throwError(msg: string): never {
  throw new Error(msg);
}

export const newDateTime = (year: number, month: number, date: number) => {
  const newDate = DateTime.fromISO();
  newDate.setFullYear(year);
  newDate.setMonth(month);
  newDate.setDate(date);
  return newDate;
};

export const nextDay = (date: DateTime) => {
  const next = DateTime.fromISO(date);
  next.setDate(next.getDate() + 1);
  return next;
};

export const prevDay = (date: DateTime) => {
  const next = DateTime.fromISO(date);
  next.setDate(next.getDate() - 1);
  return next;
};
