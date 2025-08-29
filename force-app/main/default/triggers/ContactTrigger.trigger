trigger ContactTrigger on Contact (before update) {
    if(!(Test.isRunningTest() && !TestUtility.RUN_OBJECT_TRIGGERS)) {
        ContactTriggerHandler handler = new ContactTriggerHandler();
        if (Trigger.isBefore) {
            if (Trigger.isUpdate) {
                handler.beforeUpdate();
            }
        }
    }
}