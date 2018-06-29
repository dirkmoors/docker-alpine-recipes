#!/usr/bin/env bash

set -ex

WEBP_VERSION=${WEBP_VERSION:-2.8.2}
TMP_DIR=${TMP_DIR:-/tmp/build-libwebp}

mkdir -p ${TMP_DIR}
cd ${TMP_DIR}

# Download source package
curl -o libwebp-${WEBP_VERSION}.tar.gz https://s3.eu-central-1.amazonaws.com/ekona-platform-dependencies/libwebp-${WEBP_VERSION}.tar.gz

# Extract source package
tar -xvzf libwebp-${WEBP_VERSION}.tar.gz

# Remove source package
rm -rf libwebp-${WEBP_VERSION}.tar.gz

# Enter source directory
cd libwebp-${WEBP_VERSION}

# Make and install
./configure --prefix=/usr --enable-libwebpmux --enable-libwebpdemux
make -j4
make -j4 install

# Cleanup
cd / && rm -rf ${TMP_DIR}
