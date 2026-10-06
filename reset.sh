#!/usr/bin/env bash
set -e

echo "=== Stopping Lakehouse stack and removing volumes ==="
docker compose down -v --remove-orphans 2>/dev/null || true
docker rm -f postgres-source s3proxy s3proxy-provision iceberg-rest-catalog 2>/dev/null || true

echo "=== Purging OLake & Temporal containers and networks ==="
docker rm -f $(docker ps -a -q --filter "name=temporal" --filter "name=olake") 2>/dev/null || true
docker network rm olake-network 2>/dev/null || true
docker volume prune -f

echo "=== System completely cleaned! ==="
echo "State restored to post-git-clone baseline."
echo "You can now follow Step 1 onwards in README.md to start manually."
