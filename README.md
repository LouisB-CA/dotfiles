# Omnibus Project

Provides a uniform bash, vim, and SSH configuration across Linux devices.
The same configuration files are used by all users on all devices.

## What It Manages
- Bash configuration — shell settings, environment, aliases, functions, prompt
- Vim configuration
- SSH client configuration

## How It Works
Stub files in each user's home directory source the configuration files
in this repo. All devices share identical repo files. One installer script
deploys the stubs.

## Documentation
See the `docs/` directory.

## Repo Layout
| Directory | Contents |
|-----------|----------|
| `config/` | Configuration files sourced by the stub files |
| `docs/`   | Project documentation |
| `ssh/`    | SSH client configuration |
| `stubs/`  | Stub files and installer script |

