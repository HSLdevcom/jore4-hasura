import * as dotenv from 'dotenv';
import { ConnectionConfig } from 'pg';

dotenv.config({ path: process.env.DOTENV_PATH || '../.env' });

export const networkDbConfig: ConnectionConfig = {
  host: 'localhost',
  port: 6432,
  database: process.env.POSTGRES_DB || 'jore4e2e',
  user: process.env.POSTGRES_USER || 'dbadmin',
  password: process.env.POSTGRES_PASSWORD || 'adminpassword',
};

export type HASURA_DATABASE_SCHEMA = 'generic' | 'hsl';
export const databaseSchema: HASURA_DATABASE_SCHEMA =
  (process.env.HASURA_DATABASE_SCHEMA as HASURA_DATABASE_SCHEMA) || 'generic';

export const hasuraApiUri = 'http://localhost:3201/v1/graphql';

export const hasuraRequestTemplate = {
  uri: hasuraApiUri,
  headers: {
    'x-hasura-admin-secret':
      process.env.HASURA_GRAPHQL_ADMIN_SECRET || 'hasura',
  },
  json: true,
};
