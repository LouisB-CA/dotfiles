
# To-Do List for the Omnibus Project

## Priority Items
* Gather all functions for all devices and organize them
* Separate the 50-functions.omni into well-commented files
  - One 52-media.omni for functions that build on ffmpeg, ffprobe, etc
  - One 52-bash.omni for functions like cd() and snip()

* App installer debris workflow (what to do when an app modifies .bashrc) — belongs in 04-config.md, which already covers the omni files and the "DO NOT EDIT" boundary. A short "Handling Installer Additions" section fits naturally there.

* Keeping devices in sync (git pull / rsync workflow) — not covered anywhere in the numbered docs yet. This belongs in 08 or 09 depending on how you want to sequence things.

* Debugging tips — not covered anywhere. Worth its own numbered doc, probably 09.

* Design principles — the brief list in project-overview.md is good. Could append a short "Design Principles" section to 01-overview.md.

* Review the files *detailed-file-descriptions.md* *project-overview.md* to see if there's
anything useful, or even still relevant, in them.  If they are OBE, delete them.

* Add ~/.gitconfig to the project.  Make ~/.gitconfig a stub file with these contents
```git
# ~/.gitconfig
[include]
    path = "$DOTFILES/config/git/gitconfig"
```
and create a "$DOTFILES/config/git/gitconfig" with these contents
```git
[user]
	name = LouisB-CA
	email = 40744052+LouisB-CA@users.noreply.github.com
[credential "https://github.com"]
	helper = 
	helper = !/usr/bin/gh auth git-credential
[credential "https://gist.github.com"]
	helper = 
	helper = !/usr/bin/gh auth git-credential
[init]
	defaultBranch = main
```
But, this approach creates another stub that may be modified by day-to-day use of git.
So, the user will have to remove the debris from the stub file "~/.gitconfig" 
and put is in the project file "$DOTFILES/config/git/gitconfig"


## Nice to Have

* test installer.sh runs as either plain user or superuser
* clean up dead code in 60-prompts.omni.
<br>only the last value of PS1 should be retained.

* useful git commands / cheatsheet for maintaining this project

