FROM alpine:3.14.0

RUN apk add --no-cache ansible openssh-client py3-boto3 py3-boto

WORKDIR /ansible

COPY ansible/requirements.yml .

RUN ansible-galaxy install -r requirements.yml

COPY ansible/ .
