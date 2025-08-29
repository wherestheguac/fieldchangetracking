trigger AccountTrigger on Account (before insert, before update) {
    if(!(Test.isRunningTest() && !TestUtility.RUN_OBJECT_TRIGGERS)) {
        AccountTriggerHandler handler = new AccountTriggerHandler();
        if (Trigger.isBefore) {
            if (Trigger.isUpdate) {
                handler.beforeUpdate();
            }
        }
    }
}