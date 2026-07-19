import json
import os
from datetime import datetime

import boto3
import requests

s3 = boto3.client("s3")

BUCKET = os.environ["RAW_BUCKET"]

NEA_URL = (
    "https://api-open.data.gov.sg/v2/real-time/api/psi"
)


def lambda_handler(event, context):

    response = requests.get(NEA_URL, timeout=10)

    response.raise_for_status()

    data = response.json()

    timestamp = datetime.utcnow()

    key = (
        f"year={timestamp.year}/"
        f"month={timestamp.month:02}/"
        f"day={timestamp.day:02}/"
        f"{timestamp.isoformat()}.json"
    )

    s3.put_object(
        Bucket=BUCKET,
        Key=key,
        Body=json.dumps(data),
        ContentType="application/json",
    )

    return {
        "statusCode": 200,
        "message": "Data stored successfully",
        "key": key,
    }