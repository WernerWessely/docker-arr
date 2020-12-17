# AR rust container, inspired by gpavlidi/wine

FROM rust:1.48.0-buster

ARG DEBIAN_FRONTEND=noninteractive

# ADD cargo.pem /usr/local/share/ca-certificates/br.crt
# RUN update-ca-certificates
# ENV SSL_CERT_FILE=/usr/local/share/ca-certificates/br.crt

# --- Wine stuff ---- #
RUN dpkg --add-architecture i386 && apt-get update
RUN apt-get install -y software-properties-common gnupg2 ca-certificates

RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN apt-key add winehq.key
RUN apt-add-repository 'deb https://dl.winehq.org/wine-builds/debian/ buster main' && apt-get update
RUN wget -nc https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/Release.key
RUN apt-key add Release.key
RUN apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10 ./'

RUN apt-get update && apt-get install -y --install-recommends libfaudio0 winehq-stable winbind xvfb

ENV WINEDEBUG=fixme-all
ENV WINEPREFIX=/root/.wine 
ENV WINEARCH=win32
RUN winecfg

RUN apt-get install -y cabextract
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
RUN chmod +x winetricks
RUN cp winetricks /usr/local/bin

RUN wineboot -u && xvfb-run winetricks -q vcrun2015

# --- Rust stuff ---- #
RUN rustup component add rustfmt rust-docs rls clippy rust-src rust-analysis
RUN apt-get install -y --no-install-recommends llvm-dev libclang-dev clang curl unzip git