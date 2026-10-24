#!/usr/bin/env bash
set -e

if [ -f /tmp/.windmill-env ]; then
    set -a
    . /tmp/.windmill-env
    set +a
fi

echo "[run.sh] uid=$(id -u) cwd=$(pwd)"
echo "[run.sh] DATABASE_URL=${DATABASE_URL:-<unset>}"
echo "[run.sh] BASE_URL=${BASE_URL:-<unset>}"
echo "[run.sh] DATA_PATH=${DATA_PATH:-/share/windmill}"

: "${DATA_PATH:=/share/windmill}"
mkdir -p "${DATA_PATH}"

export DATABASE_URL BASE_URL DATA_PATH

echo "[run.sh] starting windmill (upstream CMD: windmill, WORKDIR: /usr/src/app)"
exec windmill