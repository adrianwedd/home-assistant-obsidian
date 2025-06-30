#!/bin/bash
# Fail if commit message does not start with ADDON-XXX: prefix
msg_file="$1"
if ! grep -qE '^ADDON-[0-9]{3}: ' "$msg_file"; then
    echo "Commit message must start with 'ADDON-XXX: ' prefix" >&2
    exit 1
fi
