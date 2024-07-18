FROM postgres:14.12-alpine

RUN apk -U --no-cache upgrade && apk add --no-cache ca-certificates

# restic installation
ARG RESTIC_URL=https://github.com/restic/restic/releases/download/v0.16.5/restic_0.16.5_linux_amd64.bz2
ARG RESTIC=restic_0.16.5_linux_amd64
ARG RESTIC_ARCHIVE=restic_0.16.5_linux_amd64.bz2
ARG RESTIC_SHA256SUM=f1a9c39d396d1217c05584284352f4a3bef008be5d06ce1b81a6cf88f6f3a7b1

RUN wget -q "${RESTIC_URL}" \
  && echo "${RESTIC_SHA256SUM}  ${RESTIC_ARCHIVE}" | sha256sum -c - \
  && bzip2 -d "${RESTIC_ARCHIVE}" \
  && chmod +x "${RESTIC}" \
  && mv "${RESTIC}" /usr/bin/restic
