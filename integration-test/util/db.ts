import { Client, ClientConfig, Pool } from "pg";

// When setting up the database, constraint triggers need to be disabled, otherwise initialization could fail due to
// e.g. failing foreign key constraints.
// This function runs a query with the constraints deferred, and it runs the query in its own db session, so that
// the session_replication_role setting does not affect subsequent queries run in a connection pool.
export function setup(config: ClientConfig, query: string) {
  const client = new Client(config);
  return client
    .connect()
    .then(() => client.query("SET session_replication_role = replica;" + query))
    .finally(() => client.end());
}

export const query = (connectionPool: Pool, query: string) =>
  connectionPool
    .connect()
    .then((client) => client.query(query).finally(() => client.release()));
