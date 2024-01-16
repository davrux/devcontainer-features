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

echo "(*) Installing BUF..."

export DEBIAN_FRONTEND=noninteractive
check_packages curl ca-certificates jq

VERSION=${VERSION:-"latest"}
echo "Requested version: $VERSION"

if [ "${VERSION}" != "latest" ]; then
    versionStr=${VERSION}
else
    versionStr=$(curl https://api.github.com/repos/bufbuild/buf/releases/latest | jq -r '.tag_name')
fi


echo "Installing version: $versionStr"

BIN="/usr/local/bin" 
curl -sSL \
"https://github.com/bufbuild/buf/releases/download/${versionStr}/buf-$(uname -s)-$(uname -m)" \
-o "${BIN}/buf" || exit 1

chmod +x "${BIN}/buf"

echo "Done"
