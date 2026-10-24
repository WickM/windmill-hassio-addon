#!/usr/bin/env bashio
set -e

if [ -f /tmp/.windmill-env ]; then
    set -a
    . /tmp/.windmill-env
    set +a
fi

echo "[run.sh] uid=$(id -u) cwd=$(pwd)"
echo "[run.sh] DATABASE_URL=${DATABASE_URL:-<unset>}"
echo "[run.sh] BASE_URL=${BASE_URL:-<unset>}"
echo "[run.sh] WM_WORKER_COUNT=${WM_WORKER_COUNT:-1}"
echo "[run.sh] DATA_PATH=${DATA_PATH:-/share/windmill}"

: "${WM_WORKER_COUNT:=1}"
: "${DATA_PATH:=/share/windmill}"
mkdir -p "${DATA_PATH}"

export DATABASE_URL BASE_URL WM_WORKER_COUNT DATA_PATH

cd /app 2>/dev/null || cd /

echo "[run.sh] starting windmill (upstream CMD: windmill, WORKDIR: /usr/src/app)"
exec windmill