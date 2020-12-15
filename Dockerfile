# AR rust container, inspired by suchja/wine

FROM rust:1.48.0-buster

ARG DEBIAN_FRONTEND=noninteractive

RUN rustup component add rustfmt rust-docs rls clippy rust-src rust-analysis

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    wine \
    wine32

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    llvm-dev libclang-dev clang \
    curl \
    unzip \
    git \
    ca-certificates

# Wine does not like running as root
RUN adduser \
    --home /home/wine \
    --disabled-password \
    --shell /bin/bash \
    --gecos "wine user" \
    --quiet \
    wine
    