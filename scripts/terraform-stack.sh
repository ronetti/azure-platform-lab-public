#!/usr/bin/env bash

set -euo pipefail

action="${1:-}"
stack="${2:-}"
environment="${3:-}"

case "${action}" in
  init|validate|plan) ;;
  *)
    printf 'Usage: %s <init|validate|plan> <stack> <nonproduction|production>\n' "$0" >&2
    exit 1
    ;;
esac

case "${stack}" in
  network|shared-services|routing|firewall|application-gateway|compute|configuration-management|aks) ;;
  *)
    printf 'Unknown stack: %s\n' "${stack}" >&2
    exit 1
    ;;
esac

case "${environment}" in
  nonproduction|production) ;;
  *)
    printf 'Unknown environment: %s\n' "${environment}" >&2
    exit 1
    ;;
esac

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stack_directory="${repository_root}/terraform/stacks/${stack}"
backend_file="${repository_root}/environments/${environment}/${environment}.azurerm.tfbackend.example"
state_key="platform/${stack}/${environment}.tfstate"

case "${action}" in
  init)
    terraform -chdir="${stack_directory}" init \
      -backend-config="${backend_file}" \
      -backend-config="key=${state_key}"
    ;;
  validate)
    terraform -chdir="${stack_directory}" init -backend=false -input=false
    terraform -chdir="${stack_directory}" validate
    ;;
  plan)
    terraform -chdir="${stack_directory}" plan -var "environment=${environment}"
    ;;
esac
