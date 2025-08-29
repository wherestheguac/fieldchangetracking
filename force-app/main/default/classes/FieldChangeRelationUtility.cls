public class FieldChangeRelationUtility {
    public static final Map<String,Field_Change_Relation_Tracking__mdt>  RELATION_METADATA_MAP {
        public get{
            if (RELATION_METADATA_MAP == null) {
                RELATION_METADATA_MAP = new Map<String,Field_Change_Relation_Tracking__mdt>();
                List<Field_Change_Relation_Tracking__mdt> relationObjects = [
                    SELECT
                        Changed_Object_Lookup_Field_Name__c,
                        Changed_Object_Name__c,
                        Relation_Object_Name__c
                    FROM Field_Change_Relation_Tracking__mdt
                ];
                for(Field_Change_Relation_Tracking__mdt relationObject : relationObjects) {
                    RELATION_METADATA_MAP.put(relationObject.Changed_Object_Name__c, relationObject);
                }
            }
            return RELATION_METADATA_MAP;
        }
        set;
    }

    public static SObject createFieldChangeRelation(String objectName, String fieldChangeId, String fieldName, String recordId) {
        SObject relation = Schema.getGlobalDescribe().get(objectName).newSObject();
        relation.put('Field_Change__c', fieldChangeId);
        relation.put(fieldName, recordId);
        return relation;
    }
}