FROM ubuntu:20.04

# Update the packages
RUN apt update && apt install -y
RUN apt upgrade -y

# Install Dependencies
RUN apt install wget -y
RUN apt install unzip -y
RUN apt install default-jdk -y
RUN apt install git -y 
RUN apt-get install curl -y

# Set up working directory
RUN mkdir -p /home/developer
WORKDIR /home/developer

# Set up Flutter
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"
RUN flutter precache

# Prepare Android directories and system variables
RUN mkdir -p Android/sdk/cmdline-tools/tools
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
RUN wget -O android_sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip
RUN unzip android_sdk.zip && rm android_sdk.zip
RUN mv -v cmdline-tools/* Android/sdk/cmdline-tools/tools/ && rm -rf cmdline-tools
RUN cd Android/sdk/cmdline-tools/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/cmdline-tools/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
#ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"