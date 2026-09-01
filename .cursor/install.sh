#!/usr/bin/env bash
# Idempotent setup for the Documentarian docs environment.
set -euo pipefail

cd "$(dirname "$0")/.."

# MkDocs runs in an isolated virtualenv. Ubuntu ships venv separately from python3.
if ! python3 -c "import venv, ensurepip" >/dev/null 2>&1; then
  sudo apt-get update -qq
  sudo apt-get install -y -qq python3.12-venv
fi

if [ ! -x ".venv/bin/python" ]; then
  python3 -m venv .venv
fi

./.venv/bin/python -m pip install --upgrade pip --quiet
./.venv/bin/pip install --quiet -r requirements.txt

echo "Documentarian environment ready. Run: ./.venv/bin/mkdocs serve"
