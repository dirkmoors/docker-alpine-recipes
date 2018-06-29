#!/usr/bin/env bash

set -ex

IMAGEQUANT_VERSION=${IMAGEQUANT_VERSION:-2.8.2}
TMP_DIR=${TMP_DIR:-/tmp/build-libimagequant}

mkdir -p ${TMP_DIR}
cd ${TMP_DIR}

# Download source package
curl -o libimagequant-${IMAGEQUANT_VERSION}.tar.gz https://s3.eu-central-1.amazonaws.com/ekona-platform-dependencies/libimagequant-${IMAGEQUANT_VERSION}.tar.gz

# Extract source package
tar -xvzf libimagequant-${IMAGEQUANT_VERSION}.tar.gz

# Remove source package
rm -rf libimagequant-${IMAGEQUANT_VERSION}.tar.gz

# Enter source directory
cd libimagequant-${IMAGEQUANT_VERSION}

# Make and install
make shared
cp libimagequant.so* /usr/lib/
cp libimagequant.h /usr/include/

# Cleanup
cd / && rm -rf ${TMP_DIR}
