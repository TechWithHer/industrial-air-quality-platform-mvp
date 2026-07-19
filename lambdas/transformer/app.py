import boto3
import json
import os
from datetime import datetime

s3 = boto3.client("s3")

PROCESSED_BUCKET = os.environ["PROCESSED_BUCKET"]


def lambda_handler(event, context):

    record = event["Records"][0]

    source_bucket = record["s3"]["bucket"]["name"]

    source_key = record["s3"]["object"]["key"]

    response = s3.get_object(
        Bucket=source_bucket,
        Key=source_key
    )

    data = json.loads(response["Body"].read())

    data["processed_at"] = datetime.utcnow().isoformat()

    s3.put_object(
        Bucket=PROCESSED_BUCKET,
        Key=source_key,
        Body=json.dumps(data),
        ContentType="application/json"
    )

    return {
        "statusCode": 200,
        "message": "Transformation completed"
    }
