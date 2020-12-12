# AR rust container, inspired by suchja/wine

FROM rust:1.48.0-buster

ARG DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    wine \
    wine32 \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    llvm-dev libclang-dev clang \
    curl \
    unzip \
    git \
    ca-certificates

RUN adduser \
    --home /home/dev \
    --disabled-password \
    --shell /bin/bash \
    --gecos "dev user" \
    --quiet \
    dev

# Wine does not like running as root
USER dev