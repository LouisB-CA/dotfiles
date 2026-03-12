
# Stub Files
* Use these four stub files *without modification*
* Copy these stub files to their install directories. Do not edit.
* Preserve the permissions of these stub files

| stub file     | permission | installation directory |
|---------------|------------|------------------------|
| .bash_profile |    0644    |  ~pi/, /root/                         |
| .bashrc       |    0644    |  ~pi/, /root/                         |
| vimrc         |    0644    |  ~pi/.config/vim/, /root/.config/vim/ |
| config        |    0600    |  ~pi/.ssh/                            |

## Installation
* Stub files are installed once in the user's home directory
* An installer script is provided to facilitate installation
* *install.sh* will overwrite existing files of the same name
* *install.sh* may be run by either a plain user or the superuser

## Changing Your System Configuration
* If you need to change a configuration, you are in the wrong place!
* See the appropriate README.md.

## Applications that Change Your Configuration
* Some aplications have installers that modify your *.bashrc* and *.bash_profile*
* Examples include the Pico SDK for RPi and *juliaup*
* These app-changes must be incorporated into the Omni Project as host-specific changes
* See the regular docs/ for detals on host-specific changes

