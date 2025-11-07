# Base Ubuntu com ferramentas essenciais
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# Instalar dependências básicas e ferramentas de build
RUN apt update && apt install -y \
    curl git unzip xz-utils zip libglu1-mesa \
    clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev \
    openjdk-17-jdk wget \
    && apt clean

# Instalar Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Pré-baixar binários e verificar instalação
RUN flutter doctor -v && flutter precache

# Instalar Android SDK (Command-line tools)
RUN mkdir -p /usr/local/android-sdk/cmdline-tools && \
    cd /usr/local/android-sdk/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip commandlinetools-linux-11076708_latest.zip && \
    mv cmdline-tools latest

# Variáveis de ambiente do Android SDK
ENV ANDROID_SDK_ROOT=/usr/local/android-sdk
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

# Instalar SDK Tools básicos
RUN yes | sdkmanager --licenses || true && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Instalar cliente MQTT (paho-mqtt para Dart)
RUN flutter pub global activate mqtt_client

# Instalar dependências e o Google Chrome
RUN apt-get update && apt-get install -y wget gnupg2 curl unzip xz-utils \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*


# Definir diretório de trabalho padrão
WORKDIR /app

# Comando padrão
CMD ["/bin/bash"]
