public class DynamoDBUtil {
    public DynamoDBUtil() {

    }


    // TODO: this method should take two strings as arguments to get one item... (dynamodb stuff)
    public static void getItem(){
            // dw to build the request body:
        DataWeave.Script dwscript = new DataWeaveScriptResource.dynamoGetItemRequestBuilder();
        DataWeave.Result dwresult = dwscript.execute(new Map<String, Object>());



        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DYNAMODB/');
        req.setMethod('POST');
        req.setHeader('Content-type', 'application/x-amz-json-1.0');
        req.setHeader('X-Amz-Target', 'DynamoDB_20120810.GetItem');
        req.setBody(dwresult.getValueAsString());


        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
    }

    public static void syncScanLastModifiedRecords() {
        DataWeave.Script dwscript = new DataWeaveScriptResource.dynamoScanLastUpdatedRequestBuilder();
        DataWeave.Result dwresult = dwscript.execute(new Map<String, Object>());

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DYNAMODB/');
        req.setMethod('POST');
        req.setHeader('Content-type', 'application/x-amz-json-1.0');
        req.setHeader('X-Amz-Target', 'DynamoDB_20120810.Scan');
        req.setBody(dwresult.getValueAsString());


        Http http = new Http();
        HTTPResponse res = http.send(req);
        // take the response give it to a dataweave to transfer it to Search Log Object
        System.debug(res.getBody());
    }


}