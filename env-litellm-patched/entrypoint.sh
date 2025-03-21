#!/bin/bash
source /opt/venv/bin/activate
export PYTHONPATH=/litellm-patched
exec "$@"
