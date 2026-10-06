#!/bin/bash

# Default query if no argument is provided
DEFAULT_QUERY="SELECT order_id, customer_id, amount, status FROM demo.postgrestoicebergorders_ecommerce_public.orders ORDER BY order_id;"
QUERY="${1:-$DEFAULT_QUERY}"

echo "Executing Spark SQL Query: $QUERY"

docker run -i --rm \
  --user root \
  --network olake-network \
  apache/spark:3.5.0 /opt/spark/bin/spark-sql \
  --packages org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.5.0,org.apache.iceberg:iceberg-aws-bundle:1.5.0 \
  --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
  --conf spark.sql.catalog.demo=org.apache.iceberg.spark.SparkCatalog \
  --conf spark.sql.catalog.demo.type=rest \
  --conf spark.sql.catalog.demo.uri=http://iceberg-rest-catalog:8181 \
  --conf spark.sql.catalog.demo.io-impl=org.apache.iceberg.aws.s3.S3FileIO \
  --conf spark.sql.catalog.demo.warehouse=s3://warehouse/ \
  --conf spark.sql.catalog.demo.s3.endpoint=http://s3proxy:9000 \
  --conf spark.sql.catalog.demo.s3.path-style-access=true \
  --conf spark.hadoop.fs.s3a.access.key=admin \
  --conf spark.hadoop.fs.s3a.secret.key=password123 \
  --conf spark.hadoop.fs.s3a.endpoint=http://s3proxy:9000 \
  --conf spark.hadoop.fs.s3a.path.style.access=true \
  -e "$QUERY"
