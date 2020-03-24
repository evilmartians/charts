FROM postgres:9.6.17-alpine

RUN apk -U --no-cache upgrade && apk add --no-cache restic ca-certificates
