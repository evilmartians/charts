FROM alpine:3.13.2

RUN apk add --no-cache ansible

WORKDIR /ansible

COPY ansible/requirements.yml .

RUN ansible-galaxy install -r requirements.yml

COPY ansible/ .
