FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

RUN make check

ENTRYPOINT ["sh", "-c", "./build/$(jq -r .name config.json)"]
CMD ["--version"]
