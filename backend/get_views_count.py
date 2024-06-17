import boto3
import json


def get_views_count(event, context):
    table_name = "avivilloz_views_count"
    key = {"id": 0}

    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table(table_name)

    try:
        response = table.get_item(Key=key)
        item = response.get("Item", {})
    except Exception as e:
        error_code = e.response["Error"]["Code"]
        if error_code == "ResourceNotFoundException":
            item = key | {"views_count": 0}
            table.put_item(Item=item)
        else:
            return {
                "statusCode": 500,
                "body": json.dumps(
                    {"message": "Error fetching views_count", "error_code": error_code}
                ),
            }

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
            "body": json.dumps({"message": "Error updating views_count"}),
        }

    return {"statusCode": 200, "body": {"value": str(count)}}
