public class FieldChangeTestUtility {
    public static final Integer TESTING_ACCOUNT_FIELD_METADATA_COUNT = 2;
    public static final Integer TESTING_CONTACT_FIELD_METADATA_COUNT = 2;
    public static final Set<String> TESTING_FIELD_CHANGE_METADATA = new Set<String> {'FirstName','LastName','Name','AccountNumber'};
    public static final String EVENT_COUNT_CUSTOM_SETTING_NAME = 'Event Count';
    public static final String EVENT_UUID_CUSTOM_SETTING_NAME = 'Event Uuid';
    public static final String DEFAULT_OBJECT_NAME = 'Account';
    public static final String DEFAULT_FIELD_NAME = 'Name';
    public static final String DEFAULT_RECORD_ID_PREFIX = Account.sObjectType.getDescribe().getKeyPrefix();
    public static final String DEFAULT_RELATION_OBJECT_NAME = 'Field_Change_Account_Relation__c';
    public static final String DEFAULT_RELATION_FIELD_NAME = 'Account__c';
    public static final String DEFAULT_RELATION_ID_PREFIX = Field_Change_Account_Relation__c.sObjectType.getDescribe().getKeyPrefix();
    public static final Integer DAYS_TO_PRUNE = 10;

    public static void updateEventCallbackSuccessGlobalVariables(List<String> eventUuids) {
        List<Apex_Testing_Global_Variable__c> globalVars = TestUtility.globalVariables;
        
        if (globalVars == null) {
            globalVars = new List<Apex_Testing_Global_Variable__c> {
                new Apex_Testing_Global_Variable__c(
                    Name = EVENT_COUNT_CUSTOM_SETTING_NAME,
                    Value__c = eventUuids.size().toString()
                ),
                new Apex_Testing_Global_Variable__c(
                    Name = EVENT_UUID_CUSTOM_SETTING_NAME,
                    Value__c = eventUuids[0]
                )
            };
            TestUtility.updateGlobalVariables(globalVars);
        } else {
            Apex_Testing_Global_Variable__c eventCount, eventUuid;
            for (Apex_Testing_Global_Variable__c var : globalVars) {
                if (var.Name == EVENT_COUNT_CUSTOM_SETTING_NAME) {
                    eventCount = var;
                } else if (var.Name == EVENT_UUID_CUSTOM_SETTING_NAME) {
                    eventUuid = var;
                }
            }
            if (!eventUuids.contains(eventUuid.Value__c)) {
                eventCount.Value__c = (Integer.valueOf(eventCount.Value__c) + eventUuids.size()).toString();
                eventUuid.Value__c = eventUuids[0];
                globalVars = new List<Apex_Testing_Global_Variable__c> {eventCount, eventUuid};
                TestUtility.updateGlobalVariables(globalVars);
            }
        }
    }

    public static void updateEventCallbackFailureGlobalVariables(Integer retryCounter) {
        TestUtility.updateGlobalVariables(new List<Apex_Testing_Global_Variable__c>{
            new Apex_Testing_Global_Variable__c(
                Name = EVENT_COUNT_CUSTOM_SETTING_NAME,
                Value__c = '0'
        )});
    }
}