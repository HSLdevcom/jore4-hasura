import { defaultTableConfig } from '@datasets-generic/defaultSetup';
import { isFileDataSource, isGeoProperty } from '@datasets-generic/types';
import { serializeInsertInput } from '@util/dataset';
import * as db from '@util/db';
import { throwError } from '@util/helpers';
import { readFileSync } from 'fs';
import * as pg from 'pg';

export function isTableConfig(obj: TableLikeConfig): obj is TableConfig {
  return Object.prototype.hasOwnProperty.call(obj, 'data');
}

export const setupDb = async (
  conn: db.DbConnection,
  configuration: TableLikeConfig[] = defaultTableConfig,
  disableTriggers = false,
) => {
  // disable triggers before transaction on demand
  if (disableTriggers) {
    await db.disableTriggers(conn, true);
  }

  // run inserts in transaction
  await db.getKnex().transaction(
    async (trx) => {
      const tables = configuration.filter(isTableConfig);

      // truncate all tables present in config
      for (let i = 0; i < tables.length; i++) {
        const table = tables[i];
        // eslint-disable-next-line no-await-in-loop
        await db.truncate(trx, table.name);
      }

      // insert data to tables present in config
      for (let i = 0; i < tables.length; i++) {
        const table = tables[i];
        const { data } = table;
        if (isFileDataSource(data)) {
          // data contains the file name from which to load SQL statements
          const fileContent = readFileSync(data, 'utf-8');
          // eslint-disable-next-line no-await-in-loop
          await db.singleQuery(trx, fileContent);
        } else {
          const serializedData = data.map(serializeInsertInput);
          // eslint-disable-next-line no-await-in-loop
          await db.batchInsert(trx, table.name, serializedData);
        }
      }
    },
    { connection: conn },
  );

  // reenable triggers after transaction
  if (disableTriggers) {
    await db.disableTriggers(conn, false);
  }
};

export const getTableConfig = (
  tableName: string,
  configuration: TableLikeConfig[] = defaultTableConfig,
) =>
  configuration.find((table) => table.name === tableName) ??
  throwError(`no configuration found for table ${tableName}`);

export const getTableConfigArray = (
  tableNames: string[],
  configuration: TableLikeConfig[] = defaultTableConfig,
) => tableNames.map((tableName) => getTableConfig(tableName, configuration));

export const getPropNameArray = (props: Property[]) =>
  props.map((prop) => (isGeoProperty(prop) ? prop.propName : prop));

export const queryTable = (
  dbConnectionPool: pg.Pool,
  tableName: string,
  configuration: TableLikeConfig[] = defaultTableConfig,
) =>
  db.singleQuery(
    dbConnectionPool,
    `
      SELECT ${getPropNameArray(
        getTableConfig(tableName, configuration).props,
      ).join(',')}
      FROM ${tableName}
    `,
  );
