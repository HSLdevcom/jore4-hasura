import { SubstituteOperatingPeriod } from 'hsl/timetablesdb/datasets/types';
import { omit } from 'lodash';
import { assignId } from 'timetables-data-inserter/utils';
import {
  SubstituteOperatingPeriodInput,
  SubstituteOperatingPeriodOutput,
} from '../types';
import { processSubstituteOperatingDayByLineType } from './substitute-operating-day-by-line-type';

export const processSubstituteOperatingPeriod = (
  substituteOperatingPeriod: SubstituteOperatingPeriodInput,
): SubstituteOperatingPeriodOutput => {
  const result = assignId(
    substituteOperatingPeriod,
    'substitute_operating_period_id',
  );

  const substituteOperatingDayByLineTypes =
    substituteOperatingPeriod._substitute_operating_day_by_line_types || {};
  const processedSubstituteOperatingDayByLineTypes = Object.fromEntries(
    Object.values(substituteOperatingDayByLineTypes).map((child, i) => [
      Object.keys(substituteOperatingDayByLineTypes)[i],
      processSubstituteOperatingDayByLineType(child, result),
    ]),
  );

  return {
    period_name: 'default period',
    is_preset: false,
    ...result,
    _substitute_operating_day_by_line_types:
      processedSubstituteOperatingDayByLineTypes,
  };
};

export const substituteOperatingPeriodToDbFormat = (
  row: SubstituteOperatingPeriodOutput,
): SubstituteOperatingPeriod => {
  return omit(row, '_substitute_operating_day_by_line_types');
};
