#!/bin/bash
set -uxo pipefail

repo_root="$(cd $(dirname $(realpath "$BASH_SOURCE")); git rev-parse --show-toplevel 2>/dev/null)"

# You may customize this:
export LITELLM_PROXY_API_KEY=$(grep master_key "$repo_root"/litellm.yml | cut -d: -f2 | tr -d ' \t')
export LITELLM_PROXY_API_BASE="http://localhost:4000"

if ! curl --location $LITELLM_PROXY_API_BASE/health -H "Authorization: Bearer $LITELLM_PROXY_API_KEY"; then
    # we need to spin up the compose file
    
    if [ ! -e "$repo_root"/compose.yaml ]; then
        >&2 echo "$BASH_SOURCE:$BASH_LINENO: Could not find the compose.yaml file in: $repo_root"
        exit 1
    fi
    if which podman 2>&1 >/dev/null; then
        if podman compose --help 2>&1 >/dev/null; then
            COMPOSE_CMD="podman compose"
        else
            if ! which podman-compose 2>&1 >/dev/null; then
                uv pip install podman-compose  # maybe too helpful?
            fi
            COMPOSE_CMD="podman-compose"
        fi
    else
        COMPOSE_CMD="docker-compose"
    fi
    set -e
    env \
        HOST_CACHE_HUGGINGFACE="$(realpath $HOME/.cache/huggingface)" \
        HOST_CACHE_LLAMACPP="$(realpath $HOME/.cache/llama.cpp)" \
        $COMPOSE_CMD --file compose.yaml up --detach

    # TODO; status check with sleep cmd in loop?
else
    set -e    
fi
"$@"
