import boto3
import json
import os


def get_response(status: int, body: dict):
    return {
        "statusCode": status,
        "body": json.dumps(body),
        "headers": {"Access-Control-Allow-Origin": "*"},
    }


def handler(event, context):
    table_name = os.environ["table_name"]
    key = {"id": 0}

    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table(table_name)

    value = event.get("value", None)
    if value == None:
        message = f"Integer value required. No value provided."
        return get_response(status=500, body={"message": message})

    try:
        table.update_item(
            Key=key,
            UpdateExpression="SET views_count = :val",
            ExpressionAttributeValues={":val": value},
        )
    except Exception as e:
        message = f"Error updating views_count. Exception: {e}"
        return get_response(status=500, body={"message": message})

    return get_response(status=200, body={"value": str(value)})
