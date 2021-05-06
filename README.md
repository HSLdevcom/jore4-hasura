# jore4-hasura

Minimal hasura & docker setup for jore4 development.

## Quickstart

```sh
docker-compose up --build
```

## Development

To play with the GraphQL API or to modify the backend, it is easiest to use the Hasura admin UI ("console").

To play around, in 2 minutes:

1. Set `HASURA_GRAPHQL_ENABLE_CONSOLE` to `"true"` in [`docker-compose.yml`](docker-compose.yml).
1. Open http://localhost:8080 to access the console.
   The default admin secret is also in `docker-compose.yml`.
   The initial view opens up with a beefed-up GraphiQL.

To contribute, in 10 minutes:

1. Leave `HASURA_GRAPHQL_ENABLE_CONSOLE` as `"false"` in `docker-compose.yml`.
1. Install [Hasura CLI](https://hasura.io/docs/1.0/graphql/core/hasura-cli/install-hasura-cli.html).
1. Create `.env` with at least `HASURA_GRAPHQL_ADMIN_SECRET`.
   This will be utilized in `docker-compose.yml`.
1. Groan... to have `hasura/config.yml` in `hasura/` and to still use `.env` with Hasura CLI: `ln -s "$(pwd)/.env" hasura/.env`
1. `cd hasura/`
1. Run `hasura console` to start the console.
1. Run `hasura migrate ...` to read or write DB migration files.
1. Run `hasura metadata ...` to read or write Hasura configuration.

## Using docker image

We are using [hasura/graphql-engine](https://registry.hub.docker.com/r/hasura/graphql-engine) as a base image.
Please see the link for detailed documentation.
