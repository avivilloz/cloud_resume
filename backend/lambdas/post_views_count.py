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

    attribute = "views_count"

    try:
        table.update_item(
            Key=key,
            UpdateExpression=f"SET {attribute} = :val",
            ExpressionAttributeValues={":val": value},
        )
    except Exception as e:
        message = f"Error updating item in table. \
            Table name: '{table_name}', Item key: {key}, \
                Attribute: {attribute}, Value: {value}, Exception: {e}"
        return get_response(status=500, body={"message": message})

    return get_response(status=200, body={"value": value})
