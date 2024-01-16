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
    versionStr=$(curl https://api.github.com/repos/fullstorydev/grpcui/releases/latest | jq -r '.tag_name')
fi

versionStr=`echo $versionStr | sed -e 's/^v//'`

echo "Installing version: $versionStr"


BIN="/usr/local/bin" 
curl -sSL \
    "https://github.com/fullstorydev/grpcui/releases/download/v${versionStr}/grpcui_${versionStr}_$(uname -s)_$(uname -m).tar.gz" \
    -o "/tmp/grpcui.tar.gz" || exit 1

cd /tmp
ls -ltrah grpcui.tar.gz
tar xzf grpcui.tar.gz
mv grpcui "${BIN}/grpcui"
rm -rf /tmp/grpcui*

chmod +x "${BIN}/grpcui"

echo "Done"
