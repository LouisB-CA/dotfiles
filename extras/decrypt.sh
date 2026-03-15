#!/usr/bin/env bash

#
# Decrypt sensistive information in the ~/.ssh/config.age Include file
# Assumes the identity file is in place as ~/.config/age/omnibus.ident
#

OUT_FILE="${DOTFILES}/ssh/config"

echo "Decrypting ${OUT_FILE}.age"
age --decrypt				\
    -i ~/.config/age/omnibus.ident 	\
    -o "${OUT_FILE}"			\
    "${OUT_FILE}.age"

