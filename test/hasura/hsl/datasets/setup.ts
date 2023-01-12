import * as genericSetup from '@datasets-generic/setup';
import { defaultTableConfig } from '@datasets-hsl/defaultSetup';
import * as pg from 'pg';

export const setupDb = (
  dbConnectionPool: pg.Pool,
  configuration: TableLikeConfig[] = defaultTableConfig,
  disableTriggers = false,
) => {
  return genericSetup.setupDb(dbConnectionPool, configuration, disableTriggers);
};

export const queryTable = (
  dbConnectionPool: pg.Pool,
  tableName: string,
  configuration: TableLikeConfig[] = defaultTableConfig,
) => {
  return genericSetup.queryTable(dbConnectionPool, tableName, configuration);
};

export const { getPropNameArray } = genericSetup;
