import { serializeInsertInput } from '@util/dataset';
import * as db from '@util/db';
import { promiseSequence } from '@util/promise';
import { readFileSync } from 'fs';
import {
  isFileDataSource,
  isGeoProperty,
} from 'generic/networkdb/datasets/types';

export const setupDb = async <TTableName extends string>(
  conn: db.DbConnection,
  tableData: TableData<TTableName>[],
  disableTriggers = false,
) => {
  // disable triggers before transaction on demand
  if (disableTriggers) {
    await db.disableTriggers(conn, true);
  }

  // run inserts in transaction
  await db.getKnex().transaction(
    async (trx) => {
      // truncate all tables present in config
      await promiseSequence(
        tableData.map((table) => db.truncate(trx, table.name)),
      );

      // insert data to tables present in config
      await promiseSequence(
        tableData.map((table) => {
          const { data } = table;

          if (isFileDataSource(data)) {
            // data contains the file name from which to load SQL statements
            const fileContent = readFileSync(data, 'utf-8');
            return db.singleQuery(trx, fileContent);
          }

          const serializedData = data.map(serializeInsertInput);
          return db.batchInsert(trx, table.name, serializedData);
        }),
      );
    },
    { connection: conn },
  );

  // reenable triggers after transaction
  if (disableTriggers) {
    await db.disableTriggers(conn, false);
  }
};

export const getPartialTableData = <TTableName extends string>(
  tableData: TableData<TTableName>[],
  tableNames: TTableName[],
) => tableData.filter((item) => tableNames.includes(item.name));

export const getPropNameArray = (props: Property[]) =>
  props.map((prop) => (isGeoProperty(prop) ? prop.propName : prop));

export const queryTable = <TTableName extends string>(
  dbConnection: db.DbConnection,
  tableSchema: TableSchema<TTableName>,
) =>
  db.singleQuery(
    dbConnection,
    `
      SELECT ${getPropNameArray(tableSchema.props).join(',')}
      FROM ${tableSchema.name}
    `,
  );
