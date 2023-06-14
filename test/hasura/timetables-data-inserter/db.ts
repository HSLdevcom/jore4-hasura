import { serializeInsertInput } from '@util/dataset';
import { buildInsertQuery } from '@util/db';
import { isFileDataSource } from 'generic/networkdb/datasets/types';
import { GenericTimetablesDbTables } from 'generic/timetablesdb/datasets/schema';
import { HslTimetablesDbTables } from 'hsl/timetablesdb/datasets/schema';

// TODO: quite some overlap here with insertTableData in test/hasura/util/setup.ts, maybe some opportunities for refactoring.
export const tableDataToSql = (
  tableData:
    | TableData<HslTimetablesDbTables>[]
    | TableData<GenericTimetablesDbTables>[],
): string => {
  const insertsForTables = tableData.map((td) => {
    const { data } = td;
    if (isFileDataSource(data)) {
      throw new Error('Data file sources not supported');
    }

    const serializedData = data.map(serializeInsertInput);
    const insertSql = buildInsertQuery(td.name, serializedData).toString();
    return `${insertSql};`; // Semicolon not included by default, terminate the statement.
  });

  return insertsForTables.join('\n\n'); // For clarity.
};
