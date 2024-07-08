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

    try:
        response = table.get_item(Key=key)
    except Exception as e:
        message = f"Error fetching item from table. \
            Table name: '{table_name}', Item key: {key}, Exception: {e}"
        return get_response(status=500, body={"message": message})

    attribute = "views_count"
    item = response.get("Item", None)
    if not item:
        item = key | {attribute: 0}
        table.put_item(Item=item)

    count = int(item.get(attribute) + 1)

    try:
        table.update_item(
            Key=key,
            UpdateExpression=f"SET {attribute} = :val",
            ExpressionAttributeValues={":val": count},
        )
    except Exception as e:
        message = f"Error updating item in table. \
            Table name: '{table_name}', Item key: {key}, \
                Attribute: {attribute}, Value: {count}, Exception: {e}"
        return get_response(status=500, body={"message": message})

    return get_response(status=200, body={"value": count})
