#!/usr/bin/env bash

set -euo pipefail

status=0

while IFS= read -r reference
do
  case "${reference}" in
    ./*) continue ;;
  esac

  ref="${reference##*@}"
  if [[ ! "${ref}" =~ ^[0-9a-f]{40}$ ]]
  then
    printf 'External action is not pinned to a full commit SHA: %s\n' \
      "${reference}" >&2
    status=1
  fi
done < <(
  sed -nE \
    's/^[[:space:]-]*uses:[[:space:]]*([^[:space:]#]+).*/\1/p' \
    "$@"
)

exit "${status}"
