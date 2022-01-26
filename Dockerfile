FROM hasura/graphql-engine:v2.1.1.cli-migrations-v3 AS hasura-base
EXPOSE 8080
RUN apt-get update && apt-get install -y \
  curl \
  && rm -rf /var/lib/apt/lists/*
ENV HASURA_GRAPHQL_MIGRATIONS_DIR="/hasura-migrations"
ENV HASURA_GRAPHQL_METADATA_DIR="/hasura-metadata"
COPY ./migrations "${HASURA_GRAPHQL_MIGRATIONS_DIR}"
COPY ./metadata "${HASURA_GRAPHQL_METADATA_DIR}"
WORKDIR /app
COPY ./scripts ./scripts
ENTRYPOINT ["/app/scripts/docker-entrypoint.sh"]
CMD ["graphql-engine", "serve"]
HEALTHCHECK --interval=5s --timeout=5s --retries=5 \
  CMD curl --fail http://localhost:8080/healthz || exit 1

# extend the base image to also load some seed data as migrations
FROM hasura-base AS hasura-seed
COPY ./seed-data/default "${HASURA_GRAPHQL_MIGRATIONS_DIR}/default/"
