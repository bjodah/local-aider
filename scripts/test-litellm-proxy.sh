#!/bin/bash
set -euo pipefail

if [[ ! -v LITELLM_PROXY_API_KEY || ! -v LITELLM_PROXY_API_BASE ]]; then
    >&2 echo "Run this scripts like this:"
    >&2 echo "  $ ./bin/local-model-enablement-wrapper ./scripts/test-litellm-proxy.sh"
    exit 1
fi

query() {
    logfile="$(echo $1 | tr -d '/').log"
    if [ -e "$logfile" ]; then
        rm -i "$logfile"
    fi
    curl -s -X POST "$LITELLM_PROXY_API_BASE/v1/completions" \
         -H "Content-Type: application/json" \
         -H "Authorization: Bearer $LITELLM_PROXY_API_KEY" \
         -d '{"model": "'"$1"'", "role": "user", "prompt": "'"$2"'"}' | tee $logfile | jq '.choices[0].text'
    echo "Full log found in: $logfile"
}

set -x
# If the proper template is not injected by the litellm proxy, the query below is subject
# to infinite recursion. You can test this by either:
#   - editing ../env-litellm-patched/host-litellm.py
#   - or, change the endpoint to point directly at llama-swap (port 8686)
query "local-qwq-32b" "Answer succintly by completing the sentence: The capital of France is"

