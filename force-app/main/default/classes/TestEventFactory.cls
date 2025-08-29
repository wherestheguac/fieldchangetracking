@isTest
public class TestEventFactory {
    
    public static DataFactoryBundle createFieldChanges(Integer numEvents) {
        List<Field_Change_Tracking_Event__e> fieldChanges = new List<Field_Change_Tracking_Event__e>();
        System.debug('before generics');
        List<SObject> changedRecords = TestDataFactory.createGenerics(numEvents, FieldChangeTestUtility.DEFAULT_OBJECT_NAME).generics;
        System.debug('after generics');
        system.debug(json.serializePretty(changedRecords));
        for (Integer i=0; i<numEvents; i++) {
            String index = i.toString();
            Field_Change_Tracking_Event__e event = (Field_Change_Tracking_Event__e)Field_Change_Tracking_Event__e.sObjectType.newSObject(null, true);
            event.Record_Id__c = changedRecords[i].Id;
            event.Date_Changed__c = Datetime.now();
            event.Field_Name__c = FieldChangeTestUtility.DEFAULT_FIELD_NAME;
            event.New_Value__c = 'New Value' + index;
            event.Object_Name__c = FieldChangeTestUtility.DEFAULT_OBJECT_NAME;
            event.Old_Value__c = 'Old Value' + index;
            fieldChanges.add(event);
        }
        System.debug('created field changes');
        system.debug(json.serializePretty(fieldChanges));
        Map<String,Map<String,Object>> fieldChangeEventsUuidMap = new Map<String,Map<String,Object>>();
        fieldChangeEventsUuidMap.put(fieldChanges[0].eventUuid, fieldChanges[0].getPopulatedFieldsAsMap());
        return new DataFactoryBundle(fieldChanges, fieldChangeEventsUuidMap);
    }

    public class DataFactoryBundle {
        public List<Field_Change_Tracking_Event__e> fieldChanges { get; private set; }
        public Map<String,Map<String,Object>> fieldChangeEventsUuidMap { get; private set; }

        public DataFactoryBundle(
            List<Field_Change_Tracking_Event__e> fieldChanges,
            Map<String,Map<String,Object>> fieldChangeEventsUuidMap
        ) {
            this.fieldChanges = fieldChanges;
            this.fieldChangeEventsUuidMap = fieldChangeEventsUuidMap;
        }
    }
}