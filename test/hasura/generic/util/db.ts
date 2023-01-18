import knex, { Knex } from 'knex';
import { Pool } from 'pg';

export type DbConnection = Pool | Knex.Transaction;
export function isTransaction(conn: DbConnection): conn is Knex.Transaction {
  return Object.prototype.hasOwnProperty.call(conn, 'commit');
}

// initializes a knex query builder instance (without a connection)
// useage: getKnex().raw('SELECT * FROM...').connection(connectionPool)
export const getKnex = () => {
  return knex({ client: 'pg' });
};

export const executeKnexQuery = <T = ExplicitAny>(
  conn: DbConnection,
  knexQuery: Knex.ChainableInterface<T>,
) => {
  return isTransaction(conn)
    ? knexQuery.transacting(conn)
    : knexQuery.connection(conn);
};

export const singleQuery = (
  conn: DbConnection,
  query: string,
  parameters: Knex.RawBinding[] | Knex.ValueDict = [],
) => {
  const knexQuery = getKnex().raw(query, parameters || []);
  return executeKnexQuery(conn, knexQuery);
};

export const batchInsert = (
  conn: DbConnection,
  tableName: string,
  jsonObjects: PlainObject[],
) => {
  const knexQuery = getKnex().insert(jsonObjects).into(tableName);
  return executeKnexQuery(conn, knexQuery);
};

export const disableTriggers = (conn: DbConnection, disable: boolean) =>
  singleQuery(
    conn,
    // note: intentionally not using parameter binding here as these values should not be escaped
    `SET session_replication_role = ${disable ? 'replica' : 'DEFAULT'}`,
  );

export const truncate = (conn: DbConnection, table: string) =>
  singleQuery(conn, 'TRUNCATE :table: CASCADE', { table });
