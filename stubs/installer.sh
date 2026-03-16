#!/usr/bin/env bash

# Install the 4 stub files from the Omnibus Project
# to the UID=1000 user and the superuser (root)

# This script relies on a few things being true:
# 1. this script is a plain file in a subdirectory (e.g. stubs) of the project directory
# 2. thise script is being run as root for the benefit of both root and UID=1000
# 3. programs like age, envsubst, etc are installed
# 4. the project private key is at "~$USER_1000/.config/age/omnibus.ident"

# This script intentionally uses OMNIBUS_HOME to avoid clashes with DOTFILES

# Setup this script's own environment
NOCOLOR="\033[0m"
BOLDRED="\033[1;31m"
BOLDGREEN="\033[1;32m"
HEAVY_CHECK_MARK="\U2714"
HEAVY_BALLOT_X="\U2718"
OKAY="[$BOLDGREEN$HEAVY_CHECK_MARK$NOCOLOR]"
FAIL="[$BOLDRED$HEAVY_BALLOT_X$NOCOLOR]"

# Check that script is running as root
if ! [[ ${EUID} -eq 0 ]] ; then
	printf "$FAIL This "$(basename "${BASH_SOURCE[0]}")" script must be run as root.\n"
	exit 1
fi

# Figure out where we are in the filesystem
# These must be exported to use them in functions
export OMNIBUS_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STUBFILE_DIR="${OMNIBUS_HOME}/stubs"

# get the username and home directory of the UID=1000 user
USER_1000=$(getent passwd 1000 | cut -d: -f1)   # their username
HOME_1000=$(getent passwd 1000 | cut -d: -f6)   # their home dir

# Check that user 1000 exists and has home directory
if [[ -z "$USER_1000" ]] ; then
    printf "$HEAVY_BALLOT_X No user: user name for UID=1000 not found.\n"
    exit 2
elif [[ -z "$HOME_1000" ]] ; then
    printf "$HEAVY_BALLOT_X No home: home directory for user \'$USER_1000\' not found.\n"
    exit 3
fi

# Check that $OMNIBUS_HOME and all contents are owned by user $USER_1000
NOT_OWNED=$(find "$OMNIBUS_HOME" ! -user "$USER_1000")

if [[ -n "$NOT_OWNED" ]]; then
    printf "$FAIL The following paths are not owned by '"$USER_1000"':\n"
    echo "$NOT_OWNED"
    exit 4
fi

# Check that the stub files exist
if  ! [[ -r .bashrc ]] || \
    ! [[ -r .bash_profile ]] || \
    ! [[ -r config ]] || \
    ! [[ -r vimrc ]] ; then
    echo "$FAIL Stub file(s) not found"
    exit 5
fi

printf "$OKAY Installing stub files for root and for user $USER_1000 on host $(hostname)\n"

# define the installation functions
unset -f ssh_config_installer
ssh_config_installer() {
	# Write the ssh stub with the literal resolved path
	mkdir -p "$HOME_1000/.ssh"
	# N.B. envsubst requires OMNIBUS_HOME be exported
	envsubst '$OMNIBUS_HOME' \
		   < "$STUBFILE_DIR/config" \
		   > "${HOME_1000}/.ssh/config"
	chown -R 1000:1000 "${HOME_1000}/.ssh"
	chmod 600 "${HOME_1000}/.ssh/config"
	chmod 700 "${HOME_1000}/.ssh"
}

unset -f check_ownership
check_ownership() {
	# Check that $HOME_1000 and all contents are owned by $USER_1000
	echo "Checking file ownership for $USER_1000 ..."
	echo "    ( Sometimes this takes a while, sometimes not. )"
	NOT_OWNED=$(find "$HOME_1000"/ ! -user "$USER_1000")

	if [[ -n "$NOT_OWNED" ]]; then
   		echo "ERROR: The following paths are not owned by '"$USER_1000"':"
   		echo "$NOT_OWNED"
   		exit 6
	else
   		printf "    $OKAY Not following links, all files were owned by $USER_1000\n"
	fi
}

unset -f cp_or_fail
copy_or_fail() {
	# try to copy the file to the directory
	# provide error message on failure

	if cp "$1" "$2"/ ; then
		true
	else
		printf "$FAIL failed to copy file \"${1}\" to directory \"$2\"\n"
		exit 7
	fi
}

# Finally, perform the installation
cd "$STUBFILE_DIR"
chmod 0644 .bash_profile .bashrc vimrc
chmod 0600 config

mkdir -p "$HOME_1000"/.config/vim
copy_or_fail .bash_profile "$HOME_1000"
copy_or_fail .bashrc       "$HOME_1000"
copy_or_fail vimrc         "$HOME_1000"/.config/vim
chown -R 1000:1000 "$HOME_1000"/{.bashrc,.bash_profile,.ssh,.config/vim}

mkdir -p /root/.config/vim
copy_or_fail .bash_profile /root
copy_or_fail .bashrc       /root
copy_or_fail vimrc         /root/.config/vim
chown -R root:root /root/{.bashrc,.bash_profile,.config/vim}

ssh_config_installer 		# a function defined above
check_ownership

printf "$OKAY Managed files were successfully installed.\n"
echo "    Use \`source .bashrc\` or logout and then log back in."


