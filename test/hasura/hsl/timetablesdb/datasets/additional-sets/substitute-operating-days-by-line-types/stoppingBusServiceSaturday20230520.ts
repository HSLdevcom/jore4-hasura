import { DateTime } from 'luxon';
import { TypeOfLine } from 'generic/networkdb/datasets/types';
import { HslTimetablesDbTables } from '../../schema';

export const stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType =
  {
    substitute_operating_day_by_line_type_id:
      '88fbc283-9552-45d2-9365-60272f1e44f6',
    type_of_line: TypeOfLine.StoppingBusService,
    superseded_date: DateTime.fromISO('2023-05-20'),
    substitute_operating_period_id: 'cfa58eec-2e5a-4ab7-a8e9-a92a46316640',
  };

export const stoppingBusServiceSaturday20230520SubstituteOperatingPeriod = {
  substitute_operating_period_id: 'cfa58eec-2e5a-4ab7-a8e9-a92a46316640',
  is_preset: false,
  period_name: 'Unusual Saturday for Stopping Bus Service',
};

export const stoppingBusServiceSaturday20230520Dataset: TableData<HslTimetablesDbTables>[] =
  [
    {
      name: 'service_calendar.substitute_operating_period',
      data: [stoppingBusServiceSaturday20230520SubstituteOperatingPeriod],
    },
    {
      name: 'service_calendar.substitute_operating_day_by_line_type',
      data: [
        stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType,
      ],
    },
  ];

export const stoppingBusServiceSubstitutesSaturday20230520Dataset = {
  _substitute_operating_periods: {
    saturday20230520: {
      period_name: 'Unusual Saturday for Stopping Bus Service',
      _substitute_operating_day_by_line_types: {
        saturday20230520: {
          type_of_line: TypeOfLine.StoppingBusService,
          superseded_date: DateTime.fromISO('2023-05-20'),
        },
      },
    },
  },
};
