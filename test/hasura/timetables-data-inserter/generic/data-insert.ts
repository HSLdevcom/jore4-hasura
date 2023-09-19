import { timetablesDbConfig } from '@config';
import { closeDbConnection, createDbConnection } from '@util/db';
import { setupDb } from '@util/setup';
import { ConnectionConfig } from 'pg';
import { buildGenericTimetablesDataset } from './dataset';
import { parseGenericDatasetJson } from './json-parser';
import { createGenericTableData } from './table-data';
import { GenericTimetablesDatasetInput } from './types';

export const insertDatasetFromJson = async (
  input: string,
  dbConfig: ConnectionConfig = timetablesDbConfig,
) => {
  const result = parseGenericDatasetJson(input);
  const builtDataset = buildGenericTimetablesDataset(result);
  const dbConnection = createDbConnection(dbConfig);
  const tableData = createGenericTableData(builtDataset);
  await setupDb(dbConnection, tableData);
  closeDbConnection(dbConnection);
  return builtDataset;
};

export const insertGenericDataset = async (
  input: GenericTimetablesDatasetInput,
  dbConfig: ConnectionConfig = timetablesDbConfig,
) => {
  const builtDataset = buildGenericTimetablesDataset(input);
  const tableData = createGenericTableData(builtDataset);
  const dbConnection = createDbConnection(dbConfig);
  await setupDb(dbConnection, tableData);
  closeDbConnection(dbConnection);
  return builtDataset;
};
