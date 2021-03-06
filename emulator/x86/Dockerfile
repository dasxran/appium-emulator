#======================================================================================
# Building Docker container with Appium Server based on official Android Emulator image
# Ref: Android Emulator Container Scripts
# https://github.com/google/android-emulator-container-scripts/blob/master/REGISTRY.MD
#======================================================================================
FROM us-docker.pkg.dev/android-emulator-268719/images/28-playstore-x64:30.1.2

LABEL maintainer "Ranjan Das <ranjankrdas09@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

#=============
# Set WORKDIR
#=============
WORKDIR /android/sdk

#==================
# General Packages
#------------------
# tzdata
#   Timezone
# unzip
#   Unzip zip file
# wget
#   Network downloader
# gnupg
#   Encryption software. It is needed for nodejs
# vim
#   Text Editor
#==================
RUN apt-get -qqy update && \
    apt-get -qqy --no-install-recommends install \
    tzdata \
    unzip \
    wget \
    gnupg \
    vim

#===============
# openjdk-8-jdk
#   Java
# Set JAVA_HOME
#===============
RUN mkdir -p /usr/share/man/man1 && \
    apt-get -qqy --no-install-recommends install \
    openjdk-8-jdk \
  && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre" \
    PATH=$PATH:$JAVA_HOME/bin

#=====================
# Install Android SDK
#=====================
ARG SDK_VERSION=sdk-tools-linux-3859397
ARG ANDROID_BUILD_TOOLS_VERSION=31.0.0
ARG ANDROID_PLATFORM_VERSION="android-28"

ENV SDK_VERSION=$SDK_VERSION \
    ANDROID_BUILD_TOOLS_VERSION=$ANDROID_BUILD_TOOLS_VERSION \
    ANDROID_HOME=/android/sdk

RUN wget -O tools.zip https://dl.google.com/android/repository/${SDK_VERSION}.zip && \
    unzip tools.zip && rm tools.zip && \
    chmod a+x -R $ANDROID_HOME/tools && \
    chown -R root:root $ANDROID_HOME/tools

ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin

# https://askubuntu.com/questions/885658/android-sdk-repositories-cfg-could-not-be-loaded
RUN mkdir -p ~/.android && \
    touch ~/.android/repositories.cfg && \
    echo y | sdkmanager "platform-tools" && \
    echo y | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION"
    # echo y | sdkmanager "platforms;$ANDROID_PLATFORM_VERSION"

ENV PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools

#====================================
# Install latest nodejs, npm, appium
# Using this workaround to install Appium -> https://github.com/appium/appium/issues/10020 -> Please remove this workaround asap
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
#===============
EXPOSE 4723

#====================================================
# Scripts to run appium
#====================================================
COPY launch-appium.sh \
     /android/sdk/

RUN chmod +x /android/sdk/launch-appium.sh

#========================================
# Launch emulator and appium server
#========================================
CMD /android/sdk/launch-appium.sh && /android/sdk/launch-emulator.sh
