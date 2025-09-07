@isTest
private class FieldChangeEventTriggerHandler_Test {
    private static final Integer BULK_AMOUNT = 499;

    @isTest
    static void testafterInsertException() {
        try {
            TestUtility.THROW_TESTING_EXCEPTION = true;
            FieldChangeEventTriggerHandler handler = new FieldChangeEventTriggerHandler();
            handler.afterInsert();
            throw new TestUtility.FailedTestingException('GenericTestingException was not thrown in afterInsert');
        } catch(TestUtility.GenericTestingException e) {}
    }

    @isTest
    static void testSingleEventPublish() {
        TestMetadataFactory.createFieldChangeTrackingObjectsWithRelations();
        TestUtility.RUN_OBJECT_TRIGGERS = false;
        TestMetadataFactory.DataFactoryBundle metadata = TestMetadataFactory.createFieldChangeTrackingObjectsWithRelations();
        List<Field_Change_Tracking_Event__e> events = TestEventFactory.createFieldChanges(1).fieldChanges;

        Test.startTest();
        EventBus.publish(events);
        Test.stopTest();

        List<Field_Change__c> changes = [
            SELECT Id
            FROM Field_Change__c
        ];
        System.assertEquals(1, changes.size(),
                            'FieldChangeEventTriggerHandler_Test.testSingleEventPublish failed: ' +
                            'incorrect number of Field_Change__c records created');
        List<SObject> relations = Database.query('SELECT Id FROM ' + FieldChangeTestUtility.DEFAULT_RELATION_OBJECT_NAME);
        System.assertEquals(1, relations.size(),
                            'FieldChangeEventTriggerHandler_Test.testSingleEventPublish failed: ' +
                            'incorrect number of ' + FieldChangeTestUtility.DEFAULT_RELATION_OBJECT_NAME + ' records created');
    }

    @isTest
    static void testBulkEventPublish() {
        TestMetadataFactory.createFieldChangeTrackingObjectsWithRelations();
        TestUtility.RUN_OBJECT_TRIGGERS = false;
        TestMetadataFactory.DataFactoryBundle metadata = TestMetadataFactory.createFieldChangeTrackingObjectsWithRelations();
        List<Field_Change_Tracking_Event__e> events = TestEventFactory.createFieldChanges(BULK_AMOUNT).fieldChanges;
        
        Test.startTest();
        EventBus.publish(events);
        Test.stopTest();
        
        List<Field_Change__c> changes = [
            SELECT Id
            FROM Field_Change__c
        ];
        System.assertEquals(BULK_AMOUNT, changes.size(),
                            'FieldChangeEventTriggerHandler_Test.testBulkEventPublish failed: ' +
                            'incorrect number of Field_Change__c records created');
        List<SObject> relations = Database.query('SELECT Id FROM ' + FieldChangeTestUtility.DEFAULT_RELATION_OBJECT_NAME);
        System.assertEquals(BULK_AMOUNT, relations.size(),
                            'FieldChangeEventTriggerHandler_Test.testSingleEventPublish failed: ' +
                            'incorrect number of ' + FieldChangeTestUtility.DEFAULT_RELATION_OBJECT_NAME + ' records created');
    }
}