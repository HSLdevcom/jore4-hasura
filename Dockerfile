FROM hasura/graphql-engine:v1.3.3.cli-migrations-v2
ENV HASURA_GRAPHQL_MIGRATIONS_DIR="/hasura-migrations"
ENV HASURA_GRAPHQL_METADATA_DIR="/hasura-metadata"
COPY ./hasura/migrations "${HASURA_GRAPHQL_MIGRATIONS_DIR}"
COPY ./hasura/metadata "${HASURA_GRAPHQL_METADATA_DIR}"
WORKDIR /app
COPY ./scripts ./scripts
ENTRYPOINT ["/app/scripts/docker-entrypoint.sh"]
CMD ["graphql-engine", "serve"]
