#======================================================================================
# Building Docker container with Appium Server based on official Android Emulator image
# Ref: Android Emulator Container Scripts
# https://github.com/google/android-emulator-container-scripts/blob/master/REGISTRY.MD
#======================================================================================

# ====================================================================== #
# Android SDK Docker Image with Appium Server & Emulator (Virtual Device)
# ====================================================================== #

# Base image
FROM openjdk:8-jdk-slim

LABEL maintainer="Ranjan Das <ranjankrdas09@gmail.com>" \
      SystemImage.Abi="armeabi-v7a" \
      SystemImage.TagId="google_apis" \
      AndroidVersion.ApiLevel="25"

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /android/sdk/avd

#=============
# Set WORKDIR
#=============
ENV ANDROID_HOME=/android/sdk \
    ANDROID_AVD_HOME=/android/sdk/avd \
    ANDROID_SDK_ROOT=/android/sdk

WORKDIR $ANDROID_HOME

# support multiarch: i386 architecture
# install essential tools
# install Qt

#==================
# General Packages
#==================
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates tzdata unzip curl wget socat xvfb gnupg vim \
    qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#=====================
# Install Android SDK
#=====================
ARG SDK_VERSION=commandlinetools-linux-6609375_latest
ARG ANDROID_BUILD_TOOLS_VERSION=31.0.0
ARG ANDROID_PLATFORM_VERSION="android-25"

RUN wget -O tools.zip https://dl.google.com/android/repository/${SDK_VERSION}.zip && \
    unzip tools.zip && rm tools.zip && \
    mkdir cmdline-tools && \
    mv tools cmdline-tools && \
    chmod a+x -R $ANDROID_HOME/cmdline-tools/tools && \
    chown -R root:root $ANDROID_HOME/cmdline-tools/tools

ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/tools/bin    

# https://askubuntu.com/questions/885658/android-sdk-repositories-cfg-could-not-be-loaded
RUN touch $ANDROID_HOME/avd/repositories.cfg && \
    yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "emulator" && \
    sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" && \
    sdkmanager "platforms;$ANDROID_PLATFORM_VERSION" && \
    sdkmanager "system-images;$ANDROID_PLATFORM_VERSION;google_apis;armeabi-v7a"

ENV PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator

#====================================
# Install latest nodejs, npm, appium
#====================================
ARG APPIUM_VERSION=1.22.0
ENV APPIUM_VERSION=$APPIUM_VERSION

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash && \
    apt-get -qqy --no-install-recommends install nodejs && \
    npm install -g appium@${APPIUM_VERSION} --unsafe-perm=true --allow-root && \
    exit 0 && \
    npm cache clean && \
    apt-get remove --purge -y npm && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get clean

#==================================
# Fix Issue with timezone mismatch
#==================================
ENV TZ="US/Pacific"
RUN echo "${TZ}" > /etc/timezone

#===============
# Expose Ports
#---------------
# 4723
#   Appium port
# 5555
#   ADB port
#===============
EXPOSE 4723
EXPOSE 5555

#====================================================
# Scripts to run appium
#====================================================
COPY launch-appium.sh \
     launch-emulator.sh \
     $ANDROID_HOME/

RUN chmod +x $ANDROID_HOME/launch-appium.sh && \
    chmod +x $ANDROID_HOME/launch-emulator.sh

#====================================================
# Copy armeabi-v7a config
#====================================================
COPY avd \
     $ANDROID_AVD_HOME/

#========================================
# Launch emulator and appium server
#========================================
CMD $ANDROID_HOME/launch-appium.sh && $ANDROID_HOME/launch-emulator.sh
