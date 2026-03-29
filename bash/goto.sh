#!/usr/bin/env bash

GOTO_STORE="$HOME/.goto_paths"
touch "$GOTO_STORE"

print_paths() {
  echo "Saved paths"
  while IFS='=' read -r key path; do
    [ -n "$key" ] && echo " $key -> $path"
  done < "$GOTO_STORE"
}

get_path() {
  local search_key="$1"
  grep -E "^${search_key}=" "$GOTO_STORE" | head -n 1 | cut -d'=' -f2-
}

add_path() {
  local key="$1"
  shift
  local path="$*"

  if [ -z "$key" ] || [ -z "$path" ]; then
    echo "usage: goto add <key> <path>"
    return
  fi

  if [ "$path" = "." ]; then
    path="$PWD"
  fi

  if grep -Eq "^${key}=" "$GOTO_STORE"; then
    echo "key already exists: $key"
    return
  fi

  echo "${key}=${path}" >> "$GOTO_STORE"
  echo "added: $key -> $path"
}

remove_path() {
  local auto_confirm="false"
  local key

  if [ "$1" = "-y" ]; then
    auto_confirm="true"
    shift
  fi

  key="$1"

  if [ -z "$key" ]; then
    echo "usage: goto rm [-y] <key>"
    return
  fi

  local path
  path="$(get_path "$key")"

  if [ -z "$path" ]; then
    echo "no path found for $key"
    return
  fi

  if [ "$auto_confirm" != "true" ]; then
    echo "are you sure you want to delete: $key -> $path"
    read -r -p "[Y/N] " answer

    case "$answer" in
      Y|y) ;;
      *)
        echo "cancelled"
        return
        ;;
    esac
  fi

  awk -F= -v key="$key" '$1 != key' "$GOTO_STORE" > "$GOTO_STORE.tmp" &&
    mv "$GOTO_STORE.tmp" "$GOTO_STORE"

  echo "removed: $key"
}

go_to_path() {
  local key="$1"

  if [ -z "$key" ]; then
    echo "Usage:"
    echo "  goto <key>"
    echo "  goto --paths"
    echo "  goto --add <key> <path>"
    echo "  goto --remove <key>"
    return
  fi

  local target
  target="$(get_path "$key")"

  if [ -n "$target" ]; then
    cd "$target" || return
    return
  fi

  echo "no path found for $key"
  read -r -p "should create new entry? [Y/N] " answer

  case "$answer" in
    Y|y)
      read -r -p "path: " new_path

      if [ -z "$new_path" ]; then
        echo "path cannot be empty"
        return
      fi

      echo "${key}=${new_path}" >> "$GOTO_STORE"
      cd "$new_path" || return
      ;;
    *)
      ;;
  esac
}

print_help() {
  cat <<EOF
goto - shortcut directory navigation

Usage:
  goto <key>             Go to path
  goto add <key> <path>  Add new shortcut
  goto add <key> .       Add current directory as shortcut
  goto rm <key>          Remove shortcut with confirmation
  goto rm -y <key>       Remove shortcut without confirmation
  goto ls                List all shortcuts
  goto help              Show this help

Examples:
  goto work
  goto add work /c/Users/me/projects/work
  goto add here .
  goto rm work
  goto rm -y work
  goto ls
EOF
}

goto() {
  case "$1" in
    ls)
      print_paths
      ;;
    add)
      shift
      add_path "$@"
      ;;
    rm)
      shift
      remove_path "$@"
      ;;
    help|-h|--help)
      print_help
      ;;
    *)
      go_to_path "$1"
      ;;
  esac
}
