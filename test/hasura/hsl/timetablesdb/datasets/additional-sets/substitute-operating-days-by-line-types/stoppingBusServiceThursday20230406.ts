import { TypeOfLine } from 'generic/networkdb/datasets/types';
import { DateTime } from 'luxon';
import { HslTimetablesDbTables } from '../../schema';
import { DayOfWeek } from '../../types';

export const stoppingBusServiceThursday20230406SubstituteOperatingDayByLineType =
  {
    substitute_operating_day_by_line_type_id:
      '5d7a31de-1236-4c94-b737-509bae0ea578',
    type_of_line: TypeOfLine.StoppingBusService,
    superseded_date: DateTime.fromISO('2023-04-06'),
    substitute_day_of_week: DayOfWeek.Sunday,
  };

export const stoppingBusServiceSaturday20230406Dataset: TableData<HslTimetablesDbTables>[] =
  [
    {
      name: 'service_calendar.substitute_operating_day_by_line_type',
      data: [
        stoppingBusServiceThursday20230406SubstituteOperatingDayByLineType,
      ],
    },
  ];
