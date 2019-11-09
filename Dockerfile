# Container for running DeepProverbs models on the CPU
# This Docker container does not support GPU the purpose
# is to allow people to quickly play with the model and code

FROM ubuntu:18.04

RUN apt-get update

# Set an environment variable to avoid dialogs on install
ARG DEBIAN_FRONTEND=noninteractive

# Install General libraries
RUN apt -y update && apt -y install ffmpeg \
    git \
    pkg-config

# Install Bazel
RUN apt-get update && apt-get install -y \
    zip \
    g++ \
    zlib1g-dev \
    unzip \
    python3 \
    curl \
    openjdk-11-jdk

RUN echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
RUN apt-get update && apt-get install -y bazel
RUN apt-get install --only-upgrade bazel

## Install libraries necessary for python
RUN apt-get update && apt-get install -y \
    automake \
    autoconf \
    wget \
    libhdf5-dev \
    software-properties-common \
    postgresql \
    postgresql-client \
    postgresql-client-common \
    libpq-dev \
    libenchant1c2a \
    libfreetype6-dev \
    libzmq3-dev \
    graphviz


# Install Python and necessary libraries
RUN apt-get -y update && apt-get -y install \
    python3-pip \
    python3-dev \
    python3-setuptools

# Add the repos to the docker file and make it the working directory
ADD dev/docker/requirements.txt /req/

# Install Python Libraries
RUN pip3 install -r /req/requirements.txt

# Install Flake8 utility for linting python code
RUN pip3 install black

CMD /bin/bash
