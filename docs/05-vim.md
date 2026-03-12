# Vim Configuration

The Omnibus vimrc requires full vim — not `vim-tiny`, which ships with
some Debian-based distros and lacks support for features used here.

## Installing Vim

On Debian/Trixie:
```bash
sudo apt install vim -y
```

On Fedora:
```bash
sudo dnf install vim -y
```

## Verifying the Right Vim is Active

Check that the installed vim is Huge or Big, not Tiny:
```bash
command vim --version | head -5
```
Look for a line beginning with `VIM - Vi IMproved` and a second line
containing `Huge`, `Big`, or `Normal`. If it says `Tiny`, install vim
as above.

## Verifying `vi` Invokes the Right Vim
```bash
command -v vi
readlink -f $(command -v vi)
vi --version | head -5
```
The goal is that `vi` and `vim` behave identically on every device.

