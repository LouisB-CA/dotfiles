# Day-to-Day with Git

## Making a Change
All configuration changes are made in $DOTFILES.
Never edit the stub files in `~/.bashrc`, `~/.bash_profile`, etc. directly.

Edit the appropriate file in the repo, then commit and push:
```bash
cd $DOTFILES
vim config/bash/40-aliases.omni
git add config/bash/40-aliases.omni
git commit -m "describe your change"
git push
```

## Pulling Changes on Other Devices
```bash
cd $DOTFILES
git pull
```

## Handling Installer Debris
Some applications modify `~/.bashrc` directly — for example the Pico SDK
or juliaup. When this happens:

1. Identify what was added at the bottom of `~/.bashrc`
2. Create a host-specific omni file for it:
```bash
   vim ${DOTFILES}/config/bash/$(hostname -s)_newtool.omni
```
3. Move the installer's lines into that file and test it:
```bash
   source ${DOTFILES}/config/bash/$(hostname -s)_newtool.omni
```
4. Delete the installer's block from `~/.bashrc`
5. Commit and push

## Handling VSCode Debris in *~/.ssh/code*
A similar situation may arise when using Remote-SSH with VSCode. 
VSCode may make changes to the *~/.ssh/config*, which is a stub file
managed by the Omni Project.  The stub file uses the SSH Include
command to read the actual config file in the $DOTFILES/ssh directory.
Since it contains sensitive informatoin, the actual config file is
not tracked in the repo.

Long story, story, VSCode is know to add lines a user's ~/.ssh/config
stub file, lines that rightfully belong in the $DOTFILES/ssh/config file.
The user must manually move those lines from *~/.ssh/config/* to *$DOTFILES/ssh/config*
and then distribute the *$DOTFILES/ssh/config/* file arond to all the of the clones.

## Useful Git Commands
```bash
git status                  # see what has changed
git diff                    # see the changes in detail
git log --oneline -10       # recent commit history
git pull                    # sync from GitHub
git push                    # push to GitHub
```

