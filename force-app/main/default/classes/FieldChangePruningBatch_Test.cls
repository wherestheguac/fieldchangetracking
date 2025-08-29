@isTest
private class FieldChangePruningBatch_Test {
    private static final Integer BULK_AMOUNT = 200;

    @isTest
    static void testFieldChangePruning() {
        TestUtility.RUN_OBJECT_TRIGGERS = false;
        TestDataFactory.DataFactoryBundle data = TestDataFactory.createFieldChangesWithRelationsToPrune(BULK_AMOUNT);
        Test.startTest();
        FieldChangePruningBatch b = new FieldChangePruningBatch(FieldChangeTestUtility.DAYS_TO_PRUNE);
        Database.executeBatch(b);
        Test.stopTest();
        System.assertEquals(0, [SELECT COUNT() FROM Field_Change__c],
            'FieldChangePruningBatch_Test.testFieldChangePruning failed: ' +
            'incorrect number of Field_Change__c records remaining');
        System.assertEquals(0, Database.query('SELECT id FROM ' + FieldChangeTestUtility.DEFAULT_RELATION_OBJECT_NAME).size(),
            'FieldChangePruningBatch_Test.testFieldChangePruning failed: ' +
            'incorrect number of ' + FieldChangeTestUtility.DEFAULT_RELATION_OBJECT_NAME + ' records remaining');
    }
}