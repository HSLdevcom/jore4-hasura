FROM hasura/graphql-engine:v2.45.1-ce.cli-migrations-v3.ubuntu AS hasura-generic

# needed for enabling namespacing for logical databases. This env variable should be removed when this feature becomes stable
ENV HASURA_GRAPHQL_EXPERIMENTAL_FEATURES="naming_convention"
ENV HASURA_GRAPHQL_MIGRATIONS_DIR="/hasura-migrations"
ENV HASURA_GRAPHQL_METADATA_DIR="/hasura-metadata"

EXPOSE 8080
WORKDIR /

# Helper scripts should change rarely.
COPY ./scripts /app/scripts
# download script for reading docker secrets
ADD https://raw.githubusercontent.com/HSLdevcom/jore4-tools/main/docker/read-secrets.sh /app/scripts/read-secrets.sh

# Primary change culprits, add them last to maximize layer reuse
COPY ./migrations/generic "${HASURA_GRAPHQL_MIGRATIONS_DIR}"
COPY ./metadata/generic "${HASURA_GRAPHQL_METADATA_DIR}"

ENTRYPOINT ["/app/scripts/docker-entrypoint.sh"]
CMD ["graphql-engine", "serve"]
HEALTHCHECK --interval=5s --timeout=5s --retries=5 \
  CMD curl --fail http://localhost:8080/healthz || exit 1

# extend the base image to also load hsl specific migrations and metadata
FROM hasura-generic AS hasura-hsl
ARG TARGETARCH

ADD --chmod=755 https://github.com/mikefarah/yq/releases/download/v4.45.1/yq_linux_$TARGETARCH /usr/bin/yq

# copy hsl-specific migrations and metadata and stitch them together with the generic ones
COPY ./migrations/hsl "${HASURA_GRAPHQL_MIGRATIONS_DIR}/"
COPY ./metadata/hsl "${HASURA_GRAPHQL_METADATA_DIR}/hsl"
RUN /app/scripts/merge-metadata.sh ${HASURA_GRAPHQL_METADATA_DIR}/hsl ${HASURA_GRAPHQL_METADATA_DIR}
