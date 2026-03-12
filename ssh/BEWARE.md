
# Sharing ID's and Config
## Only the *~/.ssh/config* file is eligible
* Public and private SSH keys should not be put in a *git* repository
* *known_hosts* and *authorization_keys* are machine specific

## SSH keys can still be shared
* The same user (pi) can use the same ID on every RPi
* Transferring the keys must be done via *rsync*
```bash
# sync keys if you want same identity everywhere
rsync -av --chmod=F600,D700 ~/.ssh/id_ed25519 pi@otherrpi:~/.ssh/
```
* Do not use the Omnibus Project for SSH keys
<br>The project may be pushed to GitHub, which should never contain SSH keys

## Stub files
* The actual .ssh/config file is now a stub file that sources the Omnibus repo
* The Omnibus repo is located on every RPi at /opt/dotfiles/

## Two ways to share
### Using *git push* and *git pull*
* This is not yet implemented

### Use *rsync*
* Identify which RPi has the "master" copy of the project repo
<br>This should be ozymandias

* Do this on the master, ozymandias, device
```bash
# copy everything, with normal permissions
rsync -av --chmod=F644,D755 /opt/dotfiles pi@otherpi4:/opt/

# then fix ssh permissions
rsync -av --chmod=F600,D700 /opt/dotfiles/ssh/ pi@otherpi4:/opt/dotfiles/ssh/

# Also, sync the 4 stub files
rsync -av ~/.ssh/config   pi@otherrpi4:~/.ssh/
rsync -av ~/.config/vim   pi@otherrpi4:~/.config/
rsync -av ~/.bashrc       pi@otherrpi4:~/
rsync -av ~/.bash_profile pi@otherrpi4:~/
```
* Don't forget to sync root's copy of the .bashrc stub file.
<br>root's copy is identical to plain user pi's copy


