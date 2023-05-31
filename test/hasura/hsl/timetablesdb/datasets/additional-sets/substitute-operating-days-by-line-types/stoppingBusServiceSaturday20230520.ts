import { TypeOfLine } from 'generic/networkdb/datasets/types';
import { DateTime } from 'luxon';
import { HslTimetablesDbTables } from '../../schema';

export const stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType =
  {
    substitute_operating_day_by_line_type_id:
      '88fbc283-9552-45d2-9365-60272f1e44f6',
    type_of_line: TypeOfLine.StoppingBusService,
    superseded_date: DateTime.fromISO('2023-05-20'),
    substitute_operating_period_id: '88fbc283-9552-45d2-9365-60272f1e4423',
  };

export const stoppingBusServiceSaturday20230520SubstituteOperatingPeriod = {
  id: '88fbc283-9552-45d2-9365-60272f1e4423',
  is_preset: false,
  period_name: 'Lauantain korvausjakso',
};

export const stoppingBusServiceSaturday20230520Dataset: TableData<HslTimetablesDbTables>[] =
  [
    {
      name: 'service_calendar.substitute_operating_day_by_line_type',
      data: [
        stoppingBusServiceSaturday20230520SubstituteOperatingDayByLineType,
      ],
    },
    {
      name: 'service_calendar.substitute_operating_period',
      data: [stoppingBusServiceSaturday20230520SubstituteOperatingPeriod],
    },
  ];
