@isTest
private class ContactTriggerHandler_Test {
    private static final Integer BULK_AMOUNT = 1000;
    
    @isTest
    static void testConstructorException() {
        try {
            TestUtility.THROW_TESTING_EXCEPTION = true;
        	ContactTriggerHandler handler = new ContactTriggerHandler();
            throw new TestUtility.FailedTestingException('GenericTestingException was not thrown in constructor');
        } catch(TestUtility.GenericTestingException e) {}
    }
    
    @isTest
    static void testBeforeUpdateException() {
        try {
        	ContactTriggerHandler handler = new ContactTriggerHandler();
            TestUtility.THROW_TESTING_EXCEPTION = true;
            handler.beforeUpdate();
            throw new TestUtility.FailedTestingException('GenericTestingException was not thrown in beforeUpdate');
        } catch(TestUtility.GenericTestingException e) {}
    }

    @isTest
    static void testEnqueueFieldChangeJobs() {
        TestUtility.EVENT_BUS_PUBLISH = false;
        List<Contact> contacts = TestDataFactory.createAccountsWithContacts(1, BULK_AMOUNT).contacts;
        for (Integer i=0; i<contacts.size(); i++) {
            contacts[i].FirstName = 'New Contact First Name' + i.toString();
            contacts[i].LastName = 'New Contact Last Name' + i.toString();
        }
        Test.startTest();
        update contacts;
        Test.stopTest();
        List<AsyncApexJob> jobs = [
            SELECT Id
            FROM AsyncApexJob
        ];
        System.assertEquals(BULK_AMOUNT/200, jobs.size(),
                            'private class ContactTriggerHandler_Test.testEnqueueFieldChangeJobs failed: ' +
                            'incorrect number of jobs enqueued');
    }
}