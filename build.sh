#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if ! command -v lb >/dev/null 2>&1; then
  echo "live-build is not installed. See README.md for the required packages." >&2
  exit 1
fi

mkdir -p downloads dist config/includes.chroot/opt/gameros/vendor
rm -f config/packages.chroot/*.deb
chmod +x config/hooks/*.chroot* 2>/dev/null || true
chmod +x config/includes.chroot/usr/local/sbin/gameros-driver-setup 2>/dev/null || true

heroic_url="$(curl -fsSL https://api.github.com/repos/Heroic-Games-Launcher/HeroicGamesLauncher/releases/latest \
  | sed -nE 's/.*"browser_download_url": "([^"]*amd64[^\"]*\.deb)".*/\1/p' \
  | head -n1)"

if [[ -z "$heroic_url" ]]; then
  echo "Could not find the current Heroic Games Launcher amd64 package." >&2
  exit 1
fi

curl -fL --retry 3 "$heroic_url" -o downloads/heroic.deb
curl -fL --retry 3 "https://discord.com/api/download?platform=linux&format=deb" -o downloads/discord.deb

for package in downloads/heroic.deb downloads/discord.deb; do
  dpkg-deb --info "$package" >/dev/null
  case "$package" in
    downloads/heroic.deb) cp -f "$package" config/includes.chroot/opt/gameros/vendor/heroic_amd64.deb ;;
    downloads/discord.deb) cp -f "$package" config/includes.chroot/opt/gameros/vendor/discord_amd64.deb ;;
  esac
done

sha256sum downloads/*.deb > downloads/SHA256SUMS

sudo lb clean --purge || true

lb config \
  --mode ubuntu \
  --distribution noble \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --archive-areas "main restricted universe multiverse" \
  --debian-installer false \
  --bootappend-live "boot=casper quiet splash" \
  --linux-packages "linux-image linux-headers" \
  --apt-indices false \
  --build-with-chroot false \
  --apt-recommends true \
  --memtest none \
  --iso-application "GamerOS" \
  --iso-publisher "GamerOS Project" \
  --iso-volume "GAMEROS_01" \
  --bootloader grub2 \
  --firmware-binary false \
  --firmware-chroot false \
  --hdd-label GAMEROS

rm -rf dist/*
sudo lb build 2>&1 | tee build.log

iso_file="$(find . -maxdepth 1 -type f -name '*.iso' -print -quit)"
if [[ -z "$iso_file" ]]; then
  echo "The build finished without producing an ISO image." >&2
  exit 1
fi

cp "$iso_file" "dist/GamerOS-0.1-amd64.iso"
sha256sum "dist/GamerOS-0.1-amd64.iso" | tee "dist/GamerOS-0.1-amd64.iso.sha256"
sudo chown -R "$(id -u):$(id -g)" dist downloads config/packages.chroot build.log

echo
echo "Build complete: dist/GamerOS-0.1-amd64.iso"
