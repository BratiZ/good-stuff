#!/usr/bin/env bash

print_help() {
  cat <<EOF
reload - reload current Git Bash configuration

Usage:
  reload [help | -h | --help]

Examples:
  reload
  reload help
  reload -h
  reload --help
EOF
}

reload() {
  case "$1" in
    "" )
      if [ ! -f "$HOME/.bashrc" ]; then
        echo "no ~/.bashrc found"
        return
      fi

      source "$HOME/.bashrc"
      ;;
    help|-h|--help)
      print_help
      ;;
    *)
      echo "unknown option: $1"
      print_help
      return
      ;;
  esac
}
