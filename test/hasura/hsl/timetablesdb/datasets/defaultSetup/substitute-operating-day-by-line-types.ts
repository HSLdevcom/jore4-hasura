import { TypeOfLine } from 'generic/timetablesdb/datasets/types';
import { DateTime } from 'luxon';
import { DayOfWeek, SubstituteOperatingDayByLineType } from '../types';

export const substituteOperatingDayByLineTypes: SubstituteOperatingDayByLineType[] =
  [
    {
      substitute_operating_day_by_line_type_id:
        'd6965c0f-bc04-49fd-b21b-eed3a27de471',
      type_of_line: TypeOfLine.StoppingBusService,
      superseded_date: DateTime.fromISO('2023-01-01'),
      substitute_day_of_week: DayOfWeek.Friday,
    },
  ];
