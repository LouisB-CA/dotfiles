
# Stub Files
* Use these four stub files *without modification*
* Copy these stub files to their install directories. Do not edit.
* Preserve the permissions of these stub files

| stub file     | permission | installation directory |
|---------------|------------|------------------------|
| .bash_profile |    0644    |  ~pi/, /root/                       |
| .bashrc       |    0644    |  ~pi/, /root/                       |
| vimrc         |    0644    |  ~pi/config/vim/, /root/config/vim/ |
| config        |    0600    |  ~pi/.ssh/                          |

## Installation
* Copy /opt/dotfiles to your RPi device
* Execute the following bash script on the RPi device
```bash
#!/usr/bin/env bash
unset -f installer
installer () {
	cd /opt/dotfiles/
	chmod 0644 .bash_profile .bashrc vimrc
	chmod 0600 config
	cp .bash_profile ~pi/
	cp .bash_profile /root/
	cp .bashrc ~pi/
	cp .bashrc ~/root/
	mkdir -p ~pi/.config/vim
	cp vimrc ~pi/.config/vim/
	mkdir -p /root/.config/vim
	cp vimrc /root/.config/vim/
	cp config ~pi/.ssh/
	chown -R pi:pi ~pi/
	chown -R root:root /root/
	chmod 0600 ~pi/.ssh/*
	chmod 0700 ~pi/.ssh
}
sudo installer
unset -f installer
```
## Changing Your System Configuration
* If you need to change a configuration, you are in the wrong place!
* See the appropriate README.md.

