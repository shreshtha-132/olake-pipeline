#!/bin/bash

# Connect to Spark SQL running in a Docker container to query the Iceberg REST Catalog
# The crucial fixes applied here:
# 1. Run as root (--user root) to fix Ivy cache permission denied.
# 2. Include iceberg-aws-bundle to fix missing S3Exception class.
# 3. Use s3proxy as endpoint.

docker run -it --rm \
  --user root \
  --network olake-network \
  apache/spark:3.5.0 /opt/spark/bin/spark-sql \
  --packages org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.5.0,org.apache.iceberg:iceberg-aws-bundle:1.5.0 \
  --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
  --conf spark.sql.catalog.iceberg=org.apache.iceberg.spark.SparkCatalog \
  --conf spark.sql.catalog.iceberg.type=rest \
  --conf spark.sql.catalog.iceberg.uri=http://iceberg-rest-catalog:8181 \
  --conf spark.sql.catalog.iceberg.io-impl=org.apache.iceberg.aws.s3.S3FileIO \
  --conf spark.sql.catalog.iceberg.warehouse=s3://warehouse/ \
  --conf spark.sql.catalog.iceberg.s3.endpoint=http://s3proxy:9000 \
  --conf spark.sql.catalog.iceberg.s3.path-style-access=true \
  --conf spark.hadoop.fs.s3a.access.key=admin \
  --conf spark.hadoop.fs.s3a.secret.key=password123 \
  --conf spark.hadoop.fs.s3a.endpoint=http://s3proxy:9000 \
  --conf spark.hadoop.fs.s3a.path.style.access=true
