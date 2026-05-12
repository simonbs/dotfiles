#!/usr/bin/env bash

# sync-local-envs
#
# Recursively copies all `.env.local` files from the main Git worktree
# into the current worktree.
#
# Features:
# - Preserves relative paths
# - Overrides existing files
# - Skips ignored directories, e.g. cdk.out, dist, build
# - Works from any linked worktree
#
# Usage:
#   sync-local-envs

set -euo pipefail

current_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "Not inside a git repository"
  exit 1
}

git_dir="$(git rev-parse --git-common-dir)"

main_worktree="$(
  cd "$git_dir" &&
    git worktree list --porcelain | awk '
      /^worktree / { print $2; exit }
    '
)"

if [[ -z "$main_worktree" ]]; then
  echo "Could not determine main worktree"
  exit 1
fi

prune_args=()

while IFS= read -r ignored_dir; do
  [[ -z "$ignored_dir" ]] && continue
  prune_args+=( -path "$main_worktree/$ignored_dir" -o )
done < <(
  git -C "$main_worktree" status --ignored --short |
    awk '/^!! .*\/$/ {
      sub(/^!! /, "")
      sub(/\/$/, "")
      print
    }'
)

if (( ${#prune_args[@]} > 0 )); then
  unset 'prune_args[${#prune_args[@]}-1]'
  prune_args=( \( "${prune_args[@]}" \) -prune -o )
fi

find "$main_worktree" "${prune_args[@]}" -type f -name ".env.local" -print |
  while IFS= read -r src; do
    rel="${src#$main_worktree/}"
    dest="$current_root/$rel"

    mkdir -p "$(dirname "$dest")"
    cp -f "$src" "$dest"

    echo "Copied: $rel"
  done
