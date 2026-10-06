#!/usr/bin/env bash
set -e

echo "=== Stopping Lakehouse stack and pruning volumes ==="
docker compose down -v 2>/dev/null || true
docker rm -f postgres-source s3proxy s3proxy-provision iceberg-rest-catalog 2>/dev/null || true

echo "=== Purging OLake & Temporal containers ==="
docker rm -f $(docker ps -a -q --filter "name=temporal" --filter "name=olake") 2>/dev/null || true
docker volume prune -f

echo "=== Starting OLake UI Engine ==="
curl -sSL https://raw.githubusercontent.com/datazip-inc/olake-ui/master/docker-compose-v1.yml | docker compose -f - up -d

echo "=== Starting Lakehouse Infrastructure ==="
docker compose up -d

echo "=== Waiting for PostgreSQL and S3 setup (5s) ==="
sleep 5

echo "=== Verifying PostgreSQL Seed Data ==="
docker exec -it postgres-source psql -U postgres -d ecommerce -c "SELECT count(*) FROM ecommerce.orders;"

echo "=== System Ready! Go to http://localhost:8000 ==="
