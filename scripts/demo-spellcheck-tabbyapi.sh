#!/bin/bash

# This script will run the same task as in
# https://github.com/bjodah/local-aider/pull/2#issue-2938880690
# but instead of using llama.cpp+llama-swap, we will uses exl2 quant of only qwq-32b via tabbyapi:

set -euxo pipefail
if [ ! -d /tmp/local-aider-55728 ]; then
    git clone github.com:bjodah/local-aider /tmp/local-aider-55728
fi
cd /tmp/local-aider-55728
git reset --hard 5572801b9fde7c7d67d34d6cfa9804d67dc3f799
git clean -xfd
env LOCAL_AIDER_SKIP_HEALTH_CHECK=1 \
    local-model-enablement-wrapper contaider --model litellm_proxy/local-tabby-qwq-32b-editor --yes-always .
