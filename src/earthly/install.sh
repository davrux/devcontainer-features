#!/bin/sh
set -e

# Checks if packages are installed and installs them if not.
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            echo "Running apt-get update..."
            apt-get update -y
        fi
        apt-get -y install --no-install-recommends "$@"
    fi
}

echo "(*) Installing EARTHLY..."

check_packages curl ca-certificates jq

VERSION=${VERSION:-"latest"}
echo "Requested version: $VERSION"

if [ "${VERSION}" != "latest" ]; then
    versionStr=-${VERSION}
else
    versionStr=$(curl https://api.github.com/repos/earthly/earthly/releases/latest | jq -r '.tag_name')
fi

archTxt="arm64"
arch=$(uname -i)
if [ "${arch}" = "amd64" ] || [ "${arch}" = "x86_64" ] || [ ${arch} = "unknown" ] ; then
    archTxt="amd64"
fi

DOWNLOAD_URL=https://github.com/earthly/earthly/releases/download/${versionStr}/earthly-$(uname -s | tr '[:upper:]' '[:lower:]')-${archTxt}
echo "Installing version: ${versionStr}"
echo "Download URL: ${DOWNLOAD_URL}"
echo "Uname: ${arch}"

BIN="/usr/local/bin"
curl -sSL ${DOWNLOAD_URL} -o "${BIN}/earthly" || exit 1

chmod +x "${BIN}/earthly"

echo "Done"
