#!/usr/bin/env bash

set -euo pipefail

exceptions_directory="${1:-assets/security_checks}"
tools=(checkov terrascan tflint tfsec)

parse_exceptions() {
  local file="$1"

  awk '
    /^[[:space:]]*($|#)/ {
      next
    }
    {
      separator = index($0, "#")
      if (separator == 0) {
        printf "%s:%d: missing inline justification\n", FILENAME, NR > "/dev/stderr"
        invalid = 1
        next
      }

      rule = substr($0, 1, separator - 1)
      reason = substr($0, separator + 1)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", rule)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", reason)

      if (rule !~ /^[A-Za-z0-9_.:-]+$/) {
        printf "%s:%d: invalid rule ID\n", FILENAME, NR > "/dev/stderr"
        invalid = 1
      }
      if (reason !~ /reason=[^;]+;[[:space:]]*owner=[^;]+;[[:space:]]*expires=[0-9]{4}-[0-9]{2}-[0-9]{2}$/) {
        printf "%s:%d: expected reason, owner and expiry\n", FILENAME, NR > "/dev/stderr"
        invalid = 1
      }
      if (seen[rule]++) {
        printf "%s:%d: duplicate rule ID %s\n", FILENAME, NR, rule > "/dev/stderr"
        invalid = 1
      }

      rules[++count] = rule
    }
    END {
      if (invalid) {
        exit 1
      }
      for (item = 1; item <= count; item++) {
        printf "%s%s", (item == 1 ? "" : ","), rules[item]
      }
    }
  ' "${file}"
}

if [[ ! -d "${exceptions_directory}" ]]; then
  printf 'Missing security exception directory: %s\n' "${exceptions_directory}" >&2
  exit 1
fi

for tool in "${tools[@]}"; do
  file="${exceptions_directory}/${tool}_exceptions.txt"
  if [[ ! -f "${file}" ]]; then
    printf 'Missing security exception file: %s\n' "${file}" >&2
    exit 1
  fi

  rules="$(parse_exceptions "${file}")"
  if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    printf '%s=%s\n' "${tool}" "${rules}" >> "${GITHUB_OUTPUT}"
  else
    printf '%s=%s\n' "${tool}" "${rules}"
  fi
done
