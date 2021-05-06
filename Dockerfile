FROM hasura/graphql-engine:v1.3.3.cli-migrations-v2
ENV HASURA_GRAPHQL_UNAUTHORIZED_ROLE="anonymous"
COPY ./hasura/migrations /hasura-migrations
COPY ./hasura/metadata /hasura-metadata
