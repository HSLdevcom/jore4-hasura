import { timetablesDbConfig } from '@config';
import { closeDbConnection, createDbConnection } from '@util/db';
import { setupDb } from '@util/setup';
import { ConnectionConfig } from 'pg';
import { buildGenericTimetablesDataset } from './dataset';
import { genericTimetablesJsonSchema } from './json-schemas';
import { createGenericTableData } from './table-data';
import { GenericTimetablesDatasetInput } from './types';

export const parseGenericDatasetJson = (
  input: string,
): GenericTimetablesDatasetInput => {
  const parsedJson = JSON.parse(input);
  const parsedDatasetInput = genericTimetablesJsonSchema.parse(parsedJson);
  return parsedDatasetInput;
};

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
