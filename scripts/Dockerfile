FROM ubuntu:22.04@sha256:58b87898e82351c6cf9cf5b9f3c20257bb9e2dcf33af051e12ce532d7f94e3fe

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

RUN /bin/bash -c "${WORKDIR}/build_ssg_content.sh"
