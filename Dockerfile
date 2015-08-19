FROM sanji/jenkins-swarm-slave

MAINTAINER Zack YL Shih <zackyl.shih@moxa.com>

USER root

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    libstdc++6:i386 \
    libgcc1:i386 \
    zlib1g:i386 \
    build-essential \
    ruby-dev \
    libicu-dev \
    libssl-dev \
    libpng-dev \
    libreadline-dev \
    debhelper \
    fakeroot \
    git \
    qemu-user \
    curl && \
    rm -rf /var/lib/apt/lists/* # 20150209

ADD assets/ /app/

RUN chmod 755 /app/setup/*

# Replace sh(dash) to bash
RUN bash -c "rm /bin/sh && ln -s /bin/bash /bin/sh"

# Install slackpost
RUN ln -s /app/bin/slackpost /bin/slackpost

RUN adduser jenkins-slave sudo

RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER jenkins-slave

# Install ruby and node with external script
RUN bash -c "/app/setup/ruby"

RUN bash -c "/app/setup/node"

RUN bash -c "/app/setup/python"
