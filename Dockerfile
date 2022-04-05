FROM hasura/graphql-engine:v2.1.1.cli-migrations-v3 AS hasura-generic
EXPOSE 8080
RUN apt-get update && apt-get install -y \
  curl \
  && rm -rf /var/lib/apt/lists/*
ENV HASURA_GRAPHQL_MIGRATIONS_DIR="/hasura-migrations"
ENV HASURA_GRAPHQL_METADATA_DIR="/hasura-metadata"
COPY ./migrations/generic "${HASURA_GRAPHQL_MIGRATIONS_DIR}"
COPY ./metadata/generic "${HASURA_GRAPHQL_METADATA_DIR}"
WORKDIR /app
COPY ./scripts ./scripts
ENTRYPOINT ["/app/scripts/docker-entrypoint.sh"]
CMD ["graphql-engine", "serve"]
HEALTHCHECK --interval=5s --timeout=5s --retries=5 \
  CMD curl --fail http://localhost:8080/healthz || exit 1


# extend the base image to also load hsl specific migrations and metadata
FROM hasura-generic AS hasura-hsl
# install yq
RUN apt-get update && apt-get install -y gnupg2 software-properties-common && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64 && \
    add-apt-repository ppa:rmescandon/yq && \
    apt-get update && \
    apt-get install -y yq

COPY ./migrations/hsl "${HASURA_GRAPHQL_MIGRATIONS_DIR}/"
COPY ./metadata/hsl "${HASURA_GRAPHQL_METADATA_DIR}"
WORKDIR /
RUN /app/scripts/merge-metadata.sh ${HASURA_GRAPHQL_METADATA_DIR}
WORKDIR /app


# extend the hasura-hsl image to also load some seed data as migrations
FROM hasura-hsl AS hasura-seed
COPY ./migrations/seed-data "${HASURA_GRAPHQL_MIGRATIONS_DIR}/"
