@isTest
private class FieldChangeEventCallback_Test {

    @isTest
    static void testGetRetryCounter() {
        FieldChangeEventCallback callback = new FieldChangeEventCallback(null);
        callback.getRetryCounter();
    }
    
    @isTest
    static void testGetUuidMap() {
        FieldChangeEventCallback callback = new FieldChangeEventCallback(null);
        callback.getUuidMap();
    }
    
    @IsTest
    static void testFieldChangeEventSuccessCallback() {
        TestUtility.RUN_EVENT_TRIGGERS = false;
        Test.startTest();
        TestEventFactory.DataFactoryBundle data = TestEventFactory.createFieldChanges(1);
        FieldChangeEventCallback callback = new FieldChangeEventCallback(data.fieldChangeEventsUuidMap);
        EventBus.publish(data.fieldChanges, callback);
        Test.stopTest();
        Integer eventCount = Integer.valueOf(TestUtility.globalVariablesValueMap.get(FieldChangeTestUtility.EVENT_COUNT_CUSTOM_SETTING_NAME));
        System.assertEquals(1, eventCount,
                    'FieldChangeEventCallback_Test.testFieldChangeEventSuccessCallback failed: ' +
                    'incorrect number of Field_Change_Tracking_Event__e events created');

    }
    
    @IsTest
    static void testFieldChangeEventFailureCallback() {
        TestUtility.RUN_EVENT_TRIGGERS = false;
        Test.startTest();
        TestEventFactory.DataFactoryBundle data = TestEventFactory.createFieldChanges(1);
        FieldChangeEventCallback callback = new FieldChangeEventCallback(data.fieldChangeEventsUuidMap);
        EventBus.publish(data.fieldChanges, callback);
        Test.getEventBus().fail();
        Test.getEventBus().fail();
        Test.getEventBus().fail();
        Test.stopTest();
        Integer eventCount = Integer.valueOf(TestUtility.globalVariablesValueMap.get(FieldChangeTestUtility.EVENT_COUNT_CUSTOM_SETTING_NAME));
        System.assertEquals(0, eventCount,
                    'FieldChangeEventCallback_Test.testFieldChangeEventFailureCallback failed: ' +
                    'incorrect number of Field_Change_Tracking_Event__e events created');

    }
}