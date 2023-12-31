%dw 2.0
output application/json
---
{
  "TableName": "SearchLogs",
  "FilterExpression": "LastUpdated >= :val",
  "ExpressionAttributeValues": {
    ":val": {
      "S": (now() - |P10D|) as String {format: "yyyy-MM-dd'T'HH:mm:ss'Z'"}
    }
  },
  "Limit": 2,
  "ReturnConsumedCapacity": "TOTAL"
}