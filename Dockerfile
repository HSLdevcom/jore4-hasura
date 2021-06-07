FROM hasura/graphql-engine:v1.3.3.cli-migrations-v2
ENV HASURA_GRAPHQL_UNAUTHORIZED_ROLE="anonymous"
ENV HASURA_GRAPHQL_MIGRATIONS_DIR="/hasura-migrations"
COPY ./hasura/migrations "${HASURA_GRAPHQL_MIGRATIONS_DIR}"
COPY ./hasura/metadata /hasura-metadata
WORKDIR /app
COPY ./replace-placeholders-in-sql-schema-migrations.sh ./
COPY ./docker-entrypoint.sh ./
ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["graphql-engine", "serve"]
