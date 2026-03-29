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

case "$1" in
  help|-h|--help)
    print_help
    return
    ;;
esac

git fetch --prune
branches="$(git for-each-ref --format='%(refname:short) %(upstream:track)' refs/heads | grep '\[gone\]' | awk '{print $1}')"

if [ -z "$branches" ]; then
  echo "no gone branches found"
  return
fi

while IFS= read -r branch; do
  [ -n "$branch" ] || continue
  git branch -D "$branch"
done <<< "$branches"
