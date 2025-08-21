FROM alpine:3.22

RUN \
  apk upgrade --update --no-interactive \
  && apk add --no-interactive \
    bash \
    curl \
    jq

COPY \
  --chown=0:0 \
  --chmod=755 \
  reload_schema.sh \
  /opt/reload_schema

CMD ["/opt/reload_schema"]
