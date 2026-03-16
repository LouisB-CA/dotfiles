# Upgrading an OS

When a device gets a fresh OS image, the Omnibus Project needs to be
reinstalled. This is straightforward since all configuration lives in
the repo, not in the home directory.

## Step 1 — Install git and vim
```bash
sudo apt install git vim -y       # Debian/Trixie
sudo dnf install git vim -y       # Fedora
```

## Step 2 -  Choose a Project Folder
```bash
DOTFILES=/opt/dotfiles
```

## Step 3 — Clone the Repo
```bash
git clone https://github.com/LouisB-CA/dotfiles.git "${DOTFILES}"
sudo chown -R 1000:1000 "${DOTFILES}"
```

## Step 4 — Run the Installer
```bash
cd "${DOTFILES}/stubs"
sudo installer.sh
```

## Step 5 — Restore SSH Keys
SSH keys are not in the repo and must be restored separately.
See `docs/06-ssh.md`.

## Step 6 — Restore Host-Specific Configuration
If this device has host-specific omni files, they are already in the repo
and will be active immediately after cloning. No extra steps needed.

