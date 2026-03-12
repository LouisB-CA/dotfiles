# Day-to-Day with Git

## Making a Change
All configuration changes are made in `/opt/dotfiles`.
Never edit the stub files in `~/.bashrc`, `~/.bash_profile`, etc. directly.

Edit the appropriate file in the repo, then commit and push:
```bash
cd /opt/dotfiles
vim config/bash/40-aliases.omni
git add config/bash/40-aliases.omni
git commit -m "describe your change"
git push
```

## Pulling Changes on Other Devices
```bash
cd /opt/dotfiles
git pull
```

## Handling Installer Debris
Some applications modify `~/.bashrc` directly — for example the Pico SDK
or juliaup. When this happens:

1. Identify what was added at the bottom of `~/.bashrc`
2. Create a host-specific omni file for it:
```bash
   vim /opt/dotfiles/config/bash/$(hostname -s)_newtool.omni
```
3. Move the installer's lines into that file and test it:
```bash
   source /opt/dotfiles/config/bash/$(hostname -s)_newtool.omni
```
4. Delete the installer's block from `~/.bashrc`
5. Commit and push

## Useful Git Commands
```bash
git status                  # see what has changed
git diff                    # see the changes in detail
git log --oneline -10       # recent commit history
git pull                    # sync from GitHub
git push                    # push to GitHub
```


