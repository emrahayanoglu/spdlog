FROM debian:buster as base

RUN apt-get update
RUN apt-get install -y cmake pkg-config build-essential git devscripts fakeroot wget unzip tar

RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture arm64
RUN apt-get update
RUN apt-get install -y crossbuild-essential-armhf crossbuild-essential-arm64

FROM base AS spdlog

RUN pwd
RUN pwd
RUN pwd

WORKDIR /app

RUN wget https://github.com/emrahayanoglu/spdlog/archive/refs/heads/debian-support.zip

RUN unzip debian-support.zip
RUN mv spdlog-debian-support/ spdlog/
RUN tar -czvf spdlog_1.11.0.orig.tar.gz spdlog

WORKDIR /app/spdlog/

RUN apt-get -o Debug::pkgProblemResolver=yes -y --force-yes build-dep .
RUN debuild -us -uc

WORKDIR /app
RUN rm -rf spdlog/
RUN unzip debian-support.zip
RUN mv spdlog-debian-support/ spdlog/
WORKDIR /app/spdlog/

RUN apt-get -o Debug::pkgProblemResolver=yes -y --force-yes build-dep -aarmhf .
RUN debuild -us -uc -aarmhf

WORKDIR /app
RUN rm -rf spdlog/
RUN unzip debian-support.zip
RUN mv spdlog-debian-support/ spdlog/
WORKDIR /app/spdlog/

RUN apt-get -o Debug::pkgProblemResolver=yes -y --force-yes build-dep -aarm64 .
RUN debuild -us -uc -aarm64

WORKDIR /app
RUN mkdir -p build
RUN cp *.deb build/