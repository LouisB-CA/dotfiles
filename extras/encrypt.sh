#!/usr/bin/env bash

#
# Encrypt sensistive information in the ~/.ssh/config Include file
# Assumes the identity file is in place as ~/.config/age/omnibus.ident
#

IN_FILE="${DOTFILES}/ssh/config"

unset -f old_method
old_method() {
    # DEPRECATED 2026-03-29:
    # This method expects not just the public key, but the whole private
    # key to be in the user's ~/.config/age directory.  This method
    # works but the public key is all that is really need to encrypt
    # sensitive information.
    echo "Encrypting ${IN_FILE} with deprecated function"
    age --encrypt				\
        -i ~/.config/age/omnibus.ident 	\
        -o "${IN_FILE}.age"			\
        "${IN_FILE}"
}

# SUPERSEDES the old_method()
# This method uses the public key found in the
# omnibus.ident file stored in the BitWarden vault.
# public key: age1fevjvtxs2mft3xf8me6hxc2e52rf99k53crqpem7xurfehpdp9hq8fxthc
echo "Encrypting ${IN_FILE}"
age --encrypt                                                           \
    -r age1c0jzshs9qe9hewynveyutngvh4lkvcg5l3er3agvn84dcjyn2yysxnkm5a   \
    -o "${IN_FILE}.age"                                                 \
    "${IN_FILE}"




