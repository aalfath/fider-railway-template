#!/bin/sh
# Start Fider on Railway: wait for Postgres, run the migrations, then serve.
set -e
cd /app

# Uploaded images and logos stay in Postgres (Fider's default "sql" blob storage),
# so the app container itself keeps no state.
export BLOB_STORAGE="${BLOB_STORAGE:-sql}"
export LOG_STRUCTURED="${LOG_STRUCTURED:-true}"

# Postgres can still be starting on the first deploy: retry the migrations for ~2 minutes.
i=0
until ./fider migrate; do
  i=$((i + 1))
  if [ "$i" -ge 24 ]; then
    echo "start.sh: migrations still failing after $i attempts, giving up" >&2
    exit 1
  fi
  echo "start.sh: database not ready (attempt $i), retrying in 5s" >&2
  sleep 5
done

exec ./fider
