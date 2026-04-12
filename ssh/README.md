
# Sharing ID's and Config
## Only the *~/.ssh/config* file is eligible for the Omnibus Project
* Public and private SSH keys should not be put in a *git* repository
* *known_hosts* and *authorization_keys* are host-specific

## SSH keys can be shared
* The same user (pi) can use the same ID on every RPi
* Transferring the keys must be done via *rsync*
```bash
# sync keys if you want the same identity everywhere
rsync -av --chmod=F600,D700 ~/.ssh/id_ed25519 pi@otherrpi:~/.ssh/
```
* Do not use the Omnibus Project for SSH keys themselves
<br>The project may be pushed to GitHub, which should never contain SSH keys

