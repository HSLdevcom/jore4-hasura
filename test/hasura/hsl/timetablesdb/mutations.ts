import { toGraphQlObject } from '@util/dataset';
import {
  SubstituteOperatingDayByLineType,
  SubstituteOperatingPeriod,
} from './datasets/types';

export const wrapWithTimetablesMutation = (mutation: string) => `
  mutation {
    timetables {
      ${mutation}
    }
  }
  `;
export type InsertSubstituteOperatingPeriod = {
  substitute_operating_period_id: UUID;
  period_name: string;
  is_preset: boolean;
  substitute_operating_day_by_line_types: {
    data: Partial<SubstituteOperatingDayByLineType>[];
  };
};

export const buildPartialUpsertSubstituteOperatingPeriod = (
  periodsToInsert: Partial<SubstituteOperatingPeriod>[],
) => `
  timetables_insert_service_calendar_substitute_operating_period(
    objects: ${periodsToInsert.map((p) => toGraphQlObject(p))}
      on_conflict: {
        constraint: substitute_operating_period_pkey
        update_columns: [period_name]
      }
  ) {
    affected_rows
  }
`;

export const buildPartialDeleteSubstituteOperatingDayByLineType = (
  periodsToDelete: UUID[],
) => `
  timetables_delete_service_calendar_substitute_operating_day_by_line_type(
    where: { 
      substitute_operating_period_id: {
         _in: ${JSON.stringify(periodsToDelete)} 
      }
    }
  ) {
    affected_rows
  }
`;

export const buildPartialInsertSubstituteOperatingDayByLineType = (
  daysToInsert: Partial<SubstituteOperatingDayByLineType>[],
) => `
  timetables_insert_service_calendar_substitute_operating_day_by_line_type(
    objects: [
      ${daysToInsert.map((d) => toGraphQlObject(d, ['type_of_line']))}
    ]
  ) {
    affected_rows
  }
`;

export const buildPartialDeleteSubstituteOperatingPeriodMutation = (
  ids: UUID[],
) => `
  timetables_delete_service_calendar_substitute_operating_period(
    where: {
      substitute_operating_period_id: {
        _in: ${JSON.stringify(ids)}
      } 
    }
  ) {
    affected_rows
  }
`;

export const buildPartialInsertSubstituteOperatingPeriodMutation = (
  periods: Partial<InsertSubstituteOperatingPeriod>[],
) => `
  timetables_insert_service_calendar_substitute_operating_period(
    objects: [
      ${periods.map((period) => toGraphQlObject(period, ['type_of_line']))}
    ]
  ) {
    affected_rows
  }
`;
