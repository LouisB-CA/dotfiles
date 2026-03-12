#!/usr/bin/env bash

# Install the 4 stub files from the Omnibus Project
# to the UID=1000 user and the superuser (root)

DOTFILES="/opt/dotfiles"
STUBFILES="${DOTFILES}/stubs"
# get the username and home directory of the UID=1000 user
USER_1000=$(getent passwd 1000 | cut -d: -f1)   # their username
HOME_1000=$(getent passwd 1000 | cut -d: -f6)   # their home dir

# Check that project directory exists
if  [[ -d "$STUBFILES" ]] ; then
    cd "$STUBFILES"
else
    printf "$HEAVY_BALLOT_X Omnibus Project not found."
    exit 1
fi

# Check that /opt/dotfiles and all contents are owned by user $USER_1000
NOT_OWNED=$(find "$DOTFILES" ! -user "$USER_1000")

if [[ -n "$NOT_OWNED" ]]; then
    echo "ERROR: The following paths are not owned by '"$USER_1000"':"
    echo "$NOT_OWNED"
    exit 2
fi

# Check that the stub files exist
if  ! [[ -r .bashrc ]] || \
    ! [[ -r .bash_profile ]] || \
    ! [[ -r vimrc ]] || \
    ! [[ -r config ]] ; then
    echo "Stub file(s) not found"
    exit 3
fi

sudo chmod 0644 .bash_profile .bashrc vimrc
sudo chmod 0600 config

cp .bash_profile "$HOME_1000"/ || exit
cp .bashrc "$HOME_1000"/ || exit
cp config "$HOME_1000"/.ssh/ || exit
mkdir -p "$HOME_1000"/.config/vim || exit
cp vimrc "$HOME_1000"/.config/vim/ || exit
chown -R 1000:1000 "$HOME_1000"/{.bashrc,.bash_profile,.ssh,.config/vim}

sudo cp .bash_profile /root/ || exit
sudo cp .bashrc       /root/ || exit
sudo mkdir -p /root/.config/vim  || exit
sudo cp vimrc /root/.config/vim/ || exit
chown -R root:root /root/{.bashrc,.bash_profile,.config/vim}

sudo chmod 0600 "$HOME_1000"/.ssh/* || exit
sudo chmod 0700 "$HOME_1000"/.ssh   || exit

echo "Managed files were successfully installed."
echo "Use \`source .bashrc\` or logout and then log back in."

# Check that $HOME_1000 and all contents are owned by $USER_1000
echo "Checking file ownership for $USER_1000 ..."
NOT_OWNED=$(find "$HOME_1000"/ ! -user "$USER_1000")

if [[ -n "$NOT_OWNED" ]]; then
    echo "ERROR: The following paths are not owned by '"$USER_1000"':"
    echo "$NOT_OWNED"
    exit 2
else
    echo "    Not following links, all files were owned by $USER_1000"
fi

