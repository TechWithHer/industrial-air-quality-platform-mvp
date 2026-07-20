import json
import io
import os

import boto3
import pandas as pd

s3 = boto3.client("s3")

PROCESSED_BUCKET = os.environ["PROCESSED_BUCKET"]


def lambda_handler(event, context):

    # Get uploaded file information from S3 event
    record = event["Records"][0]

    raw_bucket = record["s3"]["bucket"]["name"]
    raw_key = record["s3"]["object"]["key"]

    print(f"Processing {raw_bucket}/{raw_key}")

    # Download JSON from Raw bucket
    response = s3.get_object(
        Bucket=raw_bucket,
        Key=raw_key
    )

    data = json.loads(
        response["Body"].read().decode("utf-8")
    )

    item = data["data"]["items"][0]
    timestamp = item["timestamp"]
    readings = item["readings"]

    rows = []

    for region in ["north", "south", "east", "west", "central"]:

        rows.append({
            "timestamp": timestamp,
            "region": region,
            "psi": readings["psi_twenty_four_hourly"][region],
            "pm25": readings["pm25_twenty_four_hourly"][region],
            "pm10": readings["pm10_twenty_four_hourly"][region],
            "o3": readings["o3_eight_hour_max"][region],
            "no2": readings["no2_one_hour_max"][region]
        })

    df = pd.DataFrame(rows)

    # Convert DataFrame to Parquet
    buffer = io.BytesIO()

    df.to_parquet(
        buffer,
        engine="pyarrow",
        index=False
    )

    buffer.seek(0)

    parquet_key = raw_key.replace(".json", ".parquet")

    s3.put_object(
        Bucket=PROCESSED_BUCKET,
        Key=parquet_key,
        Body=buffer.getvalue(),
        ContentType="application/octet-stream"
    )

    print(f"Uploaded {parquet_key}")

    return {
        "statusCode": 200,
        "rows_processed": len(df)
    }