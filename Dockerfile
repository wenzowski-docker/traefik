ARG BUILD_DATE
ARG VERSION
ARG VCS_URL
ARG VCS_REF

FROM traefik:$VERSION
MAINTAINER Alec Wenzowski "alec@wenzowski.com"

HEALTHCHECK --interval=1s --timeout=1s --retries=60 \
  CMD ["/traefik", "healthcheck", "--web"]

# Metadata
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="Træfik" \
      org.label-schema.description="Træfik (pronounced like traffic) is a modern HTTP reverse proxy and load balancer made to deploy microservices with ease." \
      org.label-schema.url="https://github.com/wenzowski-docker/traefik" \
      org.label-schema.vendor="The Wenzowski Group, Inc." \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version=$VERSION
