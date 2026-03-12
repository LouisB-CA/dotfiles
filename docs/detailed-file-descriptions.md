# Omnibus Project<br>Modular Bash Configuration<br>for Raspberry Pi Fleet
## Specification & Implementation Guide

---

## 1. Overview

This document describes a modular, git-managed bash configuration system
designed for a fleet of Raspberry RPi devices (RPi3, RPi4, RPi5) sharing a
common home directory structure. The design goals are:

- One git repository (`/opt/dotfiles/`) that is identical on every RPi
- Provides bash and vim identical configuration files for plain users and for the superuser
- Provides identical ~/.ssh/config file for plain users
- Shared global config (aliases, environment, prompt, PATH) applies everywhere
- Machine-specific config (e.g. RPico SDK on one RPi only) is self-selecting
  based on hostname — no per-machine branches or manual switching required
- All configuration is done through stub files that source the repo files
- Installer debris in `.bashrc` is contained and manageable
- The system is easy to debug and extend

---

## 2. Directory Layout
* Some of these repo filenames are notional.
```
/opt/dotfles/
├── .bashrc                         ← thin, hand-maintained, sources the config dir
├── .config/
│   └── bash/                       ← git repository root
│       ├── .git/
|       ├── bashrc                  - copy of ~/.bashrc
|       ├── bashrc_profle           - copy of ~/.bashrc_profile, for login shells
│       ├── README.md
│       ├── 10-path.omni            ← global PATH additions
│       ├── 20-settings.omni        ← shell settings
│       ├── 30-environment.omni     ← global environment variables
│       ├── 32-colors.omni          ← ansi escapes variables
│       ├── 34-special_chars.omni   ← check marks, crosses, emojis, etc.
│       ├── 40-aliases.omni         ← most shell aliases
│       ├── 42-aliases_ls.omni      ← shell aliases for /usr/bin/ls
│       ├── 50-functions.omni       ← reusable shell functions
│       ├── 60-prompt.omni          ← PS1 prompt definition
│       ├── 70-local.omni           ← hostname dispatcher (sourced on all RPis)
│       ├── myRPi3_baseline.omni    ← RPi3-specific config (only runs on myRPi3)
│       ├── myRPi4_pico_sdk.omni    ← Pico SDK config   (only runs on myRPi4)
│       └── myRPi5_cluster.omni     ← RPi5-specific config (only runs on myRPi5)
├── docs/
│   ├── table-of-contents.md        ← one-line description of all markdown files
│   ├── project-overview.md         ← objectives and organiztion
│   ├── details-of-cfg-bash-dir.md  ← describes each file
│   ├── details-of-cfg-vim-dir.md   ← describes vimrc
│   ├── details-of-ssh-dir.md       ← describes what is included and what is not
│   ├── details-of-stubs.md         ← describes stub files and the installer
│   ├── usage.md                    ← describes the intended usage
│   ├── adding-device-to-subnet.md  ← describes adding a new RPi device
│   └── upgrading-sd-card.md        ← workflow for fresh RPi imager image
├── stubs/
│   ├── .bash_profile
│   ├── .bashrc
│   ├── config
│   ├── installer.sh
│   ├── README.md                   ← warnings to not edit these stub files
│   └── vimrc
```

### Naming Convention Rules

| Pattern            | Auto-sourced by `.bashrc`? | Purpose                        |
|--------------------|----------------------------|--------------------------------|
| `[0-9][0-9]*.omni` | YES                        | Global config, runs on all Pis |
| `hostname_*.omni`  | NO                         | Machine-specific, hostname-gated |

The two-digit prefix is the gate. Installer-appended lines in `.bashrc` and
hostname-prefixed files both fail to match `[0-9][0-9]*.omni`, so they are
never auto-sourced accidentally.

---

## 3. The Stub Files

* Where the four stub files get installed
/home/pi/
├── .bashrc           ← identical for user pi and superuser root
├── .bash_profile     ← identical for pi & root 
├── .config/
│   └── vim/          
|       ├── vimrc     - identical for pi & root
├── .ssh/
│   └── config        - only for user pi

### The `~/.bash_profile` File
### The `~/.bashrc` File
```bash
# ~/bashrc: This stub file is managed by the Omnibus Project.
# See /opt/dotfiles/README.md

source /opt/dotfiles/config/bash/bashrc

# Lines below the DO NOT EDIT boundary are managed by package installers.
# Periodically review the items below and migrate the clean items from below
# to /opt/dotfiles/config/bash/, then delete them from below.
# ── DO NOT EDIT ABOVE THIS LINE ───────────────────────────────────────────

```

#### The `/opt/dotfiles/config/bash/bashrc` File

Keep `bashrc` as thin as possible. Its only job is to source the config
directory. Installer additions accumulate below a clearly marked boundary.

```bash
# ~/.bashrc
# Non-interactive shell guard — do not remove
case $- in
    *i*) ;;
      *) return;;
esac

# ── Modular bash config ────────────────────────────────────────────────────
# All configuration lives in ~/.config/bash/
# Files matching [0-9][0-9]*.omni are sourced in lexical order.
# Machine-specific files are dispatched by 70-local.omni via hostname.
# See ~/.config/bash/README.md for full documentation.

if [ -d "$HOME/.config/bash" ]; then
    for f in "$HOME"/.config/bash/[0-9][0-9]*.omni; do
        [ -r "$f" ] && source "$f"
    done
    unset f
fi

# ── DO NOT EDIT ABOVE THIS LINE ───────────────────────────────────────────
# Lines below this boundary are managed by package installers.
# Periodically review, migrate clean items to ~/.config/bash/, then delete.

```

**Notes:**
- The `[0-9][0-9]*.omni` glob is the sole selection rule — no other logic needed
- The `[ -r "$f" ]` test skips unreadable files and handles an empty directory
  gracefully (bash expands an unmatched glob to the literal pattern string,
  which would fail the readability test)
- The installer boundary comment is a forcing function to keep you honest

---

### The `~/.config/vim/vimrc` File
* Note that *Vim* uses a double quote (") for comments
```vim
" ~/.config/vimrc: This stub file is managed by the Omnibus Project.
" See /opt/dotfiles/README.md

source /opt/dotfiles/config/vim/vimrc
```

### The `~/.ssh/config` File

## 4. The `70-local.omni` File

This file is sourced on every RPi (it matches `[0-9][0-9]*.omni`), but it
only activates scripts whose names begin with the current machine's hostname.

```bash
# ~/.config/bash/70-local.omni
# Machine-specific config dispatcher.
#
# Files named  <hostname>_*.omni  in this directory are sourced only on the
# machine whose hostname matches.  All other RPis silently skip them.
# This file itself runs on every RPi — it is the dispatcher, not the config.
#
# Example:
#   myRPi4_pico_sdk.omni   → sourced only when hostname -s == myRPi4
#   myRPi3_baseline.omni   → sourced only when hostname -s == myRPi3
#
# To add config for a new machine, create  <hostname>_<description>.omni
# No edits to this file or to .bashrc are required.

_host="$(hostname -s)"
_dir="$HOME/.config/bash"

for f in "$_dir/${_host}"_*.omni; do
    [ -r "$f" ] && source "$f"
done

unset _host _dir f
```

**Notes:**
- `hostname -s` strips any domain suffix, keeping filenames clean
- The glob `${_host}_*.omni` means one host can have multiple files
  (e.g. `myRPi4_pico_sdk.omni` and `myRPi4_gpio_tools.omni`) — all are sourced
- Variables are prefixed with `_` and unset to avoid polluting the environment
- No edits to this file are ever needed when adding a new machine

---

## 5. Individual Config Files

### `10-path.omni` — PATH additions common to all RPis

```bash
# ~/.config/bash/00-path.omni
# Global PATH modifications.
# Machine-specific PATH changes belong in a hostname-prefixed file.
#
# Pattern: only add to PATH if the directory exists and isn't already in PATH

_prepend_path() {
    [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"
}
_append_path() {
    [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]] && PATH="$PATH:$1"
}

_append_path "$HOME/bin"
_append_path "$HOME/.local/bin"

unset -f _prepend_path _append_path
export PATH
```

### 20-settings.omni  Settings for bash shell
Include here environment variables that are not exported to 
child processes since they really are settings for the bash shell.
```bash
tabs -4

HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT="%F %T  "

# Append to history rather than overwriting
shopt -s histappend

# Check window size after each command
shopt -s checkwinsize
```

### `30-environment.omni` — Global environment variables
Include only environment variables that must be exported to child processes.

```bash
# ~/.config/bash/20-environment.omni
# Environment variables common to all RPis.

export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-R --quit-if-one-screen'
```

### `40-aliases.omni` — Aliases

```bash
# ~/.config/bash/40-aliases.omni
# Shell aliases common to all RPis.

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Shortcut to re-source all config
alias bashreload='source ~/.bashrc && echo "bashrc reloaded"'

# Shortcut to edit config files
alias bashedit='${EDITOR:-vim} ~/.config/bash/'
```

### `50-functions.omni` — Shell functions

```bash
# ~/.config/bash/50-functions.omni
# Reusable shell functions common to all RPis.

# Create a directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Show which file a sourced alias/function came from
bashwhich() {
    grep -r "$1" ~/.config/bash/ 2>/dev/null
}

# Quick system summary (handy on headless RPis)
sysinfo() {
    echo "Hostname : $(hostname -s)"
    echo "Uptime   : $(uptime -p)"
    echo "CPU temp : $(vcgencmd measure_temp 2>/dev/null || echo 'n/a')"
    echo "Memory   : $(free -h | awk '/^Mem/{print $3 " used / " $2 " total"}')"
    echo "Disk     : $(df -h / | awk 'NR==2{print $3 " used / " $2 " total (" $5 " full)"}')"
}
```

### `60-prompt.omni` — PS1 prompt

```bash
# ~/.config/bash/60-prompt.omni
# Prompt definition.  Includes hostname so you always know which RPi you're on.

# Colors
_reset='\[\e[0m\]'
_green='\[\e[32m\]'
_cyan='\[\e[36m\]'
_yellow='\[\e[33m\]'
_red='\[\e[31m\]'

# Show red prompt when running as root
if [ "$EUID" -eq 0 ]; then
    _user_color="$_red"
else
    _user_color="$_green"
fi

# Format: user@hostname:~/current/dir $
PS1="${_user_color}\u${_reset}@${_cyan}\h${_reset}:${_yellow}\w${_reset}\$ "

unset _reset _green _cyan _yellow _red _user_color
```

### Example: `myRPi4_pico_sdk.omni` — Machine-specific file

```bash
# ~/.config/bash/myRPi4_pico_sdk.omni
# Pico SDK environment — myRPi4 only.
# Sourced automatically by 70-local.omni when hostname -s == myRPi4.
#
# This file was migrated from installer-appended lines in .bashrc on 2025-03-09.
# Original installer: Raspberry Pi Pico SDK setup script

export PICO_SDK_PATH="$HOME/pico/pico-sdk"
export PICO_EXTRAS_PATH="$HOME/pico/pico-extras"

# Add Pico tools to PATH
_pico_tools="$HOME/pico/pico-sdk/bin"
[ -d "$_pico_tools" ] && [[ ":$PATH:" != *":$_pico_tools:"* ]] \
    && PATH="$PATH:$_pico_tools"

unset _pico_tools
export PATH
```

---

## 6. Sharing Across All RPis

### Recommended: NFS mount or rsync

Since `~/.config/bash/` is a git repo, the simplest approach for keeping all
Pis in sync is to designate one RPi as the authoritative source and pull from it:

```bash
# On any RPi: pull latest config from the authoritative RPi
cd ~/.config/bash && git pull origin main
```

Or use a private GitHub/GitLab repo and push/pull from all RPis.

### Alternatively: rsync

```bash
# To pull the project files from the authoritative source,
# assuming owner has UID 1000 on both source and destination,
# do this as root on the destination :

PROJECT_SRC=owner@192.168.12.xxx:/opt/project/
rsync -av --numeric-ids --chown=1000:1000 "$PROJECT_SRC" /opt/dotfiles/ \
  && chown 1000:1000 /opt/dotfiles
```

### What NOT to sync

- `~/.bashrc` itself — keep a canonical version in git separately, but be
  aware installer additions will differ per machine over time
- Anything in `/etc/ssh/` — host keys must remain unique per machine

---

## 7. Workflow: Adding a New Machine-Specific Config

When an installer modifies `.bashrc` on one RPi:

1. **Inspect what changed:**
   ```bash
   git diff ~/.bashrc   # if .bashrc is tracked
   # or simply:
   tail -30 ~/.bashrc
   ```

2. **Create a new host-specific file:**
   ```bash
   vim ~/.config/bash/$(hostname -s)_newtool.omni
   ```

3. **Move the installer's additions into that file**, test it:
   ```bash
   source ~/.config/bash/$(hostname -s)_newtool.omni
   ```

4. **Delete the installer's block from `.bashrc`**

5. **Commit and push:**
   ```bash
   cd ~/.config/bash
   git add $(hostname -s)_newtool.omni
   git commit -m "Add newtool config for $(hostname -s)"
   git push
   ```

6. **Pull on the other RPis** — the new file is present but silently ignored
   because its hostname prefix doesn't match theirs.

---

## 8. Debugging Tips

**Test a single config file in isolation:**
```bash
source ~/.config/bash/40-aliases.omni
```

**Check which hostname-specific files would run on this machine:**
```bash
ls ~/.config/bash/$(hostname -s)_*.omni 2>/dev/null || echo "No local files for $(hostname -s)"
```

**Reload everything without opening a new shell:**
```bash
source ~/.bashrc
# or use the alias defined in 40-aliases.omni:
bashreload
```

**Find where an alias or variable is defined:**
```bash
bashwhich PICO_SDK_PATH
bashwhich ll
```

---

## 9. Quick-Start Checklist

- [ ] Create `~/.config/bash/` directory
- [ ] `git init ~/.config/bash/`
- [ ] Create each numbered `.omni` file from the templates above
- [ ] Create `50-local.omni`
- [ ] Add the for-loop and boundary comment to `~/.bashrc`
- [ ] Test: open a new shell, verify prompt and aliases work
- [ ] For each RPi that has installer additions in `.bashrc`, migrate them to a
      `$(hostname -s)_*.omni` file and delete the original block
- [ ] Commit everything and push to a remote repo
- [ ] Clone/pull the repo on each remaining RPi
- [ ] Verify on each RPi that only the correct host-specific files activate

---

*Last updated: 2026-03-09*
