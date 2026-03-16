# Adding a New Device

## Before You Start
The repo must already be cloned to $DOTFILES on the new device.
If it isn't, clone it first:
```bash
git clone https://github.com/LouisB-CA/dotfiles.git $DOTFILES
chown -R 1000:1000 $DOTFILES
```

## Step 1 — Install vim
The Omnibus vimrc requires full vim. Install it before running the installer.
See `docs/05-vim.md`.

## Step 2 — Run the Installer
The installer copies the four stub files to their correct locations
for all users and sets the correct permissions.
```bash
cd "$DOTFILES/stubs"
sudo bash installer.sh
```

See `docs/07-stub-files.md` for details on what the installer does.

## Step 3 — Verify the Installation
Open a new shell and confirm the environment loaded correctly:
```bash
echo $PS1          # should show the Omnibus prompt
type ll            # should show the ll alias
echo $LESS         # should show -R --quit-if-one-screen
```

## Step 4 — Add Any Host-Specific Configuration
If this device needs configuration that other devices don't — SDK paths,
GPIO tools, project-specific variables — create a host-specific omni file:
```bash
vim "$DOTFILES/config/bash/$(hostname -s)_description.omni"
```

Test the new file in isolation before committing:
```bash
source "$DOTFILES/config/bash/$(hostname -s)_description.omni"
```

Then commit and push so the file is available on all devices
(it will be silently ignored on devices whose hostname doesn't match):
```bash
cd "$DOTFILES"
git add config/bash/$(hostname -s)_description.omni
git commit -m "Add description config for $(hostname -s)"
git push
```

See `docs/02-how-it-works.md` for how the hostname dispatcher works.

## Step 5 — Handle Any SSH Configuration
SSH keys are not managed by this project and must be transferred separately.
See `docs/06-ssh.md`.

