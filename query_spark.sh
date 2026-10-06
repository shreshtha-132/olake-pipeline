#!/usr/bin/env bash
set -e

QUERY=${1:-"SELECT count(*) FROM demo.postgresjob_ecommerce_ecommerce.orders;"}

echo "Executing Spark SQL Query: $QUERY"

docker run --rm -it \
  --network olake-network \
  --user root \
  -e AWS_REGION=us-east-1 \
  -e AWS_DEFAULT_REGION=us-east-1 \
  -e AWS_ACCESS_KEY_ID=admin \
  -e AWS_SECRET_ACCESS_KEY=password123 \
  apache/spark:3.5.0 \
  /opt/spark/bin/spark-sql \
  --packages org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.5.0,org.apache.iceberg:iceberg-aws-bundle:1.5.0 \
  --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
  --conf spark.sql.catalog.demo=org.apache.iceberg.spark.SparkCatalog \
  --conf spark.sql.catalog.demo.type=rest \
  --conf spark.sql.catalog.demo.uri=http://iceberg-rest-catalog:8181 \
  --conf spark.sql.catalog.demo.io-impl=org.apache.iceberg.aws.s3.S3FileIO \
  --conf spark.sql.catalog.demo.s3.endpoint=http://s3proxy:9000 \
  --conf spark.sql.catalog.demo.s3.path-style-access=true \
  --conf spark.sql.defaultCatalog=demo \
  -e "$QUERY"
