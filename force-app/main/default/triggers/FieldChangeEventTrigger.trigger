trigger FieldChangeEventTrigger on Field_Change_Tracking_Event__e (after insert) {
    if(!(Test.isRunningTest() && !TestUtility.RUN_EVENT_TRIGGERS)) {
        if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                FieldChangeEventTriggerHandler handler = new FieldChangeEventTriggerHandler();
                handler.afterInsert();
            }
        }
    }
}