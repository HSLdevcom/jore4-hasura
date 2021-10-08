import { Client, ClientConfig, Pool, QueryResult } from "pg";

export class SetupConfiguration {
  dbClient: Client;
  queries: { query: string; params?: any[] }[] = [];

  constructor(dbClient: Client) {
    this.dbClient = dbClient;
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

  // When setting up the database, constraint triggers need to be disabled, otherwise initialization could fail due to
  // e.g. failing foreign key constraints.
  // This function runs a query with the constraints deferred, and it runs the query in its own db session, so that
  // the session_replication_role setting does not affect subsequent queries run in a connection pool.
  run = () =>
    this.dbClient
      .connect()
      .then(() =>
        [
          { query: "SET session_replication_role = replica" },
          ...this.queries,
        ].reduce(
          (promise: Promise<void | QueryResult>, nextQuery) =>
            promise.then(() =>
              this.dbClient.query(nextQuery.query, nextQuery.params)
            ),
          Promise.resolve()
        )
      )
      .finally(() => this.dbClient.end());
}

export const setup = (config: ClientConfig) =>
  new SetupConfiguration(new Client(config));

export const query = (connectionPool: Pool, query: string) =>
  connectionPool
    .connect()
    .then((client) => client.query(query).finally(() => client.release()));
