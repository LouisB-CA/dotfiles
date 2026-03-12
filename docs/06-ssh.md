# SSH Configuration

## What the Omnibus Project Manages
- `ssh/config` — the SSH client configuration file, installed at `~/.ssh/config`
- This file is the same for all plain users on all devices
- The superuser does not get an SSH config file

## What the Omnibus Project Does NOT Manage
- SSH keys — these must never be put in a git repository
- `known_hosts` — this is machine-specific
- `authorized_keys` — this is machine-specific

## Sharing SSH Keys Across Devices
The same key identity can be used on every device, but keys must be
transferred via rsync, not git:
```bash
rsync -av --chmod=F600,D700 ~/.ssh/id_ed25519 pi@otherdevice:~/.ssh/
```

## See Also
`ssh/README.md` — warnings about what should and should not be stored here.


