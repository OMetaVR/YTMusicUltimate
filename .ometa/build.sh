#!/usr/bin/env bash
# Upstream's main.yml (sideloading build injected with cyan), plus the jailbreak .debs
# upstream attaches to its releases.
source "$PIPELINE/lib/helpers.sh"
setup_theos 16.5
install_cyan

VERSION=$(sed -nE 's/^PACKAGE_VERSION = (.+)/\1/p' Makefile | head -1)

log "Rootful .deb";  make clean package FINALPACKAGE=1
log "Rootless .deb"; make clean package FINALPACKAGE=1 ROOTLESS=1
log "Roothide .deb"; make clean package FINALPACKAGE=1 ROOTHIDE=1 || log "roothide build failed; skipping it"
cp packages/*.deb "$OUT/"

log "Sideloading IPA (YouTube Music $BASE_VERSION)"
rm -rf packages
make clean package DEBUG=0 FINALPACKAGE=1 SIDELOADING=1
cyan -i "$BASE_IPA" -o "$OUT/YTMusicUltimate_${BASE_VERSION}_v$VERSION.ipa" -uwsf packages/*.deb
