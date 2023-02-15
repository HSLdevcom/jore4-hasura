import { expect } from '@jest/globals';
import { DateTime, Duration } from 'luxon';

function areDateAndDateTimeEqual(a: unknown, b: unknown) {
  const comparingDateAndDateTime =
    (a instanceof Date && b instanceof DateTime) ||
    (b instanceof Date && a instanceof DateTime);

  if (comparingDateAndDateTime) {
    return a.valueOf() === b.valueOf();
  }

  return undefined;
}

expect.addEqualityTesters([areDateAndDateTimeEqual]);

function areDurationAndStringEqual(a: unknown, b: unknown) {
  const comparingDateAndDateTime =
    (a instanceof Duration && typeof b === 'string') ||
    (b instanceof Duration && typeof a === 'string');

  if (comparingDateAndDateTime) {
    return a.toString() === b.toString();
  }

  return undefined;
}

expect.addEqualityTesters([areDurationAndStringEqual]);
