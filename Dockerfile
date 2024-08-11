FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for Qt Application
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libgl1-mesa-dev \
    libglib2.0-dev \
    qt6-base-dev \
    qt6-declarative-dev \
    qt6-tools-dev-tools \
    qt6-tools-dev \
    cmake \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install dependencies for Python tools
# TODO

WORKDIR /app

COPY /app .

RUN qtchooser -install qt6 $(which qmake6)

RUN mkdir build

WORKDIR /app/build

RUN qmake6 ../CFSW.pro && make

# CMD [ "./CFSW" ]