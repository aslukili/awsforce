%dw 2.0

output application/json
---
{
    TableName: "search-logs",
    Key: {
        term: {
            S: "Product X"
        },
        "search-ts": {
            S: "2023-10-30T14:20:50Z"
        }
    },
    ProjectionExpression: "#src, #dt",
    ExpressionAttributeNames: {
        '#src': 'search-result-count',
        '#dt': 'device-type'
    },
    ConsistentRead: true,
    ReturnConsumedCapacity: "TOTAL"
}