FROM postgres:13.2-alpine

RUN apk -U --no-cache upgrade && apk add --no-cache ca-certificates

# restic installation
ARG RESTIC_URL=https://github.com/restic/restic/releases/download/v0.12.0/restic_0.12.0_linux_amd64.bz2
ARG RESTIC=restic_0.12.0_linux_amd64
ARG RESTIC_ARCHIVE=restic_0.12.0_linux_amd64.bz2
ARG RESTIC_SHA256SUM=63d13d53834ea8aa4d461f0bfe32a89c70ec47e239b91f029ed10bd88b8f4b80

RUN wget -q "$RESTIC_URL" \
  && echo "${RESTIC_SHA256SUM}  ${RESTIC_ARCHIVE}" | sha256sum -c - \
  && bzip2 -d "${RESTIC_ARCHIVE}" \
  && chmod +x "$RESTIC" \
  && mv "$RESTIC" /usr/bin/restic
