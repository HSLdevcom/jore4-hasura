# jore4-hasura

Minimal hasura & docker setup for jore4 development.

## Quickstart

```sh
./generate-secrets-for-local-development.sh # Press y<enter>
docker-compose up --build
```

## Development

To play with the GraphQL API or to modify the backend, it is easiest to use the Hasura admin UI ("console").

1. Make sure you have generated the required secrets with `./generate-secrets-for-local-development.sh`.
1. Install [Hasura CLI](https://hasura.io/docs/1.0/graphql/core/hasura-cli/install-hasura-cli.html).
1. Start PostGIS and the Hasura server with `docker-compose up --build`.
   Hasura will apply the existing SQL migrations and server metadata.
   Wait until the service `hasura` is healthy.
1. `cd hasura` to allow hasura-cli to find `config.yaml`.
1. Run `hasura console` to start the console.
1. Open <http://localhost:8080> in the browser to access the console.
   The initial view opens up with a beefed-up GraphiQL for testing queries.

Other possibly relevant commands for Hasura CLI:

1. `cd hasura` to allow hasura-cli to find `config.yaml`.
1. Run `hasura migrate ...` to read or write DB migration files.
1. Run `hasura metadata ...` to read or write Hasura configuration.

### Change the SQL schema

While both PostGIS and the Hasura server are running, create a new migration with

```sh
cd hasura # To allow hasura-cli to find config.yaml
hasura migrate create ${SENSIBLE_SNAKE_CASE_MIGRATION_NAME}
```

Write your SQL schema changes in the files `up.sql` and `down.sql` in the created directory `hasura/migrations/${TIMESTAMP}_${SENSIBLE_SNAKE_CASE_MIGRATION_NAME}/`.

Assuming your database has the previously created migrations applied and you have created only one new SQL migration, apply both your up and down migration files to your development database with

```sh
cd hasura # To allow hasura-cli to find config.yaml
hasura migrate status
hasura migrate apply --up 1
hasura migrate apply --down 1
```

`hasura migrate --help` and `hasura migrate apply --help` reveal more options.

For example, to run all available up migrations, use

```sh
hasura migrate apply
```

To run all migrations up to a certain migration, use

```sh
hasura migrate apply --goto "${TIMESTAMP}"
```

Once you are convinced your SQL schema migration is correct, commit the new SQL files into git.

### Change the Hasura API

To change what to expose, to whom and how in the API served by Hasura, you need to modify the metadata of Hasura.
These yaml files in `hasura/metadata/` _could_ be changed by writing text.
On the other hand, the admin UI exposes all the choices.

Start the admin UI:

```sh
cd hasura # To allow hasura-cli to find config.yaml
hasura console
```

In the admin UI:

1. Navigate to the Data tab.
1. Select the relevant schema.
1. To expose something new in the GraphQL API, track new tables, foreign-key relationships or functions from the middle panel.
1. Modify permissions of tracked tables by selecting a table from the left panel and by choosing the Permissions tab from the middle panel.
1. Write the names of any roles that are missing but should be authorized.
1. To change any operation authorization, click on the corresponding cell in the table that you wish to change.

When you make changes in the admin UI, `hasura console` will modify `hasura/metadata/*.yaml` files accordingly in the background.

When you are done clicking, commit the metadata changes into git.

#### Advice for permissions

The role name for public, unauthenticated use is given to the Hasura server with the environment variable `HASURA_GRAPHQL_UNAUTHORIZED_ROLE`.
That name is set to `anonymous` within the Docker image.
Keep using the same name unless you have a reason for renaming.
The name is not visible in the GraphQL API.

If the SQL schema generates a default value that should always be used for a column, e.g. for an ID or for a creation timestamp, do not allow inserts or updates for that column over the GraphQL API.

Do not allow inserting, updating or deleting data in reference tables, i.e. "enum-like" tables, over the GraphQL API.
Insert the values in a migration, instead.
Proper [enums](https://www.postgresql.org/docs/12/datatype-enum.html) are hard to change even in the migration files so avoid using them.

#### Incompatible SQL schema and metadata

If you make backwards-incompatible changes to the SQL schema, the old Hasura metadata might become incompatible with the new SQL schema.

One way to resolve the Hasura metadata conflicts:

1. Reload the metadata: Navigate to Settings (the cog in the top bar), to Metadata Actions (left panel) and to Reload metadata (middle panel).
   Click Reload.
1. Remove the conflicting parts of the metadata: Navigate to Metadata Status (left panel).
   Read which parts of the metadata conflict with the SQL schema.
   Once you know what should be changed, click Delete all and OK.
1. Recreate the missing parts of the metadata as explained above.

## Deployment

Secrets should be passed as files to Docker images in production environments.
[As long as Hasura cannot read secrets from files](https://github.com/hasura/graphql-engine/issues/3989), we need to provide our own entrypoint for the Docker image.
Our entrypoint reads the secrets and delivers them to Hasura.

**All secret files should be stored under the `./secrets` directory.**
Our Docker image expects the following files under `./secrets` to contain the secrets:
| Secret file |
| -------------------------------- |
| hasura-admin-secret |
| db-username |
| db-password |
| db-hostname |
| db-name |

### Use of the Docker image

The Docker image expects the following values for the following environment variables or for the corresponding CLI options.
The expected values are **set by default**.

| Environment variable             | Default value      |
| -------------------------------- | ------------------ |
| HASURA_GRAPHQL_UNAUTHORIZED_ROLE | anonymous          |
| HASURA_GRAPHQL_MIGRATIONS_DIR    | /hasura-migrations |
| HASURA_GRAPHQL_METADATA_DIR      | /hasura-metadata   |

**Please don't change them. Either don't define them at all or set them to the same values as documented above.**

We are using [hasura/graphql-engine](https://registry.hub.docker.com/r/hasura/graphql-engine) as a base image.
Please see the link for detailed documentation.
