public class FieldChangeEventCallback implements EventBus.EventPublishFailureCallback, EventBus.EventPublishSuccessCallback {
    private static final Integer MAX_RETRIES = 2;
    private Integer retryCounter = 0;
    private Map<String,Map<String,Object>> uuidMap;
    
    public FieldChangeEventCallback(Map<String,Map<String,Object>> uuidMap) {
        this.uuidMap = uuidMap;
    }
    
    public void onFailure(EventBus.FailureResult result) {
        List<String> eventUuids = result.getEventUuids();
        Map<String,Map<String,Object>> newUuidMap = new Map<String,Map<String,Object>>();
        
        if (retryCounter < MAX_RETRIES) {
            List<Field_Change_Tracking_Event__e> fieldChangeEvents = new List<Field_Change_Tracking_Event__e>();
            Map<String,Object> oldEvent;
            Field_Change_Tracking_Event__e newEvent;
            for (String uuid : eventUuids) {
                oldEvent = uuidMap.get(uuid);
                newEvent = (Field_Change_Tracking_Event__e)Field_Change_Tracking_Event__e.sObjectType.newSObject(null, true);
                newEvent.Date_Changed__c = Datetime.valueOf(oldEvent.get('Date_Changed__c').toString());
                newEvent.Field_Name__c = oldEvent.get('Field_Name__c').toString();
                newEvent.New_Value__c = oldEvent.get('New_Value__c').toString();
                newEvent.Object_Name__c = oldEvent.get('Object_Name__c').toString();
                newEvent.Old_Value__c = oldEvent.get('Old_Value__c').toString();
                newEvent.Record_Id__c = oldEvent.get('Record_Id__c').toString();
                fieldChangeEvents.add(newEvent);
                newUuidMap.put(newEvent.EventUuid, newEvent.getPopulatedFieldsAsMap());
            }
            // Replace old uuid map
            uuidMap = newUuidMap;
            if (!Test.isRunningTest()) {
            	Logger.error('Retrying FieldChangeEvent Publish', fieldChangeEvents);
            }
            EventBus.publish(fieldChangeEvents, this);
            retryCounter++;
        } else {
            if (Test.isRunningTest()) {
                FieldChangeTestUtility.updateEventCallbackFailureGlobalVariables(retryCounter);
            } else {
            	Logger.error('FieldChangeEventFailureCallback.onFailure: Retry limit reached');
            }
        }
    }
    
    public void onSuccess(EventBus.SuccessResult result) {
        if (Test.isRunningTest()) {
            FieldChangeTestUtility.updateEventCallbackSuccessGlobalVariables(result.getEventUuids());
        }
    }
    
    public Integer getRetryCounter() {
        return retryCounter;
    }
    
    public Map<String,Map<String,Object>> getUuidMap() {
        return uuidMap;
    }
}