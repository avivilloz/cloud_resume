import boto3
import json
import os


def handler(event, context):
    table_name = os.environ["table_name"]
    key = {"id": 0}

    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table(table_name)

    try:
        response = table.get_item(Key=key)
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps(
                {"message": "Error fetching views_count", "exception": e}
            ),
        }

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
        return {
            "statusCode": 500,
            "body": json.dumps(
                {"message": "Error updating views_count", "exception": e}
            ),
        }

    return {"statusCode": 200, "body": {"value": str(count)}}
