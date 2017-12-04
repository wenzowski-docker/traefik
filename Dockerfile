ARG BUILD_DATE
ARG VERSION
ARG VCS_URL
ARG VCS_REF

FROM traefik:$VERSION
MAINTAINER Alec Wenzowski "alec@wenzowski.com"

HEALTHCHECK --interval=5m --timeout=3s \
  CMD traefik healthcheck

# @see http://label-schema.org/rc1/
LABEL org.label-schema.schema-version="1.0" 
LABEL org.label-schema.name="Træfik"
LABEL org.label-schema.description="Træfik (pronounced like traffic) is a modern HTTP reverse proxy and load balancer made to deploy microservices with ease."
LABEL org.label-schema.url="https://github.com/wenzowski-docker/traefik"
LABEL org.label-schema.vendor="The Wenzowski Group, Inc."
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.vcs-url=$VCS_URL
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.version=$VERSION
