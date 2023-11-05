# base
FROM ubuntu:22.04

# set the github runner version
ARG RUNNER_VERSION="2.309.0"
ARG DOCKER_GROUP
ENV DOCKER_GROUP=$DOCKER_GROUP

# update the base packages and add a non-sudo user
RUN groupadd -g ${DOCKER_GROUP} docker && apt-get update -y --fix-missing && apt-get upgrade -y && useradd -mg ${DOCKER_GROUP} docker


ARG LIBS="curl\
    jq\
    build-essential\
    libssl-dev\
    libffi-dev\
    python3\
    python3-venv\
    python3-dev\
    python3-pip\
    tzdata\
    ssh\
    ca-certificates\
    gnupg\
    kmod\
    uidmap\
    autoconf\
    automake\
    dbus\
    dnsutils\
    dpkg\
    dpkg-dev\
    fakeroot\
    fonts-noto-color-emoji\
    gnupg2\
    imagemagick\
    iproute2\
    iputils-ping\
    lib32z1\
    libcurl4\
    libgbm-dev\
    libgconf-2-4\
    libgsl-dev\
    libmagic-dev\
    libmagickcore-dev\
    libmagickwand-dev\
    libsecret-1-dev\
    libsqlite3-dev\
    libyaml-dev\
    libtool\
    libunwind8\
    libxkbfile-dev\
    libxss1\
    locales\
    mercurial\
    openssh-client\
    p7zip-rar\
    pkg-config\
    python-is-python3\
    rpm\
    texinfo\
    tk\
    upx\
    xorriso\
    xvfb\
    xz-utils\
    zsync\
    bzip2\
    g++\
    gcc\
    make\
    tar\
    unzip\
    wget\
    acl\
    aria2\
    binutils\
    bison\
    brotli\
    coreutils\
    file\
    flex\
    ftp\
    haveged\
    lz4\
    m4\
    mediainfo\
    netcat\
    net-tools\
    p7zip-full\
    parallel\
    pass\
    patchelf\
    pigz\
    pollinate\
    rsync\
    shellcheck\
    sphinxsearch\
    sqlite3\
    sshpass\
    subversion\
    sudo\
    swig\
    telnet\
    time\
    zip\
		openjdk-17-jre-headless"



RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --fix-missing ${LIBS} &&\
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&\
    chmod a+r /etc/apt/keyrings/docker.gpg
# *  Setup docker
RUN echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null &&\
    usermod -aG docker docker 


RUN apt-get update -y &&\
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &&\
    rm -rf /var/lib/apt/lists/*
# cd into the user directory, download and unzip the github actions runner
WORKDIR /home/docker

RUN mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# install some additional dependencies
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# copy over the start.sh script
COPY start.sh start.sh

RUN apt-get autoremove --purge
# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker


# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
