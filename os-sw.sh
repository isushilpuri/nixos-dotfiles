#!/usr/bin/env bash
set -euo pipefail

# Go to nix-dots repo
pushd ~/nixos-dotfiles/

rm -f os-switch.log

# Show diff of nix files
git diff -U0 -- '*.nix'

read -rp "Do you want to proceed with system rebuild? (y/N): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    popd
    exit 0
fi

# Rebuild System Manager, log output
echo "System Rebuilding..."
if ! sudo nixos-rebuild switch --flake .#nixos &>os-switch.log; then
    grep --color=always "error" os-switch.log || true
    exit 1
fi

# Get current generation
gen=$(nixos-rebuild list-generations | grep True | awk '{print $1, $2, $3}')

# Commit changes if there are any
if ! git diff --quiet; then
    git commit -am "System Gen $gen"
    echo "Changes committed."
else
    echo "No changes to commit."
fi

# Return to original directory
popd
