FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl jq && \
    apt-get clean

WORKDIR /app
COPY entrypoint.sh .
COPY input.json .

ENTRYPOINT ["bash", "entrypoint.sh"]
