# python-cryptography
Script to install the "cryptography" Python package, statically linked to a given OpenSSL version

Example:
```
FROM python:3.5.4-alpine

# Install ca-certificates & run update
RUN set -v \
    && apk add --update ca-certificates \
    && update-ca-certificates

# Override versions if needed
ENV CRYPTOGRAPHY_VERSION=2.1.4 \
    OPENSSL_VERSION=1.1.0g \
    OPENSSL_GPG_KEY=8657ABB260F056B1E5190839D9C4D26D0E604491

# Install required packages, then download and run install script. Afterwards, cleanup.
RUN set -v \
    && BUILD_PKGS='gcc g++ linux-headers make perl libffi-dev gnupg wget' \
    && apk add --update ${BUILD_PKGS} \
    && wget -q https://raw.githubusercontent.com/dirkmoors/docker-alpine-recipes/master/python-cryptography/install-cryptography.sh \
    && sh install-cryptography.sh \
    && rm -rf install-cryptography.sh \
    && apk del --purge ${BUILD_PKGS}

```
