import { timetablesDbConfig } from '@config';
import { closeDbConnection, createDbConnection } from '@util/db';
import { setupDb } from '@util/setup';
import { ConnectionConfig } from 'pg';
import { buildHslTimetablesDataset } from './dataset';
import * as test from './example.json';
import { hslTimetablesJsonSchema } from './json-schemas';
import { createHslTableData } from './table-data';
import { HslTimetablesDatasetInput } from './types';

export const parseHslDatasetJson = (
  input: string,
): HslTimetablesDatasetInput => {
  const parsedJson = JSON.parse(input);
  const parsedDatasetInput = hslTimetablesJsonSchema.parse(parsedJson);
  return parsedDatasetInput;
};

export const insertDatasetFromJson = async (
  input: string,
  dbConfig: ConnectionConfig = timetablesDbConfig,
) => {
  const result = parseHslDatasetJson(input);
  const builtDataset = buildHslTimetablesDataset(result);
  const dbConnection = createDbConnection(dbConfig);
  const tableData = createHslTableData(builtDataset);
  await setupDb(dbConnection, tableData);
  closeDbConnection(dbConnection);
  return builtDataset;
};

// TODO: replicate this in a test.
export const testParsing = async () => {
  await insertDatasetFromJson(JSON.stringify(test));
};
