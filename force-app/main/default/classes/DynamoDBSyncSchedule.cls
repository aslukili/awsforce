public class DynamoDBSyncSchedule implements Schedulable {
    public void execute(SchedulableContext ctx) {
        DynamoDBUtil syncJob = new DynamoDBUtil();
        ID jobID = System.enqueueJob(syncJob);
    }
}