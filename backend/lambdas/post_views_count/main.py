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
    
    value = json.loads(event.get("body")).get("value")
    if value == None or type(value) != int:
        message = f"Error reading event input. Event: {event}."
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

    return get_response(status=200, body={"value": value})
