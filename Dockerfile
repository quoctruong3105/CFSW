FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV QT_QPA_PLATFORM=xcb
ENV DISPLAY=:1

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
    qml6-module-qtquick-controls \
    qml6-module-qtquick-layouts \
    qml6-module-qtquick \
    qml6-module-qtqml-workerscript \
    qml6-module-qtquick-templates \
    qml6-module-qtquick-window \
    libqt6sql6-psql \
    cmake \
    xvfb \
    x11vnc \
    python3.10 \
    python3-pip \
    && pip3 install google-auth google-auth-oauthlib google-api-python-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY /app .

RUN qtchooser -install qt6 $(which qmake6)

RUN mkdir build

WORKDIR /app/build

RUN qmake6 ../CFSW.pro && make

# VNC port
EXPOSE 5900

# Start Xvfb with two screens, launch VNC server, and CFSW app
# CMD Xvfb :1 -screen 0 1024x768x24 -screen 1 1024x768x24 & \
#     x11vnc -display :1 -forever -nopw & \
#     ./CFSW