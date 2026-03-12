# Omnibus Project — Overview

The Omnibus Project provides a uniform command-line environment across
Linux devices. The same shell configuration, editor settings, and SSH
client configuration are shared not only by all users on all devices,
but also between Linux distros, and from one OS release to the next
within the same distro.

## Goals
- Identical bash environment for all users on all devices
- Single source of truth — one repo, no per-device branches
- Easy to install on a new device
- Easy to keep all devices in sync

## Scope
- Covers the plain user and the superuser on each device
- Manages bash, vim, and SSH client configuration
- Does not manage SSH keys

## Devices
- Raspberry Pi 3/4/5 running raspios, based on Debian
- Raspberry Pi Zero 2 W running Octopi and PiHole
- Fedora desktop


