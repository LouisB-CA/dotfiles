# The `config/` Directory

## `bash/bashrc`
This is the heart of the Omnibus Project. It contains a non-interactive
shell guard, then loops over every file in `config/bash/` whose name
starts with two digits and ends in `.omni`, sourcing each one in order.
Below a clearly marked boundary, package installers may append lines.
Those lines should be periodically reviewed, migrated to an omni file,
and deleted.

## `bash/bash_profile`
Handles login shells. When the parent process is `sshd`, it sources
`~/.bashrc`, ensuring SSH sessions get the full Omnibus environment.
Below a clearly marked boundary is unmanaged space.

## The Numbered Omni Files
Files named `[0-9][0-9]-*.omni` are sourced automatically by `bashrc`
in lexical order. Each file has a single responsibility. The numbering
controls the load order. These files are the same on every device.

## Host-Specific Omni Files
`70-local.omni` is one of the numbered omni files. Its job is to source
any file in `config/bash/` whose name starts with the current device's
hostname. This is how host-specific configuration is handled without
branching the repo. If no matching file exists, nothing happens.

## `vim/vimrc`
Vim configuration shared by all users on all devices. Requires the full
`vim` package — `vim-tiny`, which ships with some distros, does not
support all features used here. On Debian-based systems install `vim-nox`
or `vim`. On Fedora, `vim-enhanced`.
