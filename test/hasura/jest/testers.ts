// eslint-disable-next-line n/no-unpublished-import
import { expect } from '@jest/globals';
import { isTemporalValue } from '@util/time';

function hasCalendarUnits(duration: Temporal.Duration) {
  return duration.years !== 0 || duration.months !== 0 || duration.weeks !== 0;
}

// Compare by value, so that e.g. PT1H and PT60M count as equal. Years, months
// and weeks have no fixed length, so comparing those needs a reference point;
// fall back to the serialized form rather than picking an arbitrary one.
function areDurationsEqual(a: Temporal.Duration, b: Temporal.Duration) {
  if (hasCalendarUnits(a) || hasCalendarUnits(b)) {
    return a.toString() === b.toString();
  }

  return Temporal.Duration.compare(a, b) === 0;
}

// Temporal values hold their state in internal slots and expose no own
// enumerable properties. Jest's structural equality would therefore consider
// any two instances of the same Temporal type equal, which silently turns
// assertions into no-ops. Every Temporal type has a lossless toString(), so
// comparing those is a safe basis for equality. This deliberately covers all
// Temporal types rather than only the ones currently in use, since an
// uncovered type fails open rather than closed.
function areTemporalValuesEqual(a: unknown, b: unknown) {
  if (!isTemporalValue(a) || !isTemporalValue(b)) {
    return undefined;
  }

  if (Object.getPrototypeOf(a) !== Object.getPrototypeOf(b)) {
    return false;
  }

  if (a instanceof Temporal.Duration && b instanceof Temporal.Duration) {
    return areDurationsEqual(a, b);
  }

  return a.toString() === b.toString();
}

// Allows asserting against durations with plain ISO 8601 strings.
function isDurationEqualToString(duration: Temporal.Duration, value: string) {
  try {
    return areDurationsEqual(duration, Temporal.Duration.from(value));
  } catch {
    // Not a duration at all, so it cannot be equal to one.
    return false;
  }
}

function areDurationAndStringEqual(a: unknown, b: unknown) {
  if (a instanceof Temporal.Duration && typeof b === 'string') {
    return isDurationEqualToString(a, b);
  }
  if (b instanceof Temporal.Duration && typeof a === 'string') {
    return isDurationEqualToString(b, a);
  }

  return undefined;
}

expect.addEqualityTesters([areTemporalValuesEqual, areDurationAndStringEqual]);
