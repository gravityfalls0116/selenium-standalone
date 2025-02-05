FROM ubuntu:latest@sha256:aba80b77e27148d99c034a987e7da3a287ed455390352663418c0f2ed40417fe
LABEL author="Vincent Voyer <vincent@zeroload.net>"
LABEL maintainer="Serban Ghita <serbanghita@gmail.com>"

ENV LC_ALL=C
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

EXPOSE 4444

RUN apt-get -qqy update
RUN apt-get -qqy install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    sudo\
    perl
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN echo "deb http://archive.ubuntu.com/ubuntu xenial main universe\n" > /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu xenial-updates main universe\n" >> /etc/apt/sources.list \
  && echo "deb http://ca.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse\n" >> /etc/apt/sources.list \
  && echo "deb http://ca.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse\n" >> /etc/apt/sources.list \
  && echo "deb http://ca.archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list \
  && echo "deb http://security.ubuntu.com/ubuntu bionic-security main restricted universe multiverse" >> /etc/apt/sources.list \
  && echo "deb-src http://ca.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse\n" >> /etc/apt/sources.list \
  && echo "deb-src http://security.ubuntu.com/ubuntu bionic-security main restricted universe multiverse\n" >> /etc/apt/sources.list \
  && echo "deb-src http://ca.archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse\n" >> /etc/apt/sources.list \
  && echo "deb-src http://ca.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse\n" >> /etc/apt/sources.list

RUN apt-get -qqy update

RUN apt install -f
RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node
RUN echo 'node ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

USER root   

RUN sudo apt-get update -y && \
    sudo apt-get -y install curl
RUN sudo add-apt-repository ppa:openjdk-r/ppa
RUN sudo apt-get update
RUN apt-get -o Dpkg::Options::="--force-overwrite" --fix-broken install
RUN dpkg --configure --force-overwrite -a

RUN sudo apt-get -qqy --no-install-recommends install \
  nodejs \
  firefox \
  google-chrome-stable \
  openjdk-11-jre-headless\
  xvfb \
  xfonts-100dpi \
  xfonts-75dpi \
  xfonts-scalable \
  xfonts-cyrillic


RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
RUN echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

RUN apt-get install -y unzip xvfb libxi6 libgconf-2-4
RUN apt-get -y update
RUN apt-get -y install git


RUN export DISPLAY=:99.0
RUN Xvfb :99 -shmem -screen 0 1366x768x16 &

WORKDIR /home/node
# For development
# ADD . ./selenium-standalone-local
# RUN chown node:node -R .

USER node

ENV NPM_CONFIG_PREFIX=/home/node/node_modules
ENV PATH=$PATH:/home/node/node_modules

#RUN npm init -y
# RUN npm install -i ./selenium-standalone-local

#RUN sudo npm install -i --unsafe-perm=true --allow-root selenium-standalone

RUN sudo npm install git+https://github.com/gravityfalls0116/selenium-standalone.git

CMD DEBUG=selenium-standalone:* sudo /home/node/node_modules/selenium-standalone/bin/selenium-standalone install && sudo /home/node/node_modules/selenium-standalone/bin/selenium-standalone start
