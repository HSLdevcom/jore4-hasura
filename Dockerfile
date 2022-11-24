FROM hasura/graphql-engine:v2.16.0-ce.cli-migrations-v3.ubuntu AS hasura-generic

# needed for enabling namespacing for logical databases. This env variable should be removed when this feature becomes stable
ENV HASURA_GRAPHQL_EXPERIMENTAL_FEATURES="naming_convention"

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
# download script for reading docker secrets
RUN curl -o /app/scripts/read-secrets.sh "https://raw.githubusercontent.com/HSLdevcom/jore4-tools/main/docker/read-secrets.sh"
ENTRYPOINT ["/app/scripts/docker-entrypoint.sh"]
CMD ["graphql-engine", "serve"]
HEALTHCHECK --interval=5s --timeout=5s --retries=5 \
  CMD curl --fail http://localhost:8080/healthz || exit 1

# extend the base image to also load hsl specific migrations and metadata
FROM hasura-generic AS hasura-hsl

# install yq from apt-get
# note: when installing the binary directly from the github release, it did not work correctly
# also, this should work with the arm architecture too
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
  && add-apt-repository -y ppa:rmescandon/yq \
  && apt-get install -y yq=4.16.2 \
  && rm -rf /var/lib/apt/lists/*

# copy hsl-specific migrations and metadata and stitch them together with the generic ones
COPY ./migrations/hsl "${HASURA_GRAPHQL_MIGRATIONS_DIR}/"
COPY ./metadata/hsl "${HASURA_GRAPHQL_METADATA_DIR}/hsl"
RUN /app/scripts/merge-metadata.sh ${HASURA_GRAPHQL_METADATA_DIR}/hsl ${HASURA_GRAPHQL_METADATA_DIR}

# extend the hasura-hsl image to also load some seed data as migrations
FROM hasura-hsl AS hasura-seed

# copy seed-data migrations
COPY ./migrations/seed-data "${HASURA_GRAPHQL_MIGRATIONS_DIR}/"
