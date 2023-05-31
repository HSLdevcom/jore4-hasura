import { TypeOfLine } from 'generic/networkdb/datasets/types';
import { DateTime } from 'luxon';
import { HslTimetablesDbTables } from '../../schema';

export const expressBusServiceSaturday20230520SubstituteOperatingDayByLineType =
  {
    substitute_operating_day_by_line_type_id:
      '0967a31a-8304-4440-9a8e-18bb67b281a8',
    type_of_line: TypeOfLine.ExpressBusService,
    superseded_date: DateTime.fromISO('2023-05-20'),
    substitute_operating_period_id: 'b3dc5a95-74a1-42ed-b428-b633d8cc1563',
  };

export const expressBusServiceSaturday20230520SubstituteOperatingPeriod = {
  substitute_operating_period_id: 'b3dc5a95-74a1-42ed-b428-b633d8cc1563',
  is_preset: false,
  period_name: 'Unusual Saturday for Express Bus Service',
};

export const expressBusServiceSaturday20230520Dataset: TableData<HslTimetablesDbTables>[] =
  [
    {
      name: 'service_calendar.substitute_operating_period',
      data: [expressBusServiceSaturday20230520SubstituteOperatingPeriod],
    },
    {
      name: 'service_calendar.substitute_operating_day_by_line_type',
      data: [expressBusServiceSaturday20230520SubstituteOperatingDayByLineType],
    },
  ];
