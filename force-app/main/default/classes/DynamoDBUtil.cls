public class DynamoDBUtil implements Queueable {
    private String LastEvaluatedKey;

    public DynamoDBUtil(String lastEvaluatedKey) {
        this.LastEvaluatedKey = lastEvaluatedKey;
    }
    public DynamoDBUtil() {

    }

    public void execute(QueueableContext context) {
        if (this.LastEvaluatedKey != null) {
            DynamoDBUtil.syncScanLastModifiedRecords(this.LastEvaluatedKey);
            return;
        }

        System.debug('its null');
        DynamoDBUtil.syncScanLastModifiedRecords();
    }

    @future(callout=true)
    public static void syncScanLastModifiedRecords(String lastEvaluatedKey){
        // TODO: create new dw script to build the request with the appropriate elements
        System.debug(lastEvaluatedKey);
        DataWeave.Script dwscript = new DataWeaveScriptResource.dynamoScanLastUpdatedRequestWithLastEvaluatekKeyBuilder();
        DataWeave.Result dwresult = dwscript.execute(new Map<String, Object>{'payload' => lastEvaluatedKey});
        
        System.debug('here');

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DYNAMODB/');
        req.setMethod('POST');
        req.setHeader('Content-type', 'application/x-amz-json-1.0');
        req.setHeader('X-Amz-Target', 'DynamoDB_20120810.Scan');
        req.setBody(dwresult.getValueAsString());


        Http http = new Http();
        HTTPResponse res = http.send(req);
    

        if(res.getStatusCode() == 200){
            System.debug('heeeeee');
            DynamoDBUtil.mapAndSaveResponseObjects(res.getBody());
            DynamoDBUtil.checkLastEvaluatedKeyRecursively(res.getBody());
        } else {
            System.debug('an error occured!');
            return;
        }
    }

    @future(callout=true)
    public static void syncScanLastModifiedRecords() {
        // call the dataweave script that builds the request body, 
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
    

        if(res.getStatusCode() == 200){
            DynamoDBUtil.mapAndSaveResponseObjects(res.getBody()); // save records to db
            DynamoDBUtil.checkLastEvaluatedKeyRecursively(res.getBody()); 
        } else {
            System.debug('an error occured!');
            return;
        }
    }

    public static void checkLastEvaluatedKeyRecursively(String httpResponseBody ){
        // 1- Examine the low-level Query result:
        //  If the result contains a LastEvaluatedKey element and it's non-null, proceed to step 2.
        //  If there is not a LastEvaluatedKey in the result, there are no more items to be retrieved.
        // 2- Construct a new Query request, with the same parameters as the previous one. However, this time, take the LastEvaluatedKey value from step 1 and use it as the ExclusiveStartKey parameter in the new Query request.
        // 3- Run the new Query request.
        // 4- Go to step 1.

        // call syncScanLastModifiedRecords with LastEvaluatedKey if it exists and not null
        Map<String, Object> responseBodyDeserialized = (Map<String, Object>) JSON.deserializeUntyped(httpResponseBody);
        
        if(responseBodyDeserialized.containsKey('LastEvaluatedKey') & responseBodyDeserialized.get('LastEvaluatedKey') != null){
            Map<String, Object> lastEvaluatedKeyFromResult = new Map<String, Object>{'LastEvaluatedKey' => responseBodyDeserialized.get('LastEvaluatedKey')};
            System.debug(lastEvaluatedKeyFromResult + 'line 101');

            
            DynamoDBUtil syncJob = new DynamoDBUtil(JSON.serialize(lastEvaluatedKeyFromResult));
            ID jobID = System.enqueueJob(syncJob);
            System.debug('started new job sync');
            return;
            // this.syncScanLastModifiedRecords(JSON.serialize(lastEvaluatedKeyFromResult));
        } 
    }

    public static void mapAndSaveResponseObjects(String httpResponseBody){
        // take the response give it to a dataweave to transfer it to Search Log Object only if response status code is 200
        DataWeave.Script dwMapperScript = new DataWeaveScriptResource.dynamoScanResponseToSObject();
        // dw script takes response json as parameter 
        // and returns a List of Search_Log__c objects
        DataWeave.Result dwMapperResult = dwMapperScript.execute(new Map<String, Object>{'scan' => httpResponseBody});

        // persist the result to the database.
        if(dwMapperResult.getValue() instanceof List<Search_Log__c>){
            List<Search_Log__c> records = (List<Search_Log__c>) dwMapperResult.getValue();
        insert records;
        }
        
    } 
}