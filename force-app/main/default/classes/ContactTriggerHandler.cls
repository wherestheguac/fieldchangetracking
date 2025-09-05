public class ContactTriggerHandler extends TriggerHandler {
    private Map<Id,Contact> oldContactMap;
    private Map<Id,Contact> newContactMap;
    
    public ContactTriggerHandler() {
        try {
            if (Test.isRunningTest() && TestUtility.THROW_TESTING_EXCEPTION) {
                throw new TestUtility.GenericTestingException();
            }
            
            this.oldContactMap = (Map<Id,Contact>) Trigger.oldMap;
            this.newContactMap = (Map<Id,Contact>) Trigger.newMap;
            
        } catch(Exception e) {
            NebulaLoggerWrapper.log(
                NebulaLoggerWrapper.Method.RUN_EXCEPTION,
                'Exception in apex class: ContactTriggerHandler.ContactTriggerHandler',
                NebulaLoggerWrapper.DataType.TYPE_EXCEPTION,
                e
            );
            if (Test.isRunningTest()) {
                throw e;
            }
        }
    }
    
    public override void beforeUpdate() {
        try {
            if (Test.isRunningTest() && TestUtility.THROW_TESTING_EXCEPTION) {
                throw new TestUtility.GenericTestingException();
            }
            
            FieldChangeQueueable fieldTracking = new FieldChangeQueueable('Contact', oldContactMap, newContactMap);
            Id jobId = System.enqueueJob(fieldTracking, 0);
            
            NebulaLoggerWrapper.log(
                NebulaLoggerWrapper.Method.RUN_INFO,
                'FieldChangeQueueable enqueued in ContactTriggerHandler.beforeUpdate',
                NebulaLoggerWrapper.DataType.TYPE_ID,
                jobId
            );
        } catch(Exception e) {
            NebulaLoggerWrapper.log(
                NebulaLoggerWrapper.Method.RUN_EXCEPTION,
                'Exception in apex class: ContactTriggerHandler.beforeUpdate',
                NebulaLoggerWrapper.DataType.TYPE_EXCEPTION,
                e
            );
            if (Test.isRunningTest()) {
                throw e;
            }
        }
    }
}