#!/bin/bash
set -euo pipefail

if [[ ! -v LITELLM_PROXY_API_KEY || ! -v LITELLM_PROXY_API_BASE ]]; then
    >&2 echo "Run this script like this:"
    >&2 echo "  $ ./bin/local-model-enablement-wrapper ./scripts/test-litellm-proxy.sh"
    exit 1
fi

query_completions() {
    logfile="/tmp/$(echo $1 | tr -d '/').log"
    if [ -e "$logfile" ]; then
        rm "$logfile"
    fi
    set -x
    curl -s -X POST "$LITELLM_PROXY_API_BASE/v1/completions" \
         -H "Content-Type: application/json" \
         -H "Authorization: Bearer $LITELLM_PROXY_API_KEY" \
         -d '{"model": "'"$1"'", "role": "user", "prompt": "'"$2"'"}' | tee $logfile | jq '.choices[0].text'
    echo "Full log found in: $logfile"
}

query_chat() {
    logfile="/tmp/$(echo $1 | tr -d '/').log"
    if [ -e "$logfile" ]; then
        rm "$logfile"
    fi
    set -x
    curl -s -X POST "$LITELLM_PROXY_API_BASE/v1/chat/completions" \
         -H "Content-Type: application/json" \
         -H "Authorization: Bearer $LITELLM_PROXY_API_KEY" \
         -d '{"model": "'"$1"'", "messages": [{"role": "user", "content": "'"$2"'"}]' | tee $logfile | jq '.choices[0].text'
    echo "Full log found in: $logfile"
}
set -x
# If the proper template is not injected by the litellm proxy, the query below is subject
# to infinite recursion. You can test this by either:
#   - editing ../env-litellm-patched/host-litellm.py
#   - or, change the endpoint to point directly at llama-swap (port 8686)
query_completions "${1:-local-qwq-32b}" "Answer succinctly by completing the sentence: The capital of France is"
