#!/usr/bin/env bash

#
# Encrypt sensistive information in the ~/.ssh/config Include file
# Assumes the identity file is in place as ~/.config/age/omnibus.ident
#

IN_FILE="${DOTFILES}/ssh/config"

echo "Encrypting ${IN_FILE}"
age --encrypt				\
    -i ~/.config/age/omnibus.ident 	\
    -o "${IN_FILE}.age"			\
    "${IN_FILE}"

