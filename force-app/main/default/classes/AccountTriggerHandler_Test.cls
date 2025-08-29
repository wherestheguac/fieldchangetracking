@isTest
private class AccountTriggerHandler_Test {
    private static final Integer BULK_AMOUNT = 1000;
    
    @isTest
    static void testConstructorException() {
        try {
            TestUtility.THROW_TESTING_EXCEPTION = true;
        	AccountTriggerHandler handler = new AccountTriggerHandler();
            throw new TestUtility.FailedTestingException('GenericTestingException was not thrown in constructor');
        } catch(TestUtility.GenericTestingException e) {}
    }
    
    @isTest
    static void testBeforeUpdateException() {
        try {
        	AccountTriggerHandler handler = new AccountTriggerHandler();
            TestUtility.THROW_TESTING_EXCEPTION = true;
            handler.beforeUpdate();
            throw new TestUtility.FailedTestingException('GenericTestingException was not thrown in beforeUpdate');
        } catch(TestUtility.GenericTestingException e) {}
    }

    @isTest
    static void testEnqueueFieldChangeJobs() {
        TestUtility.EVENT_BUS_PUBLISH = false;
        List<Account> accounts = TestDataFactory.createAccounts(BULK_AMOUNT).accounts;
        for (Integer i=0; i<accounts.size(); i++) {
            accounts[i].Name = 'New Account Name' + i.toString();
            accounts[i].AccountNumber = '1236234' + i.toString();
        }
        Test.startTest();
        update accounts;
        Test.stopTest();
        List<AsyncApexJob> jobs = [
            SELECT Id
            FROM AsyncApexJob
        ];
        System.assertEquals(BULK_AMOUNT/200, jobs.size(),
                            'private class AccountTriggerHandler_Test.testEnqueueFieldChangeJobs failed: ' +
                            'incorrect number of jobs enqueued');
    }
}