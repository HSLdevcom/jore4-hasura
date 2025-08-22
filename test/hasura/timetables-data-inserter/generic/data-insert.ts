import { ConnectionConfig } from 'pg';
import { timetablesDbConfig } from '@config';
import { closeDbConnection, createDbConnection } from '@util/db';
import { setupDb } from '@util/setup';
import { buildGenericTimetablesDataset } from './dataset';
import { parseGenericDatasetJson } from './json-parser';
import { createGenericTableData } from './table-data';
import { GenericTimetablesDatasetInput } from './types';

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

export const insertDatasetFromJson = async (
  input: string,
  dbConfig: ConnectionConfig = timetablesDbConfig,
) => {
  const datasetInput = parseGenericDatasetJson(input);
  return insertGenericDataset(datasetInput, dbConfig);
};
