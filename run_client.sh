#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [ -x "$SCRIPT_DIR/build/linux-release/bin/otclient" ]; then
    exec "$SCRIPT_DIR/build/linux-release/bin/otclient"
elif [ -x "$SCRIPT_DIR/otclient" ]; then
    exec "$SCRIPT_DIR/otclient"
else
    echo "Client não encontrado."
    echo "Esperado em:"
    echo "  - $SCRIPT_DIR/build/linux-release/bin/otclient"
    echo "  - $SCRIPT_DIR/otclient"
    exit 1
fi
