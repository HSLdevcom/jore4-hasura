import {
  SubstituteOperatingPeriodInput,
  SubstituteOperatingPeriodOutput,
} from '../types';
import { processSubstituteOperatingDayByLineType } from './substitute-operating-day-by-line-type';

export const processSubstituteOperatingPeriod = (
  substituteOperatingPeriod: SubstituteOperatingPeriodInput,
): SubstituteOperatingPeriodOutput => {
  // TODO: const result = assignId(substituteOperatingPeriod, ...);
  const substituteOperatingDayByLineTypes =
    substituteOperatingPeriod._substitute_operating_day_by_line_types || {};
  const processedSubstituteOperatingDayByLineTypes = Object.fromEntries(
    Object.values(substituteOperatingDayByLineTypes).map((child, i) => [
      Object.keys(substituteOperatingDayByLineTypes)[i],
      processSubstituteOperatingDayByLineType(child /* TODO: result */),
    ]),
  );
  return {
    _substitute_operating_day_by_line_types:
      processedSubstituteOperatingDayByLineTypes,
  };
};

// TODO!
// export const substituteOperatingPeriodToDbFormat;
