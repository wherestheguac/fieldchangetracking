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
            if (!Test.isRunningTest()) {
            	Logger.exception('Exception in apex class: ContactTriggerHandler.ContactTriggerHandler', e);
            } else {
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
            
            if (!Test.isRunningTest()) {
                Logger.info('FieldChangeQueueable enqueued in ContactTriggerHandler.beforeUpdate', jobId);
            }
        } catch(Exception e) {
            if (!Test.isRunningTest()) {
            	Logger.exception('Exception in apex class: ContactTriggerHandler.beforeUpdate', e);
            } else {
                throw e;
            }
        }
    }
}