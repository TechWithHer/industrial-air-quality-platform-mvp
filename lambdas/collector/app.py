import json
import os
import urllib.request

from datetime import datetime

import boto3

s3 = boto3.client("s3")

BUCKET = os.environ["RAW_BUCKET"]

NEA_URL = "https://api-open.data.gov.sg/v2/real-time/api/psi"


def lambda_handler(event, context):

    # Fetch data from NEA API
    with urllib.request.urlopen(NEA_URL) as response:
        data = json.loads(response.read().decode("utf-8"))

    # Create partitioned S3 key
    timestamp = datetime.utcnow()

    key = (
        f"year={timestamp.year}/"
        f"month={timestamp.month:02}/"
        f"day={timestamp.day:02}/"
        f"{timestamp.isoformat()}.json"
    )

    # Upload JSON to S3
    s3.put_object(
        Bucket=BUCKET,
        Key=key,
        Body=json.dumps(data),
        ContentType="application/json",
    )

    print(f"Uploaded {key}")

    return {
        "statusCode": 200,
        "message": "Data stored successfully",
        "key": key,
    }