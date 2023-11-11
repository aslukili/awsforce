public class DynamoDBBatchSync implements Database.Batchable<SObject> {
    public DynamoDBBatchSync() {

    }
    public Database.QueryLocator start(Database.BatchableContext context) {
        // Return the query locator to identify the records to be processed
        System.debug('start');
        return new List<Object>();
    }

    public void execute(Database.BatchableContext context, List<Object> scope) {
        System.debug('hereeee');
        DynamoDBUtil dbu = new DynamoDBUtil();
        dbu.syncScanLastModifiedRecords();
    }
    public void finish(Database.BatchableContext context) {
        // Perform any post-processing operations
    }
}
