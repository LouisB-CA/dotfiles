
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


## Nice to Have

* test installer.sh runs as either plain user or superuser
* clean up dead code in 60-prompts.omni.
<br>only the last value of PS1 should be retained.

* useful git commands / cheatsheet for maintaining this project

