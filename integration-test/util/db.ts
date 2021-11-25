import pg, { Pool, QueryResult } from "pg";

class QueryRunner {
  connectionPool: Pool;
  queries: { query: string; params?: any[] }[] = [];

  constructor(connectionPool: Pool) {
    this.connectionPool = connectionPool;
  }

  query(query: string, params?: any[]) {
    this.queries.push({ query, params });
    return this;
  }

  truncate = (table: string) => this.query(`TRUNCATE ${table} CASCADE`);

  insertFromJson = (table: string, jsonObjects: Record<string, unknown>[]) =>
    this.query(
      `INSERT INTO ${table} ` +
        `SELECT *
       FROM jsonb_populate_recordset(NULL::${table}, $1::jsonb)`,
      [JSON.stringify(jsonObjects)]
    );

  run = () =>
    this.connectionPool
      .connect()
      .then((client) =>
        this.queries
          .reduce(
            (promise: Promise<void | QueryResult>, nextQuery) =>
              promise.then(() =>
                client.query(nextQuery.query, nextQuery.params)
              ),
            Promise.resolve()
          )
          .finally(() => client.release())
      );
}

export const queryRunner = (connectionPool: Pool) =>
  new QueryRunner(connectionPool);

export const singleQuery = (connectionPool: Pool, query: string) =>
  connectionPool
    .connect()
    .then((client) => client.query(query).finally(() => client.release()));
