FROM ubuntu:latest@sha256:f9d633ff6640178c2d0525017174a688e2c1aef28f0a0130b26bd5554491f0da

ARG TMPDIR=/tmp
ARG DEBIAN_FRONTEND=noninteractive
ARG SSG_VER

ENV TZ=Etc/UTC

# Install required build tools
RUN apt-get update -y && apt-get install -y \
    git \
    cmake \
    make \
    libopenscap8 \
    libxml2-utils \
    ninja-build \
    python3 \
    python3-jinja2 \
    python3-yaml \
    python3-setuptools \
    expat \
    xsltproc

COPY --chmod=0755 scripts/build_ssg_content.sh ${WORKDIR}

SHELL ["/bin/bash", "-c"]

RUN ${WORKDIR}/build_ssg_content.sh
