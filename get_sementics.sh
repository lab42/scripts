#!/usr/bin/env sh

PROJECT=semantics

TMP=$(mktemp -d)
VERSION=$(curl -s https://api.github.com/repos/lab42/${PROJECT}/releases/latest | grep "tag_name" | sed -E 's/.*"v([^"]+)".*/\1/')
OS=$(uname | tr '[:lower:]' '[:upper:]')
ARCH=$(uname -m)

case $ARCH in
  armv5*) ARCH="armv5" ;;
  armv6*) ARCH="armv6" ;;
  armv7*) ARCH="arm" ;;
  aarch64) ARCH="arm64" ;;
  x86) ARCH="386" ;;
  x86_64) ARCH="amd64" ;;
  i686) ARCH="386" ;;
  i386) ARCH="386" ;;
esac

if curl --head --silent --fail https://github.com/lab42/${PROJECT}/releases/download/v${VERSION}/${PROJECT}_${VERSION}_${OS}_${ARCH}.tar.gz 1>/dev/null; then
    echo "Found ${PROJECT}:v${VERSION}"
    echo "OS: ${OS}"
    echo "Arch: ${ARCH}"
else
    echo "Can't find ${PROJECT}"
    echo "OS: ${OS}"
    echo "Arch: ${ARCH}"
    exit 1
fi

curl -fsSLo $TMP/${PROJECT}.tar.gz https://github.com/lab42/${PROJECT}/releases/download/v${VERSION}/${PROJECT}_${VERSION}_${OS}_${ARCH}.tar.gz
tar -xf $TMP/${PROJECT}.tar.gz -C /usr/local/bin ${PROJECT}
rm -rf $TMP
