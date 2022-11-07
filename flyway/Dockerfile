FROM flyway/flyway:9.7.0

# RUN apt-get update && apt-get install -y \
#   curl \
#   && rm -rf /var/lib/apt/lists/*

# by only the generic migrations are included, hsl and seed data migrations are not
ENV INCLUDE_HSL_MIGRATIONS=false
ENV INCLUDE_SEED_DATA_MIGRATIONS=false
ENV MIGRATIONS_DIR="/flyway/sql"

# store configuration file to docker image
COPY ./flyway.conf /flyway/conf/

# store all migrations to docker image
COPY ./migrations "$MIGRATIONS_DIR"

# store entrypoint script to docker image
COPY ./docker-entrypoint.sh /scripts/

# download script for reading docker secrets
RUN curl -o /scripts/read-secrets.sh "https://raw.githubusercontent.com/HSLdevcom/jore4-tools/main/docker/read-secrets.sh"

ENTRYPOINT ["/scripts/docker-entrypoint.sh"]
