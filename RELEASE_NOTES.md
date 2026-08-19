## GamerOS 0.1.0

This is the first public preview of GamerOS, a gaming-focused Ubuntu 24.04 LTS desktop with KDE Plasma and a Wayland session.

### Included

- KDE Plasma desktop with Wayland enabled by default when supported
- Ubuntu HWE kernel, Linux firmware, AMD and Intel microcode
- Mesa OpenGL and Vulkan support, 32-bit graphics libraries, and Wine
- Steam, Lutris, Heroic Games Launcher, Discord, Winetricks, Protontricks, GameMode, MangoHud, GOverlay, OBS Studio, and Vulkan tools
- Ubiquity installer and an X11 session for compatibility
- First-boot driver detection through Ubuntu's driver tooling

### Important notes

This is an early testing release. It has been smoke-tested in QEMU, but real hardware testing is still required. NVIDIA GPUs, hybrid laptops, unusual wireless adapters, suspend, external displays, Secure Boot, and proprietary firmware can behave differently across machines. Keep a backup of important data before installing.

The ISO contains third-party proprietary applications. Their original licenses and terms remain in effect. The GamerOS build scripts and configuration are released under the MIT License.

Verify the SHA-256 checksum before writing the image to a USB drive.

### SHA-256

See `GamerOS-0.1-amd64.iso.sha256` for the checksum of the release image.

## Build source

The complete build configuration is available at https://github.com/Igu2012/distro-gamer.
