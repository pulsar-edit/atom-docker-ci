FROM ubuntu:18.04

LABEL maintainer="David Wilson <daviwil@github.com>"
LABEL description="An image to run Atom CI and release builds on Linux"

ENV LANG="C.UTF-8" DISPLAY=":99"

# Add the atom user as a sudo-enabled account
RUN useradd --create-home --home-dir "/home/atom" --user-group --groups sudo atom

# Enable passwordless sudo for users under the "sudo" group
RUN mkdir --parents /etc/sudoers.d
RUN echo "%sudo ALL=NOPASSWD:ALL" > /etc/sudoers.d/sudo-no-passwd
RUN chmod 0440 /etc/sudoers.d/sudo-no-passwd
WORKDIR "/home/atom"

# Add Xvfb and have it start at boot
COPY xvfb_start.sh /usr/local/bin/xvfb_start
RUN chmod 0655 /usr/local/bin/xvfb_start
ENTRYPOINT ["/usr/local/bin/xvfb_start"]

# Install dependencies
RUN apt-get update && \
    apt-get install --assume-yes --quiet \
                    --no-install-suggests --no-install-recommends \
      git \
      ssh \
      tar \
      gzip \
      gnupg \
      rpm \
      ca-certificates \
      \
      build-essential \
      fakeroot \
      libsecret-1-dev \
      \
      xvfb \
      libxss1 \
      libasound2 \
      libgtk-3-0 \
      libx11-dev \
      libxkbfile-dev \
      xz-utils \
      xorriso \
      zsync \
      libxss1 \
      libgconf2-4 \
      libxtst6 \
      \
      sudo \
      curl \
      && \
    \
    apt-get clean && \
    rm --recursive --force /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN sudo apt-get install -y nodejs && npm install --global npm@6.2.0
