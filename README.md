# GamerOS

GamerOS is a gaming-focused Linux desktop built on Ubuntu 24.04 LTS. It ships with KDE Plasma, a Wayland session, broad hardware support, and the tools needed to run native Linux games and Windows games through Proton or Wine.

The project is intentionally based on existing upstream software rather than replacing it. Ubuntu provides the base system and hardware enablement, KDE Plasma provides the desktop, and the Linux graphics stack provides the kernel drivers, Mesa, Vulkan, and firmware support.

## Included software

The default image includes Steam, Lutris, Heroic Games Launcher, Discord, Wine, Winetricks, Protontricks, GameMode, MangoHud, GOverlay, OBS Studio, Vulkan tools, PipeWire, Bluetooth support, and common storage utilities.

KDE Plasma is used as the default desktop. The live session starts with Wayland when the hardware supports it. An X11 session remains available for older systems, legacy applications, and hardware that needs it.

## Hardware support

GamerOS includes the Ubuntu HWE kernel, Linux firmware, AMD and Intel microcode, Mesa OpenGL and Vulkan drivers, X.Org compatibility drivers, NetworkManager, Bluetooth support, PipeWire, and firmware update support. The installed system also runs Ubuntu's driver detection tool on its first boot and offers the recommended proprietary driver when one is available for the detected hardware.

No Linux distribution can guarantee support for every device. NVIDIA hardware, hybrid laptops, unusual Wi-Fi adapters, and very recent hardware may still require a newer driver or an X11 fallback. The image is designed to install the available drivers automatically through Ubuntu's driver tooling and to keep the common open-source graphics stack ready out of the box.

## Building the image

The build is intended for an Ubuntu 24.04 host with root access. Building on another distribution may work, but it is not part of the supported workflow.

Install the required tools:

```bash
sudo apt update
sudo apt install -y live-build debootstrap genisoimage syslinux-utils \
  squashfs-tools grub-pc-bin grub-efi-amd64-bin mtools \
  qemu-system-x86 qemu-utils
```

Clone the repository and build the image:

```bash
git clone https://github.com/Igu2012/distro-gamer.git
cd distro-gamer
./build.sh
```

The build script downloads the current Linux packages published by Heroic Games Launcher and Discord, configures the live-build tree, builds an amd64 hybrid ISO, writes a SHA-256 checksum, and places the result in `dist/`.

The build requires several gigabytes of free disk space and a reliable network connection. The final image is expected to be large because it contains a complete KDE desktop, firmware, graphics drivers, 32-bit libraries, Wine, and game launchers.

## Testing in a virtual machine

A quick smoke test can be run with QEMU after the build completes:

```bash
qemu-system-x86_64 \
  -enable-kvm \
  -m 4096 \
  -smp 4 \
  -cdrom dist/GamerOS-0.1-amd64.iso \
  -boot d
```

A virtual machine is useful for checking boot, the live session, package installation, networking, audio, and the installer. It cannot validate real GPU acceleration, Wi-Fi, Bluetooth, suspend, external displays, or proprietary NVIDIA behavior. Those require testing on physical hardware.

## Project status

GamerOS is an early-stage project. The first releases are intended for testing and feedback. Before using the system as a primary installation, verify the image checksum and keep a current backup of important data.

## Licensing

The build scripts and project configuration are released under the MIT License. The ISO also contains software from Ubuntu, KDE, Linux, Mesa, Wine, and other upstream projects, each under its own license. Steam, Discord, and other proprietary applications are distributed under their respective terms and are not relicensed by this project.

## Contributing

Issues and pull requests are welcome. Useful contributions include hardware testing, installer reports, package fixes, KDE and Wayland configuration improvements, documentation, and reproducible build fixes.
