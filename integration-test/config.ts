import * as dotenv from "dotenv";

dotenv.config({ path: process.env.DOTENV_PATH || "../.env" });

export const databaseConfig = {
  host: "localhost",
  port: 6432,
  database: process.env.POSTGRES_DB || "jore4e2e",
  user: process.env.POSTGRES_USER || "dbadmin",
  password: process.env.POSTGRES_PASSWORD || "adminpassword",
};

export const hasuraApiUri = "http://localhost:3201/v1/graphql";

export const hasuraRequestTemplate = {
  uri: hasuraApiUri,
  headers: {
    "x-hasura-admin-secret":
      process.env.HASURA_GRAPHQL_ADMIN_SECRET || "hasura",
  },
  json: true,
};
