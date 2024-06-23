import boto3
import json
import os


def get_response(status: int, body: dict):
    return {
        "statusCode": status,
        "headers": {"Access-Control-Allow-Origin": "*"},
        "body": json.dumps(body),
    }


def handler(event, context):
    table_name = os.environ["table_name"]
    key = {"id": 0}

    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table(table_name)

    try:
        response = table.get_item(Key=key)
    except Exception as e:
        message = f"Error fetching views_count. Exception: {e}"
        return get_response(status=500, body={"message": message})

    item = response.get("Item", None)
    if not item:
        item = key | {"views_count": 0}
        table.put_item(Item=item)

    count = item.get("views_count") + 1

    try:
        table.update_item(
            Key=key,
            UpdateExpression="SET views_count = :val",
            ExpressionAttributeValues={":val": count},
        )
    except Exception as e:
        message = f"Error updating views_count. Exception: {e}"
        return get_response(status=500, body={"message": message})

    return get_response(status=200, body={"value": str(count)})
