import * as dotenv from "dotenv";

dotenv.config({ path: process.env.DOTENV_PATH || "../.env" });

export const databaseConfig = {
  host: "localhost",
  port: 5432,
  database: "postgres",
  user: "postgres",
  password: process.env.POSTGRES_PASSWORD,
};

export const hasuraApiUri = "http://localhost:8080/v1/graphql";

export const hasuraRequestTemplate = {
  uri: hasuraApiUri,
  headers: { "x-hasura-admin-secret": process.env.HASURA_GRAPHQL_ADMIN_SECRET },
  json: true,
};
