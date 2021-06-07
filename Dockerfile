FROM hasura/graphql-engine:v1.3.3.cli-migrations-v2
ENV HASURA_GRAPHQL_UNAUTHORIZED_ROLE="anonymous"
ENV HASURA_GRAPHQL_MIGRATIONS_DIR="/hasura-migrations"
ENV HASURA_GRAPHQL_METADATA_DIR="/hasura-metadata"
COPY ./hasura/migrations "${HASURA_GRAPHQL_MIGRATIONS_DIR}"
COPY ./hasura/metadata "${HASURA_GRAPHQL_METADATA_DIR}"
WORKDIR /app
COPY ./replace-placeholders-in-sql-schema-migrations.sh ./
COPY ./docker-entrypoint.sh ./
ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["graphql-engine", "serve"]
