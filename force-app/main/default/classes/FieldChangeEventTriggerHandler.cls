public class FieldChangeEventTriggerHandler extends TriggerHandler {
    
    public override void afterInsert() {
        try {
            if (Test.isRunningTest() && TestUtility.THROW_TESTING_EXCEPTION) {
                throw new TestUtility.GenericTestingException();
            }
            List<Field_Change__c> fieldChanges = new List<Field_Change__c>();
            // loop through events and create field change records
            for(Field_Change_Tracking_Event__e fieldChangeEvent : (List<Field_Change_Tracking_Event__e>)Trigger.new) {
                fieldChanges.add(new Field_Change__c(
                    Changed_Record_Id__c = fieldChangeEvent.Record_Id__c,
                    Date_Changed__c = fieldChangeEvent.Date_Changed__c,
                    Field_Name__c = fieldChangeEvent.Field_Name__c,
                    New_Value__c = fieldChangeEvent.New_Value__c,
                    Object_Name__c = fieldChangeEvent.Object_Name__c,
                    Old_Value__c = fieldChangeEvent.Old_Value__c
                ));
            }
            List<Database.SaveResult> results = Database.insert(fieldChanges, false);
            // check for issues saving the Field Change records and log any errors
            List<Database.SaveResult> fcErrors = new List<Database.SaveResult>();
            for (Database.SaveResult sr : results) {
                if (!sr.isSuccess()) {
                    fcErrors.add(sr);
                }
            }
            if (fcErrors.size() > 0) {
                String errorString = 'Error inserting sObjects of type Field_Change__c';
                NebulaLoggerWrapper.log(
                    NebulaLoggerWrapper.Method.RUN_ERROR,
                    errorString + ': ' + JSON.serializePretty(fcErrors)
                );
                throw new DmlException(errorString);
            }
            // Create relation records
            List<SObject> relations = new List<SObject>();
            for (Field_Change__c fieldChange : fieldChanges) {
                relations.add(FieldChangeRelationUtility.createFieldChangeRelation(
                    FieldChangeRelationUtility.RELATION_METADATA_MAP.get(fieldChange.Object_Name__c).Relation_Object_Name__c,
                    fieldChange.Id,
                    FieldChangeRelationUtility.RELATION_METADATA_MAP.get(fieldChange.Object_Name__c).Changed_Object_Lookup_Field_Name__c,
                    fieldChange.Changed_Record_Id__c
                ));
            }
            results = Database.insert(relations, false);
            // check for issues saving the Field Change Relation records and log any errors
            List<Database.SaveResult> relErrors = new List<Database.SaveResult>();
            for (Database.SaveResult sr : results) {
                if (!sr.isSuccess()) {
                    relErrors.add(sr);
                }
            }
            if (relErrors.size() > 0) {
                String errorString = 'Error inserting sObjects of type Field_Change_*_Relation__c';
                NebulaLoggerWrapper.log(
                    NebulaLoggerWrapper.Method.RUN_ERROR,
                    errorString + ': ' + JSON.serializePretty(relErrors)
                );
                throw new DmlException(errorString);
            }
        } catch(Exception e) {
            NebulaLoggerWrapper.log(
                NebulaLoggerWrapper.Method.RUN_EXCEPTION,
                'Exception in apex class: FieldChangeEventTriggerHandler.afterInsert',
                NebulaLoggerWrapper.DataType.TYPE_EXCEPTION,
                e
            );
        }
    }
}