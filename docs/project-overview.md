# ~/.config/bash — Modular Bash Configuration

A modular, git-managed bash configuration for a fleet of Raspberry Pi devices.
All files in this repository are identical on every Pi. Machine-specific
configuration is self-selecting based on hostname — no per-machine branches
or manual switching required.

---

## How It Works

`~/.bashrc` sources every file in this directory that matches `[0-9][0-9]*.sh`,
in lexical order. That's the only rule. Everything else follows from it.

```
~/.bashrc
    └── sources [0-9][0-9]*.sh in lexical order
            ├── 00-path.sh          global PATH
            ├── 10-environment.sh   global env vars
            ├── 20-aliases.sh       aliases
            ├── 30-functions.sh     shell functions
            ├── 40-prompt.sh        PS1 prompt
            └── 50-local.sh         hostname dispatcher
                    └── sources <hostname>_*.sh for the current machine only
```

Files without a two-digit prefix are **never** auto-sourced. This is what
keeps hostname-specific files (and anything else you drop here) inert on
machines they don't belong to.

---

## File Index

| File | Sourced on | Purpose |
|------|-----------|---------|
| `00-path.sh` | all Pis | Global PATH additions |
| `10-environment.sh` | all Pis | EDITOR, PAGER, HISTSIZE, etc. |
| `20-aliases.sh` | all Pis | Shell aliases |
| `30-functions.sh` | all Pis | Shell functions |
| `40-prompt.sh` | all Pis | PS1 prompt (includes hostname) |
| `50-local.sh` | all Pis | Dispatches hostname-specific files |
| `<hostname>_*.sh` | one Pi | Machine-specific config (see below) |

---

## Machine-Specific Files

Any file named `<hostname>_<description>.sh` is sourced automatically on
the matching machine and silently ignored everywhere else. The hostname
is matched using `hostname -s` (short name, no domain suffix).

Current host-specific files in this repo:

| File | Machine | Purpose |
|------|---------|---------|
| *(add rows here as you create them)* | | |

### Adding config for a new machine or tool

1. Create the file:
   ```bash
   vim ~/.config/bash/$(hostname -s)_utils.sh
   ```
2. Test it in isolation:
   ```bash
   source ~/.config/bash/$(hostname -s)_utils.sh
   ```
3. Commit and push:
   ```bash
   git add $(hostname -s)_utils.sh
   git commit -m "Add utils config for $(hostname -s)"
   git push
   ```
4. Pull on the other Pis — the file arrives but does nothing on them.

No edits to `50-local.sh` or `.bashrc` are ever needed.

---

## Handling Installer Additions to `.bashrc`

Installers (pip, SDK scripts, language version managers, etc.) append
blocks to `~/.bashrc` without asking. The workflow to clean them up:

1. Spot the addition — either review `~/.bashrc` after installation or, if
   `.bashrc` is tracked, run `git diff ~/.bashrc`
2. Create a host-specific file and move the installer's lines into it
3. Test the new file: `source ~/.config/bash/$(hostname -s)_newtool.sh`
4. Delete the installer's block from `.bashrc`
5. Commit the new file to this repo

This keeps installer debris off every Pi except the one that needs it.

---

## Keeping All Pis in Sync

### Via git (recommended)

```bash
# Push changes from whichever Pi you edited on
cd ~/.config/bash && git push

# Pull on every other Pi
cd ~/.config/bash && git pull
```

### Via rsync (if not using a remote)

```bash
# To pull the project files from the authoritative source,
# assuming owner has UID 1000 on both source and destination,
# do this as root on the destination :

PROJECT_SRC=owner@192.168.12.xxx:/opt/project/
rsync -av --numeric-ids --chown=1000:1000 "$PROJECT_SRC" /opt/dotfiles/ \
  && chown 1000:1000 /opt/dotfiles
```

---

## Debugging

```bash
# Reload everything without opening a new shell
source ~/.bashrc
# or use the alias:
bashreload

# Test a single file in isolation
source ~/.config/bash/20-aliases.sh

# Check which host-specific files are active on this machine
ls ~/.config/bash/$(hostname -s)_*.sh 2>/dev/null \
    || echo "No local files for $(hostname -s)"

# Find where an alias, variable, or function is defined
bashwhich PICO_SDK_PATH
bashwhich ll
```

---

## Design Principles

- **No magic.** One glob pattern, sourced in order. Easy to trace, easy to
  explain to future-you at 2am.
- **Self-selecting.** Adding a machine never requires editing shared files.
- **Repo-identical.** Every Pi has the exact same files. Divergence lives
  in filenames, not branches.
- **Installer-resilient.** A clear boundary in `.bashrc` separates
  hand-maintained config from installer debris.
- **Debuggable in isolation.** Any file can be sourced on its own to test it.

---

## Related Documentation

Full specification and all file templates:
`rpi-bash-config-spec.md` (kept alongside this repo or in your notes)
