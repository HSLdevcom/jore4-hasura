import * as dotenv from 'dotenv';
import { Knex } from 'knex';
import { ConnectionConfig, types } from 'pg';
import { parseDate, parseDateTime, parseTimestamp } from '@util/time';

dotenv.config({ path: process.env.DOTENV_PATH ?? '../.env' });

types.setTypeParser(types.builtins.DATE, parseDate);
types.setTypeParser(types.builtins.TIMESTAMP, parseTimestamp);
types.setTypeParser(types.builtins.TIMESTAMPTZ, parseDateTime);
// Relies on the server running with IntervalStyle=iso_8601: Temporal only
// accepts ISO 8601 durations, and would throw on Postgres' default output.
types.setTypeParser(types.builtins.INTERVAL, Temporal.Duration.from);

export const networkDbConfig: ConnectionConfig = {
  host: '127.0.0.1',
  port: 6432,
  database: 'jore4e2e',
  user: 'dbadmin',
  password: 'adminpassword',
};

export const timetablesDbConfig: ConnectionConfig = {
  ...networkDbConfig,
  database: 'timetablesdb',
};

export const knexConfig: Knex.Config = {
  client: 'pg',
  debug: false /* toggle to console log all queries = lots of spam */,
};

export type HASURA_DATABASE_SCHEMA = 'generic' | 'hsl';
export const databaseSchema: HASURA_DATABASE_SCHEMA =
  (process.env.HASURA_DATABASE_SCHEMA as HASURA_DATABASE_SCHEMA | undefined) ??
  'generic';

export const hasuraApiUri = 'http://127.0.0.1:3201/v1/graphql';

export const hasuraRequestTemplate = {
  uri: hasuraApiUri,
  headers: {
    'x-hasura-admin-secret':
      process.env.HASURA_GRAPHQL_ADMIN_SECRET ?? 'hasura',
  },
};

export const writeLatestTimetablesDatasetToFile = false;
