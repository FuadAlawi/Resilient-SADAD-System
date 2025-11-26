#!/usr/bin/env bash
set -euo pipefail

# Demo script to exercise Chaos Monkey endpoints in 'chaos' profile.
# Requires the app to be running with: mvn spring-boot:run -Dspring-boot.run.profiles=chaos

APP_URL="${APP_URL:-http://localhost:8080}"

echo "[info] Verifying health..."
curl -fsS "$APP_URL/api/v1/healthz" >/dev/null && echo "OK"

echo "[info] Showing current Chaos Monkey status"
curl -fsS "$APP_URL/actuator/chaosmonkey" | jq . || curl -fsS "$APP_URL/actuator/chaosmonkey"

echo "[info] Triggering latency assault by calling an endpoint (restController watcher)"
# The echo endpoint will experience randomized latency when chaos profile is active
curl -s -X POST "$APP_URL/api/v1/payments/echo" -H 'Content-Type: application/json' -d '{"demo":true}' | sed -e 's/.*/(response redacted)/'

echo "[info] Check Prometheus metrics are exposed"
curl -fsS "$APP_URL/actuator/prometheus" >/dev/null && echo "metrics OK"

echo "[done] Chaos Monkey demo complete"
