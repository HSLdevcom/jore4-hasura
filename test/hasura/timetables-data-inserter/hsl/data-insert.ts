import { timetablesDbConfig } from '@config';
import { closeDbConnection, createDbConnection } from '@util/db';
import { setupDb } from '@util/setup';
import { ConnectionConfig } from 'pg';
import { buildHslTimetablesDataset } from './dataset';
import { parseHslDatasetJson } from './json-parser';
import { createHslTableData } from './table-data';
import { HslTimetablesDatasetInput } from './types';

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

export const insertHslDataset = async (
  input: HslTimetablesDatasetInput,
  dbConfig: ConnectionConfig = timetablesDbConfig,
) => {
  const builtDataset = buildHslTimetablesDataset(input);
  const tableData = createHslTableData(builtDataset);
  const dbConnection = createDbConnection(dbConfig);
  await setupDb(dbConnection, tableData);
  closeDbConnection(dbConnection);
  return builtDataset;
};
