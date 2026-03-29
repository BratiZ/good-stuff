#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASHRC="$HOME/.bashrc"
BASH_SCRIPT="$SCRIPT_DIR/bash"
GIT_SCRIPT="$SCRIPT_DIR/git"

START_MARK="# >>> good-stuff START <<<"
END_MARK="# >>> good-stuff END <<<"

touch "$BASHRC"

# 1. clean old managed block
if grep -Fq "$START_MARK" "$BASHRC"; then
  awk -v start="$START_MARK" -v end="$END_MARK" '
    $0 == start { skip=1; next }
    $0 == end { skip=0; next }
    !skip { print }
  ' "$BASHRC" > "$BASHRC.tmp"

  mv "$BASHRC.tmp" "$BASHRC"
fi

# 2. add fresh managed block
cat >> "$BASHRC" <<EOF
$START_MARK
# This block is managed by good-stuff, do not edit manually.
# Changes will be overwritten on next setup.

# Bash utility functions
source "$BASH_SCRIPT/goto.sh" "\$@"
source "$BASH_SCRIPT/reload.sh" "\$@"

# Git utilities and aliases
source "$GIT_SCRIPT/git-aliases.sh"
source "$GIT_SCRIPT/gclear.sh"

echo "good-stuff: loaded bash utilities and git aliases"
$END_MARK
EOF

echo "Installed into ~/.bashrc"
echo " + goto, more: goto help"
echo " + reload, more: reload help"
echo " + git aliases, more: ghelp"
echo " + gclear, more: gclear help"
echo ""
echo "Run: source ~/.bashrc"
