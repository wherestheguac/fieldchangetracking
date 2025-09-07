public class FieldChangePruningBatch implements Database.Batchable<sObject> {
    private String query;

    public FieldChangePruningBatch(Integer numOfDays) {
        query = 'SELECT Id FROM Field_Change__c WHERE Date_Changed__c < LAST_N_DAYS:' + numOfDays.toString();
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Field_Change__c> scope) {
        try {
            List<SObject> relations = new List<SObject>();
            String deleteQuery;
            for (Field_Change_Relation_Tracking__mdt metadata : FieldChangeRelationMetadataUtility.RELATION_METADATA_MAP.values()) {
                relations.addAll(Database.query(deleteQuery = 'SELECT Id FROM ' + metadata.Relation_Object_Name__c + ' WHERE Field_Change__c IN :scope'));
            }
            Database.delete(relations, false);
            Database.delete(scope, false);
        } catch(Exception e) {
            NebulaLoggerWrapper.log(
                NebulaLoggerWrapper.Method.RUN_EXCEPTION,
                'Exception in apex class: FieldChangePruningBatch.execute',
                NebulaLoggerWrapper.DataType.TYPE_EXCEPTION,
                e
            );
        }
    }

    public void finish(Database.BatchableContext bc) {}
}