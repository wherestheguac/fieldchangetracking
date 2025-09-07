@isTest
public class TestMetadataFactory {
    private static final Map<String,String> FIELD_CHANGE_ACCOUNT_METADATA = new Map<String,String> {
        'Account' => 'Name',
        'Account' => 'AccountNumber'
    };
    public static final Integer TESTING_ACCOUNT_FIELD_CHANGE_METADATA_COUNT = FIELD_CHANGE_ACCOUNT_METADATA.keySet().size();
    private static final Map<String,String> FIELD_CHANGE_CONTACT_METADATA = new Map<String,String> {
        'Contact' => 'FirstName',
        'Contact' => 'LastName'
    };
    public static final Integer TESTING_CONTACT_FIELD_CHANGE_METADATA_COUNT = FIELD_CHANGE_CONTACT_METADATA.keySet().size();

    public static DataFactoryBundle createFieldChangTrackingObjects() {
        List<Field_Change_Tracking__mdt> fieldChangeObjects = new List<Field_Change_Tracking__mdt>();
        Integer i = 1;
        for (String key : FIELD_CHANGE_ACCOUNT_METADATA.keySet()) {
            fieldChangeObjects.add(new Field_Change_Tracking__mdt(
                DeveloperName = 'AccountTesting' + i,
                MasterLabel = 'AccountTesting' + i,
                Object_Name__c = key,
                Field_Name__c = FIELD_CHANGE_ACCOUNT_METADATA.get(key)
            ));
            i++;
        }
        Integer j = 1;
        for (String key : FIELD_CHANGE_CONTACT_METADATA.keySet()) {
            fieldChangeObjects.add(new Field_Change_Tracking__mdt(
                DeveloperName = 'ContactTesting' + j,
                MasterLabel = 'ContactTesting' + j,
                Object_Name__c = key,
                Field_Name__c = FIELD_CHANGE_CONTACT_METADATA.get(key)
            ));
            j++;
        }
        FieldChangeMetadataUtility.fieldChangeMetadataRecords = fieldChangeObjects;
        return new DataFactoryBundle(fieldChangeObjects);
    }

    public static DataFactoryBundle createFieldChangeTrackingRelations() {
        List<Field_Change_Relation_Tracking__mdt> fieldChangeRelations = new List<Field_Change_Relation_Tracking__mdt>{
            new Field_Change_Relation_Tracking__mdt(
                DeveloperName = 'AccountTesting',
                MasterLabel = 'AccountTesting',
                Changed_Object_Name__c = 'Account',
                Changed_Object_Lookup_Field_Name__c = 'Account__c',
                Relation_Object_Name__c = 'Field_Change_Account_Relation__c'
            ),
            new Field_Change_Relation_Tracking__mdt(
                DeveloperName = 'ContactTesting',
                MasterLabel = 'ContactTesting',
                Changed_Object_Name__c = 'Contact',
                Changed_Object_Lookup_Field_Name__c = 'Contact__c',
                Relation_Object_Name__c = 'Field_Change_Contact_Relation__c'
            )
        };
        FieldChangeRelationMetadataUtility.fieldChangeRelationMetadataRecords = fieldChangeRelations;
        return new DataFactoryBundle(fieldChangeRelations);
    }

    public static DataFactoryBundle createFieldChangeTrackingObjectsWithRelations() {
        return new DataFactoryBundle(
            createFieldChangTrackingObjects().fieldChangeObjects,
            createFieldChangeTrackingRelations().fieldChangeRelations
        );
    }

    public class DataFactoryBundle {
        public List<Field_Change_Tracking__mdt> fieldChangeObjects;
        public List<Field_Change_Relation_Tracking__mdt> fieldChangeRelations;

        public DataFactoryBundle(
            List<Field_Change_Tracking__mdt> fieldChangeObjects
        ) {
            this.fieldChangeObjects = fieldChangeObjects;
        }

        public DataFactoryBundle(
            List<Field_Change_Relation_Tracking__mdt> fieldChangeRelations
        ) {
            this.fieldChangeRelations = FieldChangeRelations;
        }

        public DataFactoryBundle(
            List<Field_Change_Tracking__mdt> fieldChangeObjects,
            List<Field_Change_Relation_Tracking__mdt> fieldChangeRelations
        ) {
            this.fieldChangeObjects = fieldChangeObjects;
            this.fieldChangeRelations = FieldChangeRelations;
        }
    }
}