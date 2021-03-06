# jore4-hasura

Minimal hasura & docker setup for jore4 development.

## Development

To play with the GraphQL API or to modify the backend, it is easiest to use the Hasura admin UI ("console").

1. Install [Hasura CLI](https://hasura.io/docs/1.0/graphql/core/hasura-cli/install-hasura-cli.html).
1. Start up all dependencies and build Hasura docker image locally, run `./scripts/start_dependencies.sh`.
   Hasura will apply the existing SQL migrations and server metadata.
   Wait until the service `hasura` is healthy.
1. Run `hasura console` to start the console.
1. Open <http://localhost:3201/console> in the browser to access the console. The admin secret is found from
   `/docker/secret-hasura-hasura-admin-secret` secret file.
   The initial view opens up with a beefed-up GraphiQL for testing queries.

Other possibly relevant commands for Hasura CLI:

1. Run `hasura migrate ...` to read or write DB migration files.
1. Run `hasura metadata ...` to read or write Hasura configuration.

### Change the SQL schema

While both PostGIS and the Hasura server are running, create a new migration with

```sh
hasura migrate create ${SENSIBLE_SNAKE_CASE_MIGRATION_NAME}
```

Write your SQL schema changes in the files `up.sql` and `down.sql` in the created directory `migrations/default/${TIMESTAMP}_${SENSIBLE_SNAKE_CASE_MIGRATION_NAME}/`.

Assuming your database has the previously created migrations applied and you have created only one new SQL migration, apply both your up and down migration files to your development database with

```sh
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

#### Optimizations

PostgreSQL by default does not create indexes for foreign key columns. In some cases, it's useful
to create the index. E.g. when joining larger tables.

Source: https://www.cybertec-postgresql.com/en/index-your-foreign-key/

Query to find "missing" foreign key indexes:

```sql
SELECT c.conrelid::regclass AS "table",
       /* list of key column names in order */
       string_agg(a.attname, ',' ORDER BY x.n) AS columns,
       pg_catalog.pg_size_pretty(
          pg_catalog.pg_relation_size(c.conrelid)
       ) AS size,
       c.conname AS constraint,
       c.confrelid::regclass AS referenced_table
FROM pg_catalog.pg_constraint c
   /* enumerated key column numbers per foreign key */
   CROSS JOIN LATERAL
      unnest(c.conkey) WITH ORDINALITY AS x(attnum, n)
   /* name for each key column */
   JOIN pg_catalog.pg_attribute a
      ON a.attnum = x.attnum
         AND a.attrelid = c.conrelid
WHERE NOT EXISTS
        /* is there a matching index for the constraint? */
        (SELECT 1 FROM pg_catalog.pg_index i
         WHERE i.indrelid = c.conrelid
           /* the first index columns must be the same as the
              key columns, but order doesn't matter */
           AND (i.indkey::smallint[])[0:cardinality(c.conkey)-1]
               @> c.conkey)
  AND c.contype = 'f'
GROUP BY c.conrelid, c.conname, c.confrelid
ORDER BY pg_catalog.pg_relation_size(c.conrelid) DESC;
```

Every now and then, it's good to check which indexes are unused and drop them to speed up data
writes to these tables. The following query shows how many times each index has been used:

```sql
SELECT s.schemaname,
       s.relname AS tablename,
       s.indexrelname AS indexname,
       pg_relation_size(s.indexrelid) AS index_size,
       s.idx_scan,
       s.idx_tup_read,
       s.idx_tup_fetch
FROM pg_catalog.pg_stat_user_indexes s
   JOIN pg_catalog.pg_index i ON s.indexrelid = i.indexrelid
ORDER BY idx_scan ASC;
```

Note: after adding/removing indexes, it's important to reset the index usage statistics as the queries
will start using different indexes and the previous numbers become obsolete.

Reset your stats with `SELECT pg_stat_reset();`

### Change the Hasura API

To change what to expose, to whom and how in the API served by Hasura, you need to modify the metadata of Hasura.
These yaml files in `metadata/` _could_ be changed by writing text.
On the other hand, the admin UI exposes all the choices.

Start the admin UI:

```sh
hasura console
```

In the admin UI:

1. Navigate to the Data tab.
1. Select the relevant schema.
1. To expose something new in the GraphQL API, track new tables, foreign-key relationships or functions from the middle panel.
1. Modify permissions of tracked tables by selecting a table from the left panel and by choosing the Permissions tab from the middle panel.
1. Write the names of any roles that are missing but should be authorized.
1. To change any operation authorization, click on the corresponding cell in the table that you wish to change.

When you make changes in the admin UI, `hasura console` will modify `metadata/*.yaml` files accordingly in the background.

Note: seems like `hasura console` won't update metadata in some cases. If that happens, metadata updates can be forced (after doing the changes in `hasura console`) from the [cli](https://hasura.io/docs/latest/graphql/core/migrations/manage-metadata.html#exporting-hasura-metadata):
`hasura metadata export`

When you are done clicking, commit the metadata changes into git.

### Add/modify seed data

You may need some seed data in your microservice to work with. To enable this, a new Hasura
docker image version is created that extends the base image with some generic seed data. For
simplicity, we loading the seed data as migrations so that its packaged simpler together into the
Hasura docker image. (The built-in `hasura seed` function does not load the data automatically on
start-up).

To add/modify a new seed migration:

1. create a new migration directory with `up.sql` and `down.sql` in the `migrations/seed-data/default` folder
1. fill it up with `INSERT INTO` commands or similar
1. to test it:
   a) set the `migrations_directory` to `migrations/seed-data` in your `config.yaml`.
   a) restart your `testdb` container with `docker restart testdb`. If you are using volumes to
   persist its data, remember to delete the volume before restarting the testdb container.
   a) apply the new seed migration with `hasura migrate apply --up 1`
   a) on success, check if the database does contain the seed data, e.g. through the hasura console
   data browser

When uploading the changes to git, the ci/cd pipeline will automatically create a docker image that
also contains the seed data and tag it as `jore4-hasura:seed-***`. This is intended to be used only
in development and e2e testing.

The regular `jore4-hasura:***` docker base image does not contain this seed data and is intended
to be used in production.

### Add/modify HSL specific schema

You can add HSL specific schema changes by updating files in `migrations/hsl` and `metadata/hsl` directories.
The folder structure follows the same structure as the original ones. Generic (Transmodel compatible)
migrations are located in `migrations/generic` and `metadata/generic` respectively.

When adding new metadata files, they can be added in the `metadata/hsl` directory in the correct location.
However, when adding content to existing metadata files, a new file should be created in the
directory of patched file, inside `/patch` directory located in the directory where the original metadata file is
(`/metadata/hsl/databases/detault/tables/patch`). The patch file's name should match the name of the file to
be patched. The added file should only contain the new lines to be added.

For example, to add a new HSL specific relationship to `route_line` table, a new file should be created. The original
file to be patched would be `/metadata/hsl/databases/detault/tables/route_line.yaml`.

`/metadata/hsl/databases/detault/tables/patch/route_line.yaml`:

```
object_relationships:
- name: name_of_relation
  using:
    foreign_key_constraint_on: column_name
```

When uploading the changes to git, the ci/cd pipeline will automatically create a docker image that
also contains the HSL specific schema changes and tag it as `jore4-hasura:hsl-***`.

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

## Integration tests

In order to run the integration tests, follow the following steps:

1. Make sure you have hasura and its dependencies up and running with `./scripts/start_dependencies.sh`.
1. Install the required node packages:
   ```
   cd integration-test
   yarn install
   ```
1. Run the tests in the `integration-test`-directory:
   `yarn test`

## Migration tests

To make sure all the up and down migrations work as intended, we are running a CI job to execute these
migrations on an empty databases and on databases with data.

To run the tests yourself, on an empty database:

1. Start up hasura in docker-compose with `./scripts/start_dependencies.sh`
1. After it's up and running, run `./scripts/test-migrations.sh`. This will run the last few down and
   up migrations within the hasura docker container.

To run the migration tests on a database with data, you can use the seed version. Just set the hasura
image target in `./docker/docker-compose.custom.yml` to `target: hasura-seed`. The same
`test-migrations.sh` should work.

## Deployment

Secrets should be passed as files to Docker images in production environments.
[As long as Hasura cannot read secrets from files](https://github.com/hasura/graphql-engine/issues/3989), we need to provide our own entrypoint for the Docker image.
Our entrypoint reads the secrets and delivers them to Hasura.

### Secrets used by the docker image

Our Docker image expects the following secrets to be bound to the container:

| Secret file               | Description                                                             |
| ------------------------- | ----------------------------------------------------------------------- |
| hasura-admin-secret       | Password with which admins can access the console and other features    |
| db-hostname               | Hostname/IP address for the default database                            |
| db-name                   | Name of the database instance to connect to within the default database |
| db-username               | Username for the default database                                       |
| db-password               | Password for the default database                                       |
| db-auth-username          | Name of the sql user that is used by the auth backend service           |
| db-jore3importer-username | Name of the sql user that is used by the jore3 importer service         |

### Use of the Docker image

The Docker image expects the following values for the following environment variables or for the corresponding CLI options.
The expected values are **set by default**.

| Environment variable             | Default value      |
| -------------------------------- | ------------------ |
| HASURA_GRAPHQL_UNAUTHORIZED_ROLE | anonymous          |
| HASURA_GRAPHQL_MIGRATIONS_DIR    | /hasura-migrations |
| HASURA_GRAPHQL_METADATA_DIR      | /hasura-metadata   |

**Please don't change them. Either don't define them at all or set them to the same values as documented above.**

In addition, you should properly set the following environment variables for authorization to work:

| Environment variable          | Value                                                                               |
| ----------------------------- | ----------------------------------------------------------------------------------- |
| HASURA_GRAPHQL_AUTH_HOOK_MODE | GET                                                                                 |
| HASURA_GRAPHQL_AUTH_HOOK      | auth-backend webhook url, e.g. "http://localhost:3001/api/public/v1/hasura/webhook" |

When using authorization via the web hook, you should normally leave the above mentioned
`HASURA_GRAPHQL_UNAUTHORIZED_ROLE` variable _unset_.

For more detailed documentation on the used environment variables, please see
[the Hasura documentation](https://hasura.io/docs/latest/graphql/core/deployment/graphql-engine-flags/reference.html).

We are using [hasura/graphql-engine](https://registry.hub.docker.com/r/hasura/graphql-engine) as a base image.
Please see the link for detailed documentation.

### Authorizing PostgreSQL users in the SQL schema migrations

The PostgreSQL usernames for the other users are stored in Docker or Kubernetes secrets.
The service responsible for authorizing other users has to read the usernames from the secrets at runtime.
Yet the SQL schema migrations are stored in git and stored in the Docker image before runtime.

This conundrum is solved by the script [`./scripts/replace-placeholders-in-sql-schema-migrations.sh`](./scripts/replace-placeholders-in-sql-schema-migrations.sh) which is run in the Docker entrypoint.
The script does string interpolation by replacing placeholders in the SQL schema migration files with the contents of the Docker secrets.

The placeholders are mangled secret filenames with bracket delimiters `xxx_` and `_xxx`.
The mangling turns every character not in `[0-9A-Za-z_]` into `_`.
For example the username stored in a secret named `foo-bar.baz` is used with the placeholder `xxx_foo_bar_baz_xxx` in the SQL schema migration files.

It's a known issue that if the SQL migration files contain placeholders catenated together, e.g. `xxx_foo_xxxxxx_bar_xxx`, and if both secrets `foo` and `bar` are missing, the error message will complain about only one missing secret.
The developer is expected to interpret that two secrets are required.
The issue could be solved with PCRE which is not available for the current implementation.

Another issue is that **the secrets may not contain newlines within the strings**.
Newlines at the end of a secret are permitted.
This might be fixable with `sed -z`, if available, or switching from `sed` to `awk`.

#### Requirements for the secrets

1. With the default value of 63 for the PostgreSQL option [`max_identifier_length`](https://www.postgresql.org/docs/13/runtime-config-preset.html) and the current choice of bracket delimiters:

   - the names of the secrets containing the Jore4 DB usernames should have at most 55 ASCII characters (`63 - length("xxx_") - length("_xxx") == 55`)
   - the contents of those secrets should have at most 63 ASCII characters

   If we hit the limit, either we shorten the name or increase the limit.

1. The names of the secrets should not contain the substring `xxx`.

#### Design rationale

The mangling is used because of the limitations of SQL identifiers as per [the PostgreSQL documentation](https://www.postgresql.org/docs/13/sql-syntax-lexical.html):

> SQL identifiers and key words must begin with a letter (a-z, but also letters with diacritical marks and non-Latin letters) or an underscore (\_). Subsequent characters in an identifier or key word can be letters, underscores, digits (0-9), or dollar signs ($). Note that dollar signs are not allowed in identifiers according to the letter of the SQL standard, so their use might render applications less portable. The SQL standard will not define a key word that contains digits or starts or ends with an underscore, so identifiers of this form are safe against possible conflict with future extensions of the standard.

The shell in `hasura/graphql-engine:v2.0.9` is `ash` from BusyBox v1.31.0.
That limits us to barebones POSIX shell capabilities in the replacer script.

Requirements for the string interpolation:

1. Simply replace strings. No string formatting is needed.
1. Do not rely on shell variables marked with `$` as plpgsql uses `$`.
1. Fail when a placeholder cannot be replaced.
1. Before replacing the placeholders, the SQL schema files must be valid SQL.
1. Use the tools available in our Hasura Docker image.

Consequences:

1. String interpolation with bracket delimiters is enough.
1. Do not use `eval` or `envsubst` to avoid mistaken `$` replacements.
1. A trivial `sed` oneliner is not enough.
1. Use only valid SQL identifier letters in the bracket delimiters.
1. `sed`, `grep` and `awk` are available, `perl` and `python` are not.
1. The names of the secrets must not contain the bracket delimiters.

#### Tests

There are tests for the string interpolation script in [`./test/string-interpolation`](./test/string-interpolation).
