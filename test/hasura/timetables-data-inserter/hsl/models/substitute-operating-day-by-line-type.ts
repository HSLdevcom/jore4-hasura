import { TypeOfLine } from 'generic/networkdb/datasets/types';
import {
  SubstituteOperatingDayByLineType,
  SubstituteOperatingPeriod,
} from 'hsl/timetablesdb/datasets/types';
import { DateTime } from 'luxon';
import { assignId } from 'timetables-data-inserter/utils';
import {
  SubstituteOperatingDayByLineTypeInput,
  SubstituteOperatingDayByLineTypeOutput,
} from '../types';

export const processSubstituteOperatingDayByLineType = (
  substituteOperatingDayByLineType: SubstituteOperatingDayByLineTypeInput,
  parentPeriod: Pick<
    SubstituteOperatingPeriod,
    'substitute_operating_period_id'
  >,
): SubstituteOperatingDayByLineTypeOutput => {
  const idField = 'substitute_operating_day_by_line_type_id';
  const result = assignId(substituteOperatingDayByLineType, idField);

  return {
    type_of_line: TypeOfLine.StoppingBusService,
    superseded_date: DateTime.fromISO('2023-01-01'),
    substitute_day_of_week: null,
    begin_time: null,
    end_time: null,
    timezone: 'Europe/Helsinki',
    ...result,
    substitute_operating_period_id: parentPeriod.substitute_operating_period_id,
  };
};

export const substituteOperatingDayByLineTypeToDbFormat = (
  row: SubstituteOperatingDayByLineTypeOutput,
): SubstituteOperatingDayByLineType => {
  return row;
};
