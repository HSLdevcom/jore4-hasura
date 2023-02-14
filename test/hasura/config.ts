import * as dotenv from 'dotenv';
import { Settings } from 'luxon';
import { ConnectionConfig } from 'pg';

dotenv.config({ path: process.env.DOTENV_PATH || '../.env' });

// Configure Luxon.
Settings.throwOnInvalid = true; // Invalid dates are too easy to miss otherwise.

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

export type HASURA_DATABASE_SCHEMA = 'generic' | 'hsl';
export const databaseSchema: HASURA_DATABASE_SCHEMA =
  (process.env.HASURA_DATABASE_SCHEMA as HASURA_DATABASE_SCHEMA) || 'generic';

export const hasuraApiUri = 'http://127.0.0.1:3201/v1/graphql';

export const hasuraRequestTemplate = {
  uri: hasuraApiUri,
  headers: {
    'x-hasura-admin-secret':
      process.env.HASURA_GRAPHQL_ADMIN_SECRET || 'hasura',
  },
  json: true,
};
