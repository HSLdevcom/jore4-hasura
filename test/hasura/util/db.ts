import { LocalDate } from 'local-date';
import { Pool, QueryResult } from 'pg';

class QueryRunner {
  connectionPool: Pool;

  queries: { query: string; params?: ExplicitAny[] }[] = [];

  constructor(connectionPool: Pool) {
    this.connectionPool = connectionPool;
  }

  query(query: string, params?: ExplicitAny[]) {
    this.queries.push({ query, params });
    return this;
  }

  truncate = (table: string) => this.query(`TRUNCATE ${table} CASCADE`);

  insertFromJson = (table: string, jsonObjects: Record<string, unknown>[]) => {
    const getInsertColumns = (data: Record<string, unknown>) => {
      return Object.keys(data).join(', ');
    };

    const getInsertParameterSymbols = (data: Record<string, unknown>) => {
      return Object.keys(data)
        .map((value, idx) => {
          return `$${idx + 1}`;
        })
        .join(', ');
    };

    const getFieldValueForDbInsert = (value: unknown) => {
      if (value instanceof LocalDate) {
        return value.toISOString();
      }
      return value;
    };

    const getInsertValues = (data: Record<string, unknown>) => {
      return Object.values(data).map(getFieldValueForDbInsert);
    };

    jsonObjects.forEach((jsonObject) => {
      const columns = getInsertColumns(jsonObject);
      const parameterSymbols = getInsertParameterSymbols(jsonObject);
      const values = getInsertValues(jsonObject);

      this.query(
        `INSERT INTO ${table} (${columns}) VALUES (${parameterSymbols})`,
        [...values],
      );
    });

    return this;
  };

  disableTriggers = (disable: boolean) =>
    this.query(
      `SET session_replication_role = ${disable ? 'replica' : 'DEFAULT'}`,
    );

  run = (rollbackOnError?: boolean) =>
    this.connectionPool.connect().then((client) =>
      this.queries
        .reduce((promise: Promise<void | QueryResult>, nextQuery) => {
          return promise.then(() =>
            client.query(nextQuery.query, nextQuery.params),
          );
        }, Promise.resolve())
        .catch((err) => {
          if (rollbackOnError) {
            return client.query('ROLLBACK').finally(() => {
              throw err;
            });
          }
          throw err;
        })
        .finally(() => client.release()),
    );
}

export const queryRunner = (connectionPool: Pool) =>
  new QueryRunner(connectionPool);

export const singleQuery = (connectionPool: Pool, query: string) =>
  connectionPool
    .connect()
    .then((client) => client.query(query).finally(() => client.release()));
