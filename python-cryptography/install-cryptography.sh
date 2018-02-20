#!/usr/bin/env bash

set -e

CRYPTOGRAPHY_VERSION=${CRYPTOGRAPHY_VERSION:-2.1.4}
OPENSSL_VERSION=${OPENSSL_VERSION:-1.1.0g}
OPENSSL_GPG_KEY=${OPENSSL_GPG_KEY:-8657ABB260F056B1E5190839D9C4D26D0E604491}
TMP_DIR=${TMP_DIR:-/tmp/build-cryptography}

BUILD_PKGS=" \
    gcc \
    g++ \
    perl \
    libffi-dev \
    gnupg"

apk add --update ${BUILD_PKGS}

mkdir -p ${TMP_DIR}
cd ${TMP_DIR}

wget -O openssl.tar.gz -q https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz

echo "Verifying openssl-${OPENSSL_VERSION}.tar.gz using GPG..."
wget -O openssl.tar.gz.asc -q https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz.asc
GNUPGHOME="$(mktemp -d)"
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "${OPENSSL_GPG_KEY}"
gpg --batch --verify openssl.tar.gz.asc openssl.tar.gz
rm -r "${GNUPGHOME}" openssl.tar.gz.asc

CWD=$(pwd)
tar xvf openssl.tar.gz
rm openssl.tar.gz
cd openssl-${OPENSSL_VERSION}
./config no-shared no-ssl2 no-ssl3 no-async -fPIC --prefix=${CWD}/openssl
make && make install

cd ..
CFLAGS="-I${CWD}/openssl/include" LDFLAGS="-L${CWD}/openssl/lib" pip wheel --no-use-wheel cryptography==${CRYPTOGRAPHY_VERSION}
pip install *.whl

apk del --purge ${BUILD_PKGS}
rm -rf /tmp/*
