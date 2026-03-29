  print_help() {
    cat <<EOF
gclear - remove local branches whose remote is gone

Usage:
  gclear
  gclear help|-h|--help

What it does:
  Finds local branches marked as gone in 'git branch -vv'
  Skips the current branch
  Deletes those local branches
EOF
}

gclear() {
  case "$1" in
    help|-h|--help)
      print_help
      return
      ;;
  esac

  local branches
  branches="$(git branch -vv | grep ': gone]' | grep -v '\*' | awk '{ print $1 }')"

  if [ -z "$branches" ]; then
    echo "no gone branches found"
    return
  fi

  echo "$branches" | xargs -r git branch -D
}
