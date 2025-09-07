public class RecordCompareUtility {
    
    public static List<String> identifyChangedFields (sObject oldObj, sObject newObj) {
        List<String> changedFieldNames = new List<String>();
        Map<String,Object> oldObjMap = oldObj.getPopulatedFieldsAsMap();
        Map<String,Object> newObjMap = newObj.getPopulatedFieldsAsMap();
        Set<String> combinedFields = new Set<String>(oldObjMap.keySet());
        combinedFields.addAll(newObjMap.keySet());
        // compare old records to new records
        for (String fieldName: combinedFields) {
            Object oldFieldValue = oldObjMap.get(fieldName);
            Object newFieldValue = newObjMap.get(fieldName);
            if ((oldFieldValue != newFieldValue) ||
                (oldFieldValue == null && newFieldValue != null) ||
                (oldFieldValue != null && newFieldValue == null)) {
                changedFieldNames.add(fieldName.toLowerCase());
            }
        }
        return changedFieldNames;
    }
    
    public static List<String> identifyChangedFieldsRestricted (sObject oldObj, sObject newObj, Set<String> fieldNameRestriction) {
        List<String> changedFieldNames = new List<String>();
        Map<String,Object> oldObjMap = oldObj.getPopulatedFieldsAsMap();
        Map<String,Object> newObjMap = newObj.getPopulatedFieldsAsMap();
        Set<String> combinedFields = new Set<String>(oldObjMap.keySet());
        combinedFields.addAll(newObjMap.keySet());
        // compare old records to new records
        for (String fieldName: combinedFields) {
            if (fieldNameRestriction.contains(fieldName.toString().toLowerCase())) {
                Object oldFieldValue = oldObjMap.get(fieldName);
                Object newFieldValue = newObjMap.get(fieldName);
                if ((oldFieldValue == null && newFieldValue != null) ||
                    (oldFieldValue != null && newFieldValue == null) ||
                	(oldFieldValue != newFieldValue)) {
                    changedFieldNames.add(fieldName);
                }
            }
        }
        return changedFieldNames;
    }
}