public class FieldChangeQueueable implements Queueable {
    private String objectName;
    private Map<Id,sObject> oldObjectMap;
    private Map<Id,sObject> newObjectMap;
    private Set<String> fieldChangeMetadata;
    
    public FieldChangeQueueable(String objectName, Map<Id,sObject> oldObjectMap, Map<Id,sObject> newObjectMap) {
        this.oldObjectMap = oldObjectMap;
        this.newObjectMap = newObjectMap;
        this.objectName = objectName;
        if (Test.isRunningTest()) {
            this.fieldChangeMetadata = FieldChangeTestUtility.TESTING_FIELD_CHANGE_METADATA;
        } else {
            List<Field_Change_Tracking__mdt> fieldChangeMetadataRecords = [
                SELECT Field_Name__c
                FROM Field_Change_Tracking__mdt
                WHERE Object_Name__c = :this.objectName
            ];
            this.fieldChangeMetadata = new Set<String>();
            for(Field_Change_Tracking__mdt metadata: fieldChangeMetadataRecords) {
                this.fieldChangeMetadata.add(metadata.Field_Name__c);
            }
        }
    }
    
    public void execute(QueueableContext context) {
        try {
            if (!(Test.isRunningTest() && !TestUtility.EVENT_BUS_PUBLISH)) {
                List<Field_Change_Tracking_Event__e> fieldChangeEvents = new List<Field_Change_Tracking_Event__e>();
                Map<String,Map<String,Object>> fieldChangeEventsUuidMap = new Map<String,Map<String,Object>>();
                // identify changed fields
                for (String key : oldObjectMap.keySet()) {
                    sObject oldObject = oldObjectMap.get(key);
                    sObject newObject = newObjectMap.get(key);
                    List<String> changedFields = RecordCompareUtility.identifyChangedFieldsRestricted(oldObject, newObject, fieldChangeMetadata);
                    // create field change tracking events if there are changed fields
                    if (changedFields.size() > 0) {
                        Map<String,Object> oldFieldMap = oldObject.getPopulatedFieldsAsMap();
                        Map<String,Object> newFieldMap = newObject.getPopulatedFieldsAsMap();
                        for (String fieldName : changedFields) {
                            Object oldFieldValue = oldFieldMap.get(fieldName);
                            Object newFieldValue = newFieldMap.get(fieldName);
                            Field_Change_Tracking_Event__e event = (Field_Change_Tracking_Event__e)Field_Change_Tracking_Event__e.sObjectType.newSObject(null, true);
                            event.Date_Changed__c = Datetime.valueOf(newFieldMap.get('LastModifiedDate').toString());
                            event.Field_Name__c = fieldName;
                            event.New_Value__c = newFieldValue != null ? newFieldValue.toString() : null;
                            event.Object_Name__c = objectName;
                            event.Old_Value__c = oldFieldValue != null ? oldFieldValue.toString() : null;
                            event.Record_Id__c = oldObject.Id;
                            fieldChangeEvents.add(event);
                            fieldChangeEventsUuidMap.put(event.EventUuid, event.getPopulatedFieldsAsMap());
                        }
                    }
                }
                
                if (fieldChangeEvents.size() > 0) {
                    FieldChangeEventCallback callback = new FieldChangeEventCallback(fieldChangeEventsUuidMap);
                    if (!(Test.isRunningTest() && !TestUtility.EVENT_BUS_PUBLISH)) {
                        List<Database.SaveResult> results = EventBus.publish(fieldChangeEvents, callback);
                        // check for issues publishing the platform events and log any errors
                        List<Database.SaveResult> fcErrors = new List<Database.SaveResult>();
                        for (Database.SaveResult sr : results) {
                            if (!sr.isSuccess()) {
                                fcErrors.add(sr);
                            }
                        }
                        if (fcErrors.size() > 0) {
                            String errorString = 'Error publishing platform event of type: Field_Change_Tracking_Event__e, ';
                            NebulaLoggerWrapper.log(
                                NebulaLoggerWrapper.Method.RUN_ERROR,
                                errorString + ': ' + JSON.serializePretty(fcErrors)
                            );
                            throw new DmlException(errorString);
                        }
                    }
                }
                NebulaLoggerWrapper.log(NebulaLoggerWrapper.Method.RUN_SAVE);
            }
        } catch(Exception e) {
            NebulaLoggerWrapper.log(
                NebulaLoggerWrapper.Method.RUN_EXCEPTION,
                'Exception in apex class: FieldChangeQueueable.execute',
                NebulaLoggerWrapper.DataType.TYPE_EXCEPTION,
                e
            );
        }
    }
}