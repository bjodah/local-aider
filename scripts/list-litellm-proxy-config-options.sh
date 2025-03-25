#!/bin/bash
set -euo pipefail

if [[ ! -v LITELLM_PROXY_API_KEY || ! -v LITELLM_PROXY_API_BASE ]]; then
    >&2 echo "Run this script like this:"
    >&2 echo "  $ ./bin/local-model-enablement-wrapper ./scripts/test-litellm-proxy.sh"
    exit 1
fi

query_config() {
    set -x
    # https://docs.litellm.ai/docs/proxy/configs
    curl -s -X GET "$LITELLM_PROXY_API_BASE/#/config.yaml" \
         -H "Authorization: Bearer $LITELLM_PROXY_API_KEY"
}

query_config
