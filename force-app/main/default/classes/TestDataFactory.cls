@isTest
public class TestDataFactory {

    public static DataFactoryBundle createGenerics(Integer numRecords, String objectName) {
        List<SObject> generics = new List<SObject>();
        for (Integer i=0; i<numRecords; i++) {
            SObject generic = Schema.getGlobalDescribe().get(objectName).newSObject(null, true);
            generic.put('Name', 'TestGeneric' + i);
            generics.add(generic);
        }
        insert generics;
        return new DataFactoryBundle(generics);
    }
    
    public static DataFactoryBundle createAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i<numAccounts; i++) {
            Account a = new Account(
                Name='TestAccount' + i
            );
            accounts.add(a);
        }
        insert accounts;
        return new DataFactoryBundle(accounts);
    }
    
    public static DataFactoryBundle createAccountsWithContacts(Integer numAccounts, Integer numContactsPerAcct) {
        List<Account> accounts = createAccounts(numAccounts).accounts;
        List<Contact> contacts = new List<Contact>();
        for(Integer j=0; j<numAccounts; j++) {
            Account testAccount = accounts[j];
            for(Integer k=0; k<numContactsPerAcct; k++) {
                contacts.add(new Contact(
                    AccountId = testAccount.Id,
                    FirstName = 'Bob' + k.toString(),
                    LastName = 'Smith' + k.toString(),
                    Email = 'testing' + k.toString() + '@testing.com'
                ));
            }
        }
        insert contacts;
        return new DataFactoryBundle(accounts, contacts);
    }

    public static DataFactoryBundle createFieldChangesWithRelationsToPrune(Integer numFieldChanges) {
        Account acc = createAccounts(1).accounts[0];
        List<Field_Change__c> fieldChanges = new List<Field_Change__c>();
        for(Integer i=0; i<numFieldChanges; i++) {
            Field_Change__c fieldChange = new Field_Change__c(
                Changed_Record_Id__c = acc.Id.toString(),
                Date_Changed__c = Datetime.now().addDays(-(FieldChangeTestUtility.DAYS_TO_PRUNE + 1)),
                Field_Name__c = FieldChangeTestUtility.DEFAULT_FIELD_NAME,
                New_Value__c = 'New Value',
                Object_Name__c = FieldChangeTestUtility.DEFAULT_OBJECT_NAME,
                Old_Value__c = 'Old Value'
            );
            fieldChanges.add(fieldChange);
        }
        insert fieldChanges;
        List<sObject> relations = new List<sObject>();
        for(Integer j=0; j<numFieldChanges; j++) {
            String index = j.toString();
            Field_Change__c fieldChange = fieldChanges[j];
            relations.add(FieldChangeRelationMetadataUtility.createFieldChangeRelation(
                FieldChangeTestUtility.DEFAULT_RELATION_OBJECT_NAME,
                fieldChange.Id,
                FieldChangeTestUtility.DEFAULT_RELATION_FIELD_NAME,
                acc.Id
            ));
        }
        insert relations;
        return new DataFactoryBundle(fieldChanges, relations);
    }

    public static DataFactoryBundle createMockChangedAccounts(Integer numAccounts) {
        List<Account> oldAccounts = new List<Account>();
        List<Account> newAccounts = new List<Account>();
        for(Integer i=0; i<numAccounts; i++) {
            String index = i.toString();
            String accId = Account.sObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12-index.length()) + index;
            String jsonString = '{"attributes":{"type":"Account","url":"/services/data/v64.0/sobjects/Account/' +
                accId + '"},"Id":"' + accId + '",'+
                '"Name":"Old Name' + index + '",' +
                '"AccountNumber":"Old Account Number' + index + '",'+
                '"LastModifiedDate":' + JSON.serialize(Datetime.now()) +
                '}';
            oldAccounts.add((Account) JSON.deserialize(
                jsonString,
                Account.class
            ));
            jsonString = '{"attributes":{"type":"Account","url":"/services/data/v64.0/sobjects/Account/' +
                accId + '"},"Id":"' + accId + '",'+
                '"Name":"New Name' + index + '",' +
                '"AccountNumber":"New Account Number' + index + '",'+
                '"LastModifiedDate":' + JSON.serialize(Datetime.now()) +
                '}';
            newAccounts.add((Account) JSON.deserialize(
                jsonString,
                Account.class
            ));
        }
        return new DataFactoryBundle(oldAccounts, newAccounts);
    }

    public static DataFactoryBundle createMockChangedContacts(Integer numContacts) {
        List<Contact> oldContacts = new List<Contact>();
        List<Contact> newContacts = new List<Contact>();
        for(Integer i=0; i<numContacts; i++) {
            String index = i.toString();
            String conId = Contact.sObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12-index.length()) + index;
            String jsonString = '{"attributes":{"type":"Contact","url":"/services/data/v64.0/sobjects/Contact/' +
                conId + '"},"Id":"' + conId + '",'+
                '"FirstName":"Old First Name' + index + '",' +
                '"LastName":"Old Last Name' + index + '",'+
                '"LastModifiedDate":' + JSON.serialize(Datetime.now()) +
                '}';
            oldContacts.add((Contact) JSON.deserialize(
                jsonString,
                Contact.class
            ));
            jsonString = '{"attributes":{"type":"Contact","url":"/services/data/v64.0/sobjects/Contact/' +
                conId + '"},"Id":"' + conId + '",'+
                '"FirstName":"New First Name' + index + '",' +
                '"LastName":"New Last Name' + index + '",'+
                '"LastModifiedDate":' + JSON.serialize(Datetime.now()) +
                '}';
            newContacts.add((Contact) JSON.deserialize(
                jsonString,
                Contact.class
            ));
        }
        return new DataFactoryBundle(oldContacts, newContacts);
    }
    
    public class DataFactoryBundle {
        public List<SObject> generics { get; private set; }
        public List<Account> accounts { get; private set; }
        public List<Account> newAccounts { get; private set; }
        public List<Contact> contacts { get; private set; }
        public List<Contact> newContacts { get; private set; }
        public List<Field_Change__c> fieldChanges { get; private set; }
        
        public DataFactoryBundle(
            List<SObject> generics
        ) {
            this.generics = generics;
        }

        public DataFactoryBundle(
            List<Account> accounts
        ) {
            this.accounts = accounts;
        }
        
        public DataFactoryBundle(
            List<Account> accounts,
            List<Contact> contacts
        ) {
            this.accounts = accounts;
            this.contacts = contacts;
        }

        public DataFactoryBundle(
            List<Field_Change__c> fieldChanges,
            List<SObject> relations
        ) {
            this.fieldChanges = fieldChanges;
            this.generics = relations;
        }
        
        public DataFactoryBundle(
            List<Account> accounts,
            List<Account> newAccounts
        ) {
            this.accounts = accounts;
            this.newAccounts = newAccounts;
        }
        
        public DataFactoryBundle(
            List<Contact> contacts,
            List<Contact> newContacts
        ) {
            this.contacts = contacts;
            this.newContacts = newContacts;
        }
    }
}