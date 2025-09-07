@isTest
private class FieldChangeQueueable_Test {
    private static final Integer BULK_AMOUNT = 249;

    @isTest
    static void testExecuteException() {
        try {
            TestUtility.THROW_TESTING_EXCEPTION = true;
            Test.startTest();
            FieldChangeQueueable fieldTracking = new FieldChangeQueueable('test', null, null);
            fieldTracking.execute(null);
            Test.stopTest();
            throw new TestUtility.FailedTestingException('GenericTestingException was not thrown in execute');
        } catch(TestUtility.GenericTestingException e) {}
    }
    
    @isTest
    static void testSingleAccountEventPublish() {
        TestMetadataFactory.createFieldChangeTrackingObjectsWithRelations();
        TestUtility.RUN_EVENT_TRIGGERS = false;
        TestDataFactory.DataFactoryBundle data = TestDataFactory.createMockChangedAccounts(1);
        Map<Id,Account> oldAccountsMap = new Map<Id,Account>();
        oldAccountsMap.put(data.accounts[0].Id, data.accounts[0]);
        Map<Id,Account> newAccountsMap = new Map<Id,Account>();
        newAccountsMap.put(data.newAccounts[0].Id, data.newAccounts[0]);
        Test.startTest();
        FieldChangeQueueable fieldTracking = new FieldChangeQueueable('Account', oldAccountsMap, newAccountsMap);
        System.enqueueJob(fieldTracking, 0);
        Test.stopTest();
        Integer eventCount = Integer.valueOf(TestUtility.globalVariablesValueMap.get(FieldChangeTestUtility.EVENT_COUNT_CUSTOM_SETTING_NAME));
        System.assertEquals(TestMetadataFactory.TESTING_ACCOUNT_FIELD_CHANGE_METADATA_COUNT, eventCount,
                            'FieldChangeQueueable_Test.testBulkAccount failed: ' +
                            'incorrect number of Field_Change_Tracking_Event__e events created');
    }
    
    @isTest
    static void testBulkAccountsEventPublish() {
        TestMetadataFactory.createFieldChangeTrackingObjectsWithRelations();
        TestUtility.RUN_EVENT_TRIGGERS = false;
        TestDataFactory.DataFactoryBundle data = TestDataFactory.createMockChangedAccounts(BULK_AMOUNT);
        Map<Id,Account> oldAccountsMap = new Map<Id,Account>();
        Map<Id,Account> newAccountsMap = new Map<Id,Account>();
        for(Integer i=0; i<data.accounts.size(); i++) {
            oldAccountsMap.put(data.accounts[i].Id, data.accounts[i]);
            newAccountsMap.put(data.newAccounts[i].Id, data.newAccounts[i]);
        }
        Test.startTest();
        FieldChangeQueueable fieldTracking = new FieldChangeQueueable('Account', oldAccountsMap, newAccountsMap);
        System.enqueueJob(fieldTracking, 0);
        Test.stopTest();
        Integer eventCount = Integer.valueOf(TestUtility.globalVariablesValueMap.get(FieldChangeTestUtility.EVENT_COUNT_CUSTOM_SETTING_NAME));
        System.assertEquals(BULK_AMOUNT * TestMetadataFactory.TESTING_ACCOUNT_FIELD_CHANGE_METADATA_COUNT, eventCount,
                            'FieldChangeQueueable_Test.testBulkAccount failed: ' +
                            'incorrect number of Field_Change_Tracking_Event__e events created');
    }
    
    @isTest
    static void testSingleContactEventPublish() {
        TestMetadataFactory.createFieldChangeTrackingObjectsWithRelations();
        TestUtility.RUN_EVENT_TRIGGERS = false;
        TestDataFactory.DataFactoryBundle data = TestDataFactory.createMockChangedContacts(1);
        Map<Id,Contact> oldContactsMap = new Map<Id,Contact>();
        oldContactsMap.put(data.contacts[0].Id, data.contacts[0]);
        Map<Id,Contact> newContactsMap = new Map<Id,Contact>();
        newContactsMap.put(data.newContacts[0].Id, data.newContacts[0]);
        Test.startTest();
        FieldChangeQueueable fieldTracking = new FieldChangeQueueable('Contact', oldContactsMap, newContactsMap);
        System.enqueueJob(fieldTracking, 0);
        Test.stopTest();
        Integer eventCount = Integer.valueOf(TestUtility.globalVariablesValueMap.get(FieldChangeTestUtility.EVENT_COUNT_CUSTOM_SETTING_NAME));
        System.assertEquals(TestMetadataFactory.TESTING_CONTACT_FIELD_CHANGE_METADATA_COUNT, eventCount,
                            'FieldChangeQueueable_Test.testSingleContact failed: ' +
                            'incorrect number of Field_Change_Tracking_Event__e events created');
    }
    
    @isTest
    static void testBulkContactsEventPublish() {
        TestMetadataFactory.createFieldChangeTrackingObjectsWithRelations();
        TestUtility.RUN_EVENT_TRIGGERS = false;
        TestDataFactory.DataFactoryBundle data = TestDataFactory.createMockChangedContacts(BULK_AMOUNT);
        Map<Id,Contact> oldContactsMap = new Map<Id,Contact>();
        Map<Id,Contact> newContactsMap = new Map<Id,Contact>();
        for(Integer i=0; i<data.contacts.size(); i++) {
            oldContactsMap.put(data.contacts[i].Id, data.contacts[i]);
            newContactsMap.put(data.newContacts[i].Id, data.newContacts[i]);
        }
        Test.startTest();
        FieldChangeQueueable fieldTracking = new FieldChangeQueueable('Contact', oldContactsMap, newContactsMap);
        System.enqueueJob(fieldTracking, 0);
        Test.stopTest();
        Integer eventCount = Integer.valueOf(TestUtility.globalVariablesValueMap.get(FieldChangeTestUtility.EVENT_COUNT_CUSTOM_SETTING_NAME));
        System.assertEquals(BULK_AMOUNT * TestMetadataFactory.TESTING_CONTACT_FIELD_CHANGE_METADATA_COUNT, eventCount,
                            'FieldChangeQueueable_Test.testBulkContact failed: ' +
                            'incorrect number of Field_Change_Tracking_Event__e events created');
    }
}