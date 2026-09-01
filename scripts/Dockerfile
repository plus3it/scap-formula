FROM ubuntu:24.04@sha256:33ceb71981b602c1a7443a53469e4dba065f7503eab3078a2d7a57a2ab987517

ARG TMPDIR=/tmp
ARG DEBIAN_FRONTEND=noninteractive
ARG SSG_VER

ENV TZ=Etc/UTC

# Install required build tools
RUN apt-get update -y && apt-get install -y \
    git \
    cmake \
    curl \
    make \
    openscap-common \
    openscap-scanner \
    openscap-utils \
    libopenscap25t64 \
    libxml2-utils \
    ninja-build \
    python3 \
    python3-jinja2 \
    python3-yaml \
    python3-setuptools \
    expat \
    xsltproc

COPY --chmod=0755 scripts/build_ssg_content.sh ${WORKDIR}

RUN /bin/bash -c "${WORKDIR}/build_ssg_content.sh"
