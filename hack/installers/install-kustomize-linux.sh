#!/bin/bash
set -eux -o pipefail

KUSTOMIZE_VERSION=${KUSTOMIZE_VERSION:-3.6.1}

# Note that kustomize release URIs have changed for v3.2.1. Then again for
# v3.3.0. When upgrading to versions >= v3.3.0 please change the URI format. And
# also note that as of version v3.3.0, assets are in .tar.gz form.
# v3.2.0 = https://github.com/kubernetes-sigs/kustomize/releases/download/v3.2.0/kustomize_3.2.0_linux_amd64
# v3.2.1 = https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v3.2.1/kustomize_kustomize.v3.2.1_linux_amd64
# v3.3.0 = https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v3.3.0/kustomize_v3.3.0_linux_amd64.tar.gz
case $KUSTOMIZE_VERSION in
  2.*)
    DL=$DOWNLOADS/kustomize-${KUSTOMIZE_VERSION}
    URL=https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64
    BINNAME=kustomize2
    [ -e $DL ] || curl -sLf --retry 3 -o $DL $URL
    mv $DL $BIN/$BINNAME
    ;;
  *)
    DL=$DOWNLOADS/kustomize-${KUSTOMIZE_VERSION}.tar.gz
    URL=https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz
    BINNAME=kustomize

    [ -e $DL ] || curl -sLf --retry 3 -o $DL $URL
    tar -C /tmp -xf $DL
    mv /tmp/kustomize $BIN/$BINNAME
    ;;
esac


chmod +x $BIN/$BINNAME
$BINNAME version
