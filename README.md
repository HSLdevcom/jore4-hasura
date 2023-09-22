# jore4-hasura

Hasura GraphQL server for JORE4.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN "npx doctoc README.md" TO UPDATE -->

- [jore4-hasura](#jore4-hasura)
  - [Development](#development)
    - [Change the SQL schema](#change-the-sql-schema)
      - [Migrations directory structure](#migrations-directory-structure)
      - [Developing migrations](#developing-migrations)
    - [Change the Hasura API](#change-the-hasura-api)
    - [Advice for permissions](#advice-for-permissions)
    - [Incompatible SQL schema and metadata](#incompatible-sql-schema-and-metadata)
    - [Add/modify HSL specific schema](#addmodify-hsl-specific-schema)
    - [Add/modify seed data](#addmodify-seed-data)
    - [Optimizations](#optimizations)
    - [Debugging trigger performance](#debugging-trigger-performance)
  - [Tests](#tests)
    - [Integration and unit tests](#integration-and-unit-tests)
    - [HSL schema specific tests](#hsl-schema-specific-tests)
    - [Migration tests](#migration-tests)
    - [Dump tests](#dump-tests)
    - [String interpolation tests](#string-interpolation-tests)
  - [Deployment](#deployment)
    - [Secrets used by the docker image](#secrets-used-by-the-docker-image)
    - [Use of the Docker image](#use-of-the-docker-image)
    - [Authorizing PostgreSQL users in the SQL schema migrations](#authorizing-postgresql-users-in-the-sql-schema-migrations)
      - [Requirements for the secrets](#requirements-for-the-secrets)
      - [Design rationale](#design-rationale)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Development

To play with the GraphQL API or to modify the backend, it is easiest to use the
Hasura admin UI ("console").

1. Install
   [Hasura CLI](https://hasura.io/docs/latest/hasura-cli/install-hasura-cli/).
1. Start up all dependencies and build Hasura docker image locally, run
   `./scripts/start-dependencies.sh`. Hasura will apply the existing SQL
   migrations and server metadata. Wait until the service `hasura` is healthy.
1. Run `hasura console` to start the console.
1. Open <http://localhost:3201/console> in the browser to access the console.
   The admin secret is found from `/docker/secret-hasura-hasura-admin-secret`
   secret file. The initial view opens up with a beefed-up GraphiQL for testing
   queries.

Other possibly relevant commands for Hasura CLI:

1. Run `hasura migrate ...` to read or write DB migration files. Note that this
   runs the migrations from your local workspace, not the docker image. Should
   make sure that Hasura's `config.yaml` points to the correct migrations folder
   that is intended to be used.
1. Run `hasura metadata ...` to read or write Hasura configuration. Same as
   above, `config.yaml` should point to the correct directory.

### Change the SQL schema

We are using SQL migrations to modify the database schema. These migrations are
run by hasura on startup.

To create a new migration, start up the test database and the hasura server,
then call:

```sh
hasura migrate create ${SENSIBLE_SNAKE_CASE_MIGRATION_NAME}
```

Write your SQL schema changes in the files `up.sql` and `down.sql`, then move
them to the correct folder.

#### Migrations directory structure

The migrations are organized to the following directory structure

- `/migrations/generic`: generic database schema migrations. These are pretty
  much Transmodel compatible and are reusable in other public transportation
  contexts as well
  - `/default`: generic database schema for infrastructure, routes and lines
  - `/timetables`: generic database schema for timetables
- `/migrations/hsl`: HSL-specific schema changes. These contain custom additions
  on top of the Transmodel schema to support HSL's own needs
  - `/default`: HSL-specific schema additions for infrastructure, routes and
    lines
  - `/timetables`: HSL-specific schema additions for timetables
- `/migrations/seed-data`: Seed data migrations to ease development and to
  verify that the migrations are also functional if there's existing data in the
  database. These are added on top of the HSL schema.
  - `/default`: seed data for infrastructure, routes and lines
  - `/timetables`: seed data for timetables

Once you are convinced your SQL schema migration is correct, update the metadata
(see below) and commit the SQL files into git.

#### Developing migrations

The JORE4 project had been using the "classic" migrations that create objects in
the up migration and roll back the changes in the down migration. With the data
model getting more and more complex, maintainability has taken a massive hit.
PostgreSQL stores the SQL functions bodies as plain text, meaning that if a
table or column has changed, ALL the functions, views, etc. had to be dropped
and recreated to get updated. Both for up and the down migrations. This has
taken a big toll on maintainability as complex SQL functions had to be reviewed
again and again from a clean slate, not seeing that the actual change was e.g.
just a renamed column as proper diffing was not possible.

To ease this process, we're introducing two kinds of migrations.

_Data migrations_:

Similarly to the "classic" migrations, the up migrations create tables/columns
and down migrations roll back the changes. These migrations are only executed
once, even if hasura is restarted multiple times. We aim only to do changes in
these migrations that touch the data (e.g. creating tables and columns).

_Repeatable migrations_:

In contrary to the data migrations, repeatable migrations are repeated, meaning
that each time the Hasura container is restarted, these migrations are executed
again and again. These migrations contain the text `_R_` in their names. We
achieve this by hacking into Hasura's migration status table and making it
believe that these migrations haven't been applied yet. Note that this also
allows that the repeatable migrations are applied in the same order (so
technically in the order of the timestamps). We aim to only do changes that are
idempotent and won't change the data (e.g. creating functions and views).

_Migration structuring_

Currently the migrations are structured the following way (and also always
applied in this order):

1. generic schema \_R_before_migrate script: drops all idempotent objects
   (functions, views, constraints, triggers) from the generic schemas
2. generic schema data migrations: create/modify tables and columns
3. generic schema \_R_after_migrate scripts: (re)creates functions, views,
   constraints and triggers in the generic schemas
4. hsl schema \_R_before_migrate script: drops all idempotent objects
   (functions, views, constraints, triggers) from the hsl-specific schemas
5. hsl schema data migrations: create/modify tables and columns
6. hsl schema \_R_after_migrate scripts: (re)creates functions, views,
   constraints and triggers in the hsl schemas
7. seed schema migrations: insert seed data

_Development use-cases_

Q: How to create/modify/delete table? How to create/modify/delete a column? A:
Decide whether it's generic or HSL-specific change and add it as a _data
migration_ script.

Q: Where to create/modify/drop indexes? A: Create them as _data migration_
scripts. Indexes cannot be freely dropped and recreated as e.g. functions would
be as they are tightly coupled with the underlying tables.

Q: How to add check constraints to tables? A: All constraints are dropped in the
beginning including check constraints, so you should make sure that these are
recreated in repeatable migrations

Q: How to create/modify triggers? A: Create them as _repeatable migration_
scripts. As CREATE OR REPLACE doesn't work with these, you have to drop them
first and create them again.

Q: How to create/modify functions? A: Create them as _repeatable migration_
scripts.

Q: What goes to down migrations? A: For _data migrations_, you should create a
functioning rollback migration. For _repeatable migrations_, you don't need to
do anything as these are anyway deleted and recreated on every run.

Q: How do I drop objects from repeatable migrations (functions, triggers, etc)?
A: Just remove the CREATE command from their _repeatable_ migrations. The next
time Hasura is restarted, the function/trigger gets dropped but won't get
recreated.

### Change the Hasura API

To change what to expose, to whom and how in the API served by Hasura, you need
to modify the metadata of Hasura. These yaml files in `metadata/` _could_ be
changed by writing text. On the other hand, the admin UI exposes all the
choices.

Start the admin UI:

```sh
hasura console
```

In the admin UI:

1. Navigate to the Data tab.
1. Select the relevant schema.
1. To expose something new in the GraphQL API, track new tables, foreign-key
   relationships or functions from the middle panel.
1. Modify permissions of tracked tables by selecting a table from the left panel
   and by choosing the Permissions tab from the middle panel.
1. Write the names of any roles that are missing but should be authorized.
1. To change any operation authorization, click on the corresponding cell in the
   table that you wish to change.

When you make changes in the admin UI, `hasura console` will modify
`metadata/*.yaml` files accordingly in the background.

Note: if you modify the metadata within the docker container
(http://localhost:3201), the yaml files are not refreshed. Do make sure you make
the changes using `hasura console`.

Note: seems like `hasura console` won't update metadata in some cases. If that
happens, metadata updates can be forced (after doing the changes in
`hasura console`) from the
[cli](https://hasura.io/docs/latest/graphql/core/migrations/manage-metadata.html#exporting-hasura-metadata):
`hasura metadata export`

When you are done clicking, commit the metadata changes into git.

### Advice for permissions

The role name for public, unauthenticated use is given to the Hasura server with
the environment variable `HASURA_GRAPHQL_UNAUTHORIZED_ROLE`. That name is set to
`anonymous` within the Docker image. Keep using the same name unless you have a
reason for renaming. The name is not visible in the GraphQL API.

If the SQL schema generates a default value that should always be used for a
column, e.g. for a numeric ID or for a creation timestamp, do not allow inserts
or updates for that column over the GraphQL API.

Do not allow inserting, updating or deleting data in reference tables, i.e.
"enum-like" tables, over the GraphQL API. Insert the values in a migration,
instead. Proper [enums](https://www.postgresql.org/docs/12/datatype-enum.html)
are hard to change even in the migration files so avoid using them.

### Incompatible SQL schema and metadata

If you make backwards-incompatible changes to the SQL schema, the old Hasura
metadata might become incompatible with the new SQL schema.

One way to resolve the Hasura metadata conflicts:

1. Reload the metadata: Navigate to Settings (the cog in the top bar), to
   Metadata Actions (left panel) and to Reload metadata (middle panel). Click
   Reload.
1. Remove the conflicting parts of the metadata: Navigate to Metadata Status
   (left panel). Read which parts of the metadata conflict with the SQL schema.
   Once you know what should be changed, click Delete all and OK.
1. Recreate the missing parts of the metadata as explained above.

### Add/modify HSL specific schema

You can add HSL specific schema changes by updating files in the HSL-specific
directories, see [here](#migrations-directory-structure)

If you wish to apply HSL migrations in local development environment:

- modify `docker/docker-compose.custom.yml`: set `jore4-hasura` build target to
  `target: hasura-hsl`
- stop docker dependencies and recreate the `testdb` container
  (`./scripts/stop-dependencies.sh`, `./scripts/start-dependencies.sh`)
- modify `config.yaml`: change `migrations_directory` to
  `migrations_directory: migrations/hsl`
- now you should be able to see and apply the hsl migrations with
  `hasura migrate` commands

When adding new metadata files, they can be added in the `metadata/hsl`
directory in the correct location. These will be merged with the generic
metadata when starting up the HSL Docker container. See the merge script
`scripts/merge-metadata.sh` for details.

For example, to add a new HSL specific relationship to `route_line` table, a new
file should be created. The original file to be patched would be
`/metadata/hsl/databases/detault/tables/route_line.yaml`.

Patch file: `/metadata/hsl/databases/detault/tables/route_line.yaml`:

```
object_relationships:
- name: name_of_relation
  using:
    foreign_key_constraint_on: column_name
```

When uploading the changes to git, the ci/cd pipeline will automatically create
a docker image that also contains the HSL specific schema changes and tag it as
`jore4-hasura:hsl-***`.

### Add/modify seed data

You may need some seed data in your microservice to work with. To enable this, a
new Hasura docker image version is created that extends the base image with some
generic seed data. For simplicity, we loading the seed data as migrations so
that its packaged simpler together into the Hasura docker image. (The built-in
`hasura seed` function does not load the data automatically on start-up).

To add/modify a new seed migration:

1. create a new migration directory with `up.sql` and `down.sql` in the
   `migrations/seed-data/default` folder
1. fill it up with `INSERT INTO` commands or similar
1. to test it:
   1. set the `migrations_directory` to `migrations/seed-data` in your
      `config.yaml`.
   1. restart your `testdb` container with `docker restart testdb`. If you are
      using volumes to persist its data, remember to delete the volume before
      restarting the testdb container.
   1. apply the new seed migration with `hasura migrate apply --up 1`
   1. on success, check if the database does contain the seed data, e.g. through
      the hasura console data browser

When uploading the changes to git, the ci/cd pipeline will automatically create
a docker image that also contains the seed data and tag it as
`jore4-hasura:seed-***`. This is intended to be used only in development and e2e
testing.

The regular `jore4-hasura:hsl-***` docker base image does not contain this seed
data and is intended to be used in production.

### Optimizations

PostgreSQL by default does not create indexes for foreign key columns. In some
cases, it's useful to create the index. E.g. when joining larger tables.

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

Every now and then, it's good to check which indexes are unused and drop them to
speed up data writes to these tables. The following query shows how many times
each index has been used:

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

Note: after adding/removing indexes, it's important to reset the index usage
statistics as the queries will start using different indexes and the previous
numbers become obsolete.

Reset your stats with `SELECT pg_stat_reset();`

### Debugging trigger performance

Data validation relies largely on triggers, which can get heavy to run with
large amounts of data. EXPLAIN ANALYZE can't normally be used for optimizing
these because query plans retrieved with it do not include triggered functions.

To get execution plans for triggered functions you need to turn on auto explain
with nested statement logging. This can be done by running following queries in
DB console:

```sql
LOAD 'auto_explain';
SET auto_explain.log_min_duration = 0;
SET auto_explain.log_analyze = TRUE;
SET auto_explain.log_timing = TRUE;
SET auto_explain.log_nested_statements = TRUE;
```

After this the EXPLAIN output from all queries including their triggers will be
printed to testdb log.

## Tests

### Integration and unit tests

In order to run the integration/unit tests, follow the following steps:

1. Install NodeJS (currently using version 18.x) and yarn (1.x)
1. Make sure you have hasura and its dependencies up and running with
   `./scripts/start-dependencies.sh`.
1. Install the required node packages:
   ```
   cd test/hasura
   yarn install
   ```
1. Run the tests in the `test/hasura`-directory: `yarn test`

### HSL schema specific tests

HSL schema specific features have their own tests and datasets (which extend the
generic dataset). Since they require different schema in DB, currently only
either generic or hsl tests can be run at a time. Selecting if generic or hsl
test files should be included in Jest run is controlled via
`HASURA_DATABASE_SCHEMA` environment variable (values `generic` or `hsl`). The
variable is set automatically with `test` and `test-hsl` yarn tasks.

HSL tests depend on generic side (= imports data / code from there, eg. for data
setup), but generic side should be oblivious of the hsl side (= no imports of
hsl code to generic side). The idea is that if one were ever to want to use only
generic side (or extend it with their own), they could just take the generic
tests and drop the entire hsl folder.

To run HSL specific tests, some manual steps are currently required:

- if dependencies are running, stop them with `./scripts/stop-dependencies.sh`
- modify `docker/docker-compose.custom.yml`: set `jore4-hasura` build target to
  `target: hasura-hsl`
- if testdb has generic schema, clear it: `docker rm testdb --volumes`
- restart dependencies with `./scripts/start-dependencies.sh`
- run the HSL tests with `yarn test-hsl` in `test/hasura` directory

### Migration tests

To make sure all the up and down migrations work as intended, we are running a
CI job to execute these migrations on an empty databases and on databases with
data.

To run the tests yourself, on an empty database:

1. Start up hasura in docker-compose with `./scripts/start-dependencies.sh`
1. After it's up and running, run `./scripts/test-migrations.sh`. This will run
   the last few down and up migrations within the hasura docker container.

To run the migration tests on the HSL datamodel or with seed data, just set the
hasura image target in `./docker/docker-compose.custom.yml` to
`target: hasura-seed` and start the dependencies as such. The same
`./scripts/test-migrations.sh` script should work.

### Dump tests

We're using the generated dumps `./migrations/routesdb-dump.sql` and
`./migrations/timetablesdb-dump.sql` to see the latest version of the database
schema. This helps to see what actual changes happened after a potentially long
and verbose migration script. Note that these dumps are sorted for comparability
using the [pgdump-sort](https://github.com/tigra564/pgdump-sort) tool.

These dumps are generated within the testdb docker container to assure version
compatibility and to avoid unnecessary changes in git. To generate the dumps,
execute `./scripts/generate-dumps.sh` while the latest version of the generic
hasura container is running (`./scripts/start-dependencies.sh`).

Note that CI also checks that the dumps are up-to-date.

### String interpolation tests

There are tests for the string interpolation script in
[`./test/string-interpolation`](./test/string-interpolation).

These are testing that the interpolation used for substituting secret values in
migration files works as intended. See
[Authorizing PostgreSQL users in the SQL schema migrations](#authorizing-postgresql-users-in-the-sql-schema-migrations)

## Deployment

Secrets should be passed as files to Docker images in production environments.
[As long as Hasura cannot read secrets from files](https://github.com/hasura/graphql-engine/issues/3989),
we need to provide our own entrypoint for the Docker image. Our entrypoint reads
the secrets and delivers them to Hasura.

### Secrets used by the docker image

Our Docker image expects the following secrets to be bound to the container:

| Secret file                | Description                                                             |
| -------------------------- | ----------------------------------------------------------------------- |
| hasura-admin-secret        | Password with which admins can access the console and other features    |
| db-hostname                | Hostname/IP address for the default database                            |
| db-name                    | Name of the database instance to connect to within the default database |
| db-timetables-name         | Name of the logical database for timetables                             |
| db-username                | Username for the default database                                       |
| db-password                | Password for the default database                                       |
| db-auth-username           | Name of the sql user that is used by the auth backend service           |
| db-jore3importer-username  | Name of the sql user that is used by the jore3 importer service         |
| db-timetables-api-username | Name of the sql user that is used by the timetables API service         |

### Use of the Docker image

The Docker image expects the following values for the following environment
variables or for the corresponding CLI options. The expected values are **set by
default**.

| Environment variable             | Default value      |
| -------------------------------- | ------------------ |
| HASURA_GRAPHQL_UNAUTHORIZED_ROLE | anonymous          |
| HASURA_GRAPHQL_MIGRATIONS_DIR    | /hasura-migrations |
| HASURA_GRAPHQL_METADATA_DIR      | /hasura-metadata   |

**Please don't change them. Either don't define them at all or set them to the
same values as documented above.**

In addition, you should properly set the following environment variables for
authorization to work:

| Environment variable          | Value                                                                               |
| ----------------------------- | ----------------------------------------------------------------------------------- |
| HASURA_GRAPHQL_AUTH_HOOK_MODE | GET                                                                                 |
| HASURA_GRAPHQL_AUTH_HOOK      | auth-backend webhook url, e.g. "http://localhost:3001/api/public/v1/hasura/webhook" |

When using authorization via the web hook, you should normally leave the above
mentioned `HASURA_GRAPHQL_UNAUTHORIZED_ROLE` variable _unset_.

For more detailed documentation on the used environment variables, please see
[the Hasura documentation](https://hasura.io/docs/latest/graphql/core/deployment/graphql-engine-flags/reference.html).

We are using
[hasura/graphql-engine](https://registry.hub.docker.com/r/hasura/graphql-engine)
as a base image. Please see the link for detailed documentation.

### Authorizing PostgreSQL users in the SQL schema migrations

The PostgreSQL usernames for the other users are stored in Docker or Kubernetes
secrets. The service responsible for authorizing other users has to read the
usernames from the secrets at runtime. Yet the SQL schema migrations are stored
in git and stored in the Docker image before runtime.

This conundrum is solved by the script
[`./scripts/replace-placeholders-in-sql-schema-migrations.sh`](./scripts/replace-placeholders-in-sql-schema-migrations.sh)
which is run in the Docker entrypoint. The script does string interpolation by
replacing placeholders in the SQL schema migration files with the contents of
the Docker secrets.

The placeholders are mangled secret filenames with bracket delimiters `xxx_` and
`_xxx`. The mangling turns every character not in `[0-9A-Za-z_]` into `_`. For
example the username stored in a secret named `foo-bar.baz` is used with the
placeholder `xxx_foo_bar_baz_xxx` in the SQL schema migration files.

It's a known issue that if the SQL migration files contain placeholders
catenated together, e.g. `xxx_foo_xxxxxx_bar_xxx`, and if both secrets `foo` and
`bar` are missing, the error message will complain about only one missing
secret. The developer is expected to interpret that two secrets are required.
The issue could be solved with regular expressions which is not available for
the current implementation.

Another issue is that **the secrets may not contain newlines within the
strings**. Newlines at the end of a secret are permitted. This might be fixable
with `sed -z`, if available, or switching from `sed` to `awk`.

#### Requirements for the secrets

1. With the default value of 63 for the PostgreSQL option
   [`max_identifier_length`](https://www.postgresql.org/docs/13/runtime-config-preset.html)
   and the current choice of bracket delimiters:

   - the names of the secrets containing the Jore4 DB usernames should have at
     most 55 ASCII characters (`63 - length("xxx_") - length("_xxx") == 55`)
   - the contents of those secrets should have at most 63 ASCII characters

   If we hit the limit, either we shorten the name or increase the limit.

1. The names of the secrets should not contain the substring `xxx`.

#### Design rationale

The mangling is used because of the limitations of SQL identifiers as per
[the PostgreSQL documentation](https://www.postgresql.org/docs/13/sql-syntax-lexical.html):

> SQL identifiers and key words must begin with a letter (a-z, but also letters
> with diacritical marks and non-Latin letters) or an underscore (\_).
> Subsequent characters in an identifier or key word can be letters,
> underscores, digits (0-9), or dollar signs ($). Note that dollar signs are not
> allowed in identifiers according to the letter of the SQL standard, so their
> use might render applications less portable. The SQL standard will not define
> a key word that contains digits or starts or ends with an underscore, so
> identifiers of this form are safe against possible conflict with future
> extensions of the standard.

The shell in `hasura/graphql-engine` is `ash` from BusyBox v1.31.0. That limits
us to barebones POSIX shell capabilities in the replacer script.

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
