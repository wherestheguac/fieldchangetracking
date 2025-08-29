@isTest
private class FieldChangePruningScheduler_Test {

    @isTest
    static void testFieldChangeBatchScheduling () {
        TestUtility.RUN_OBJECT_TRIGGERS = false;
        Test.startTest();
        FieldChangePruningScheduler scheduler = new FieldChangePruningScheduler();
        System.schedule('Test Job', TestUtility.DEFAULT_CRON_EXPRESSION, scheduler);
        Test.stopTest();
        Integer scheduledJobCount = [
            SELECT COUNT()
            FROM AsyncApexJob
            WHERE ApexClass.Name = :FieldChangePruningBatch.class.getName()
            AND JobType = 'BatchApex'
        ];
        System.assertEquals(1, scheduledJobCount,
            'FieldChangePruningScheduler_Test.testFieldChangeBatchScheduling failed: ' +
            'incorrect number of CronTrigger records created');
    }
}