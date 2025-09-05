public class AccountTriggerHandler extends TriggerHandler {
    private Map<Id,Account> oldAccountMap;
    private Map<Id,Account> newAccountMap;
    
    public AccountTriggerHandler () {
        try {
            if (Test.isRunningTest() && TestUtility.THROW_TESTING_EXCEPTION) {
                throw new TestUtility.GenericTestingException();
            }
            
            this.oldAccountMap = (Map<Id,Account>) Trigger.oldMap;
            this.newAccountMap = (Map<Id,Account>) Trigger.newMap;
            
        } catch(Exception e){
            NebulaLoggerWrapper.log(
                NebulaLoggerWrapper.Method.RUN_EXCEPTION,
                'Exception in apex class: AccountTriggerHandler.AccountTriggerHandler',
                NebulaLoggerWrapper.DataType.TYPE_EXCEPTION,
                e
            );
        }
    }
    
    public override void beforeUpdate() {
        try {
            if (Test.isRunningTest() && TestUtility.THROW_TESTING_EXCEPTION) {
                throw new TestUtility.GenericTestingException();
            }
            FieldChangeQueueable fieldTracking = new FieldChangeQueueable('Account', oldAccountMap, newAccountMap);
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
                'Exception in apex class: AccountTriggerHandler.beforeUpdate',
                NebulaLoggerWrapper.DataType.TYPE_EXCEPTION,
                e
            );
        }
    }
}