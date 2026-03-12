# Stub Files

Four stub files are installed in each user's home directory. Their only
job is to source their counterparts in the Omnibus repo. They are not
meant to be edited.

| Stub file       | Installed at              | Users (on RPi) |
|-----------------|---------------------------|----------------|
| `.bashrc`       | `~/.bashrc`               | pi, root       |
| `.bash_profile` | `~/.bash_profile`         | pi, root       |
| `vimrc`         | `~/.config/vim/vimrc`     | pi, root       |
| `config`        | `~/.ssh/config`           | pi only        |

## Permissions

| Stub file       | Permission |
|-----------------|------------|
| `.bashrc`       | 0644       |
| `.bash_profile` | 0644       |
| `vimrc`         | 0644       |
| `config`        | 0600       |

## The Installer
`stubs/installer.sh` copies the stub files to their correct locations
and sets the correct permissions for all users. Run it as root.

