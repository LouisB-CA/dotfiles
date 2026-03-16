# Project Layout
```
/opt/dotfiles/
├── config/
│   ├── bash/       — omni files and bash stub files
│   └── vim/        — vim configuration
├── docs/           — project documentation
├── ssh/            — SSH client configuration
├── stubs/          — stub files and installer script
├── .gitignore
└── README.md
```

## The `/opt/dotfiles` Directory
The documentation assumes a project folder named /opt/dotfiles,
but the project can be installed elsewhere.  /opt/dotfiles is like
a default name, but is not the required name.  There is no required
project folder name.

The project exports an environment variable, DOTFILES, which gives
the true name of the project folder.  Scripts, etc, that need the
project folder name should use $DOTFILES.

## The `config/` Directory
Contains all configuration files sourced by the stub files.
The `bash/` subdirectory contains the omni files and the bash stubs.
The `vim/` subdirectory contains the vim configuration.

## The `docs/` Directory
Project documentation as numbered markdown files.

## The `ssh/` Directory
Contains the SSH client configuration file.
See `ssh/README.md` before making any changes here.

## The `stubs/` Directory
Contains the stub files and the installer script.
The user should never matke changes here.
See `stubs/README.md`.

