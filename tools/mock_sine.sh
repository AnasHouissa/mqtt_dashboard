#!/usr/bin/env bash
#
# Publish a smooth sine wave to an MQTT topic, one sample per interval.
# Great for watching the in-app live console or exercising the MQTT pipeline.
#
# Usage:
#   ./tools/mock_sine.sh [HOST] [TOPIC] [INTERVAL_SEC]
#
# Examples:
#   ./tools/mock_sine.sh 192.168.1.50 test/hello 1
#   ./tools/mock_sine.sh                      # defaults: localhost, test/hello, 1s
#
# Env overrides (optional):
#   PORT=1883 USER= PASS=                     # broker port / auth
#   OFFSET=50 AMPLITUDE=40 PERIOD=60          # value = OFFSET + AMPLITUDE*sin(2pi*t/PERIOD)
#   JSON=1                                    # publish {"value": N} instead of a bare number
#
set -euo pipefail

HOST="${1:-localhost}"
TOPIC="${2:-test/hello}"
INTERVAL="${3:-1}"

PORT="${PORT:-1883}"
OFFSET="${OFFSET:-50}"
AMPLITUDE="${AMPLITUDE:-40}"
PERIOD="${PERIOD:-60}"   # samples per full sine cycle

AUTH=()
[ -n "${USER:-}" ] && AUTH+=(-u "$USER")
[ -n "${PASS:-}" ] && AUTH+=(-P "$PASS")

command -v mosquitto_pub >/dev/null 2>&1 || {
  echo "mosquitto_pub not found. Install it: brew install mosquitto" >&2
  exit 1
}

echo "Publishing sine -> $HOST:$PORT  topic='$TOPIC'  every ${INTERVAL}s  (Ctrl-C to stop)"

t=0
while true; do
  v=$(awk -v t="$t" -v o="$OFFSET" -v a="$AMPLITUDE" -v p="$PERIOD" \
        'BEGIN { printf "%.2f", o + a * sin(2 * 3.14159265 * t / p) }')
  if [ "${JSON:-0}" = "1" ]; then
    msg="{\"value\": $v}"
  else
    msg="$v"
  fi
  mosquitto_pub -h "$HOST" -p "$PORT" "${AUTH[@]}" -t "$TOPIC" -m "$msg"
  t=$((t + 1))
  sleep "$INTERVAL"
done
