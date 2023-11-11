%dw 2.5
input payload application/json
output application/json
---
{
  "ExclusiveStartKey": payload."LastEvaluatedKey",
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
