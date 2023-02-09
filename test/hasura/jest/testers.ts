import { expect } from '@jest/globals';
import { DateTime } from 'luxon';

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
