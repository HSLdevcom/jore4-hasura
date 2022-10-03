import { LocalDate } from 'local-date';

export function throwError(msg: string): never {
  throw new Error(msg);
}

export const newLocalDate = (year: number, month: number, date: number) => {
  const newDate = new LocalDate();
  newDate.setFullYear(year);
  newDate.setMonth(month);
  newDate.setDate(date);
  return newDate;
};

export const nextDay = (date: LocalDate) => {
  const next = new LocalDate(date);
  next.setDate(next.getDate() + 1);
  return next;
};

export const prevDay = (date: LocalDate) => {
  const next = new LocalDate(date);
  next.setDate(next.getDate() - 1);
  return next;
};
