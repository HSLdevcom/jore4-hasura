FROM hasura/graphql-engine:v2.1.1.cli-migrations-v3 AS hasura-generic
EXPOSE 8080
RUN apt-get update && apt-get install -y \
  curl \
  && rm -rf /var/lib/apt/lists/*
ENV HASURA_GRAPHQL_MIGRATIONS_DIR="/hasura-migrations"
ENV HASURA_GRAPHQL_METADATA_DIR="/hasura-metadata"
COPY ./migrations/generic "${HASURA_GRAPHQL_MIGRATIONS_DIR}"
COPY ./metadata/generic "${HASURA_GRAPHQL_METADATA_DIR}"
WORKDIR /
COPY ./scripts /app/scripts
ENTRYPOINT ["/app/scripts/docker-entrypoint.sh"]
CMD ["graphql-engine", "serve"]
HEALTHCHECK --interval=5s --timeout=5s --retries=5 \
  CMD curl --fail http://localhost:8080/healthz || exit 1

# extend the base image to also load hsl specific migrations and metadata
FROM hasura-generic AS hasura-hsl

# install yq
ENV YQ_VERSION=v4.2.0 YQ_BINARY=yq_linux_amd64
RUN curl https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY} --output /usr/bin/yq && \
  chmod +x /usr/bin/yq

# copy hsl-specific migrations and metadata and stitch them together with the generic ones
COPY ./migrations/hsl "${HASURA_GRAPHQL_MIGRATIONS_DIR}/"
COPY ./metadata/hsl "${HASURA_GRAPHQL_METADATA_DIR}"
RUN /app/scripts/merge-metadata.sh ${HASURA_GRAPHQL_METADATA_DIR}

# extend the hasura-hsl image to also load some seed data as migrations
FROM hasura-hsl AS hasura-seed

# copy seed-data migrations
COPY ./migrations/seed-data "${HASURA_GRAPHQL_MIGRATIONS_DIR}/"
