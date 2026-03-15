#~/usr/bin/env bash

#
# bootstrap for new device / fresh OS
#

DOTFILES="${DOTFILES:-/opt/dotfiles}"
if [[ "$EUID" -eq 1000]] ; then
    USER_1000=$(getent passwd 1000 | cut -d: -f1)   # username for plain user
else
    echo You must be user 1000 to run this script
    exit 1
fi

# FIT 1 -- Check that git and age are installed
if command -v git && command -v age ; then
  echo "Okay.  git and age are installed"
else
  if command -v apt-get ; then
    echo "Warning: did not find both git and age"
    if sudo apt-get install git age --yes ; then
      echo "Okay.  git and age have been installed.
    else
      echo "Error:  could not install git and age with apt-get."
      echo "Cannot continue."
      exit 1
    fi
  elif command -v dnf ; then
    if sudo dnf install git age -y ; then
      echo "Okay.  git and age have been installed.
    else
      echo "Error:  could not install git and age with dnf."
      echo "Cannot continue."
      exit 2
    fi
  fi
fi

# FIT 2 -- Create a minimal ~/.gitconfig
# don't want to clobber anything that already exists
isMinimal=false
if ! [ -e ~/.gitconfig ] ; then
  isMinimal=true
  echo "[user]" > ~/.gitconfig        # would clobber the existing file
  echo "  name = LouisB-CA" >> ~/.gitconfig
  echo "  email = 40744052+LouisB-CA@users.noreply.github.com" >> ~/.gitconfig
fi

# FIT 3 -- Clone the repo
sudo git clone https://github.com/LouisB-CA/dotfiles.git /opt/dotfiles
sudo chown -R 1000:1000 "$DOTFILES"

# FIT 4 --
echo "Do the rest by hand:"
$isMinimal && echo "Copy a complete ~/.gitconfig file from another device"
echo "Copy this repo's age key from you BitWarden vault to ~/.age/omnibus.txt"
echo "Run ssh/decrypt.sh"
echo ""

exit 0 ; exit 0

### The bootstrap order on a new device:
### ```text
### 1. Install git, age
### 2. git config --global user.name / user.email   ← temporary real gitconfig
### 3. git clone https://github.com/.../dotfiles.git /opt/dotfiles
### 4. Replace ~/.gitconfig with stub
### 5. scp the age key from Bitwarden/RPi5
### 6. Run decrypt.sh → gets config.private and ssh keys
### 7. Done
### ```


