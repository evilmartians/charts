FROM postgres:13.2-alpine

RUN apk -U --no-cache upgrade && apk add --no-cache ca-certificates

# restic installation
ARG RESTIC_URL=https://github.com/restic/restic/releases/download/v0.12.1/restic_0.12.1_linux_amd64.bz2
ARG RESTIC=restic_0.12.1_linux_amd64
ARG RESTIC_ARCHIVE=restic_0.12.1_linux_amd64.bz2
ARG RESTIC_SHA256SUM=11d6ee35ec73058dae73d31d9cd17fe79661090abeb034ec6e13e3c69a4e7088

RUN wget -q "$RESTIC_URL" \
  && echo "${RESTIC_SHA256SUM}  ${RESTIC_ARCHIVE}" | sha256sum -c - \
  && bzip2 -d "${RESTIC_ARCHIVE}" \
  && chmod +x "$RESTIC" \
  && mv "$RESTIC" /usr/bin/restic
