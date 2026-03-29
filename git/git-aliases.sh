#!/usr/bin/env bash

ghelp() {
  cat <<EOF
git shortcuts

Aliases:
  gs      git status
  ga      git add
  gc      git commit
  gcm     git commit -m
  gco     git checkout
  gcb     git checkout -b
  gb      git branch
  gl      git log --oneline --graph --decorate
  gd      git diff
  gpl     git pull
  gps     git push

Usage:
  gs
  ga .
  gc
  gcm "my commit message"
  gco main
  gcb feature/test
  gl
EOF
}

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gpl='git pull'
alias gps='git push'
