FROM ubuntu:22.04@sha256:104ae83764a5119017b8e8d6218fa0832b09df65aae7d5a6de29a85d813da2fb

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
