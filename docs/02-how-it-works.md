# How It Works

## The Stub Files
Four stub files are installed in each user's home directory:

| Stub file       | Installed at          |
|-----------------|-----------------------|
| `.bashrc`       | `~/.bashrc`           |
| `.bash_profile` | `~/.bash_profile`     |
| `vimrc`         | `~/.config/vim/vimrc` |
| `config`        | `~/.ssh/config`       |

Each stub file sources its counterpart in the repo. The stub files
are not meant to be edited. All configuration changes are made in the repo.

## The Omni Files
The bash stub sources `config/bash/bashrc`, which runs a loop over every
file in `config/bash/` whose name starts with two digits and ends in `.omni`,
sourcing each one in order. These are the omni files.

Each omni file has a single responsibility — aliases, environment
variables, prompt, and so on. Adding or changing a file does not
require editing `bashrc`.

## Host-Specific Configurations
After the numbered omni files, `bashrc` sources any file in `config/bash/`
whose name starts with the current device's hostname. This is how
device-specific configuration is handled without branching the repo.
If no hostname file exists for a device, nothing happens.

## The Installer
One script deploys all four stub files to their correct locations
for all users. See `docs/09-stubs.md`.

## The Documentation
Project documentation lives in the `docs/` directory as numbered markdown
files. The subject of each file is in its name. Browse the directory to
find more information on the above topics.

