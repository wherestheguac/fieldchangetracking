public class FieldChangeMetadataUtility {
    @TestVisible private static List<Field_Change_Tracking__mdt> fieldChangeMetadataRecords {
        get {
            if (fieldChangeMetadataRecords == null) {
                fieldChangeMetadataRecords = [
                    SELECT
                        Object_Name__c,
                        Field_Name__c
                    FROM Field_Change_Tracking__mdt
                ];
            }
            return fieldChangeMetadataRecords;
        }
        set;
    }
    public static Map<String,Set<String>> OBJECT_METADATA_MAP {
        public get {
            if (OBJECT_METADATA_MAP == null) {
                OBJECT_METADATA_MAP = new Map<String,Set<String>>();
                if (fieldChangeMetadataRecords.size() > 0) {
                    for (Field_Change_Tracking__mdt metadata: fieldChangeMetadataRecords) {
                        String objectName = metadata.Object_Name__c.toLowerCase();
                        String fieldName = metadata.Field_Name__c.toLowerCase();
                        if (OBJECT_METADATA_MAP.containsKey(objectName)) {
                            OBJECT_METADATA_MAP.get(objectName).add(fieldName);
                        } else {
                            OBJECT_METADATA_MAP.put(objectName, new Set<String>{fieldName});
                        }
                    }
                }
            }
            return OBJECT_METADATA_MAP;
        }
        set;
    }
}