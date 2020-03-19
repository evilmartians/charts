FROM alpine

RUN apk -U --no-cache upgrade && apk add --no-cache restic postgresql ca-certificates
