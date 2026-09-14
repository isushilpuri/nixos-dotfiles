#!/usr/bin/env bash
set -euo pipefail

# Go to nix-dots repo
pushd ~/nixos-dotfiles/ >/dev/null

flake=".#nixos"
toplevel=".#nixosConfigurations.nixos.config.system.build.toplevel"
log=os-switch.log
rm -f "$log"

section() { printf '\n\e[1;35m==> %s\e[0m\n' "$*"; }
info() { printf '\e[36m  -> %s\e[0m\n' "$*"; }
fail() { printf '\e[1;31m  !! %s\e[0m\n' "$*"; }

# Build result goes in a temp dir; removed on exit (the system profile keeps it alive)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
result="$tmp/result"

# Show diff of nix files
section "Changes to nix files"
if git diff --quiet -- '*.nix'; then
    info "No uncommitted .nix changes."
else
    git diff --stat -- '*.nix'
    git diff -U0 -- '*.nix'
fi

read -rp "Do you want to proceed with system rebuild? (y/N): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    popd >/dev/null
    exit 0
fi

# Build as the normal user, showing downloads/builds with a progress bar
section "Building system ($flake)"
if command -v nom >/dev/null; then
    info "Using nix-output-monitor"
    build=(nom build "$toplevel" --out-link "$result")
else
    info "nix-output-monitor not installed, falling back to nix build"
    build=(nix build "$toplevel" --out-link "$result" --print-build-logs)
fi
if ! "${build[@]}"; then
    fail "Build failed (see output above)."
    exit 1
fi
info "Built $(readlink "$result")"

# Show what changed compared to the running system
section "Package changes"
if [[ "$(readlink -f /run/current-system)" == "$(readlink -f "$result")" ]]; then
    info "Identical to the current system."
elif command -v nvd >/dev/null; then
    nvd diff /run/current-system "$result"
else
    info "nvd not installed, skipping package diff."
fi

# Activate: register the generation and switch to it (what nixos-rebuild switch does)
section "Activating new generation"
if ! {
    sudo nix-env -p /nix/var/nix/profiles/system --set "$(readlink "$result")" &&
        sudo "$result/bin/switch-to-configuration" switch
} 2>&1 | tee "$log"; then
    fail "Activation failed, full output in $log:"
    grep --color=always -i "error" "$log" || true
    exit 1
fi

# Get current generation
gen=$(nixos-rebuild list-generations | grep True | awk '{print $1, $2, $3}')
section "Done: generation $gen (took $((SECONDS / 60))m $((SECONDS % 60))s)"

# Commit changes if there are any
if ! git diff --quiet; then
    git commit -am "System Gen $gen"
    info "Changes committed."
else
    info "No changes to commit."
fi

# Return to original directory
popd >/dev/null
