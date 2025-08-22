import { DateTime } from 'luxon';
import { TypeOfLine } from 'generic/networkdb/datasets/types';
import { HslTimetablesDbTables } from '../../schema';
import { DayOfWeek } from '../../types';

export const stoppingBusServiceThursday20230406SubstituteOperatingDayByLineType =
  {
    substitute_operating_day_by_line_type_id:
      '5d7a31de-1236-4c94-b737-509bae0ea578',
    type_of_line: TypeOfLine.StoppingBusService,
    superseded_date: DateTime.fromISO('2023-04-06'),
    substitute_day_of_week: DayOfWeek.Sunday,
    substitute_operating_period_id: 'c23c96ba-2ef5-4e0c-a3fd-9e514432d638',
  };

export const stoppingBusServiceThursday20230406SubstituteOperatingPeriod = {
  substitute_operating_period_id: 'c23c96ba-2ef5-4e0c-a3fd-9e514432d638',
  is_preset: false,
  period_name: "Joe Biden's Visit",
};

export const stoppingBusServiceSaturday20230406Dataset: TableData<HslTimetablesDbTables>[] =
  [
    {
      name: 'service_calendar.substitute_operating_period',
      data: [stoppingBusServiceThursday20230406SubstituteOperatingPeriod],
    },
    {
      name: 'service_calendar.substitute_operating_day_by_line_type',
      data: [
        stoppingBusServiceThursday20230406SubstituteOperatingDayByLineType,
      ],
    },
  ];

export const stoppingBusServiceSubstitutesSaturday20230406Dataset = {
  _substitute_operating_periods: {
    saturday20230406: {
      period_name: "Joe Biden's Visit",
      _substitute_operating_day_by_line_types: {
        saturday20230406: {
          type_of_line: TypeOfLine.StoppingBusService,
          superseded_date: DateTime.fromISO('2023-04-06'),
          substitute_day_of_week: DayOfWeek.Sunday,
        },
      },
    },
  },
};
