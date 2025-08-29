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
            for (Database.SaveResult sr : results) {
                if (!sr.isSuccess()) {
                    for(Database.Error err : sr.getErrors()) {
                        String errorString = 'Error inserting sObjects of type: Field_Change__c, ' + err.getStatusCode() + ': ' + err.getMessage();
                        if (!Test.isRunningTest()) {
                            Logger.info('Relevant records', fieldChanges);
                            Logger.error(errorString, sr);
                        } else {
                            throw new TestUtility.FailedTestingException(errorString);
                        }
                    }
                }
            }
            // Create relation records
            List<SObject> relations = new List<SObject>();
            for (Field_Change__c fieldChange : fieldChanges) {
                if (Test.isRunningTest()) {
                    relations.add(FieldChangeRelationUtility.createFieldChangeRelation(
                        FieldChangeTestUtility.DEFAULT_RELATION_OBJECT_NAME,
                        fieldChange.Id,
                        FieldChangeTestUtility.DEFAULT_RELATION_FIELD_NAME,
                        fieldChange.Changed_Record_Id__c
                    ));
                } else {
                    relations.add(FieldChangeRelationUtility.createFieldChangeRelation(
                        FieldChangeRelationUtility.RELATION_METADATA_MAP.get(fieldChange.Object_Name__c).Relation_Object_Name__c,
                        fieldChange.Id,
                        FieldChangeRelationUtility.RELATION_METADATA_MAP.get(fieldChange.Object_Name__c).Changed_Object_Lookup_Field_Name__c,
                        fieldChange.Changed_Record_Id__c
                    ));
                }
            }
            results = Database.insert(relations, false);
            // check for issues saving the Field Change Relation records and log any errors
            for (Database.SaveResult sr : results) {
                if (!sr.isSuccess()) {
                    for(Database.Error err : sr.getErrors()) {
                        String errorString = 'Error inserting sObjects of type: Field_Change_*_Relation__c, ' + err.getStatusCode() + ': ' + err.getMessage();
                        if (!Test.isRunningTest()) {
                            Logger.error(errorString, sr);
                        } else {
                            throw new TestUtility.FailedTestingException(errorString);
                        }
                    }
                }
            }
            if (!Test.isRunningTest()) {
                Logger.resumeSaving();
                Logger.saveLog();
            }
        } catch(Exception e) {
            if (!Test.isRunningTest()) {
                Logger.exception('Exception in apex class: FieldChangeEventTriggerHandler', e);
            } else {
                throw e;
            }
        }
    }
}