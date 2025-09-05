public class TestUtility {
    public static Boolean ALLOW_LOGGING = false;
    public static Boolean RUN_EVENT_TRIGGERS = true;
    public static Boolean RUN_OBJECT_TRIGGERS = true;
    public static Boolean EVENT_BUS_PUBLISH = true;
    public static Boolean THROW_TESTING_EXCEPTION = false;
    public static String DEFAULT_CRON_EXPRESSION = '0 0 0/1 1/1 * ? *';
    public class GenericTestingException extends Exception {}
    public class FailedTestingException extends Exception {}
    public static List<Apex_Testing_Global_Variable__c> globalVariables {
        public get {
            if (globalVariables == null) {
                globalVariables = [
                    SELECT Id, Name, Value__c
                    FROM Apex_Testing_Global_Variable__c
                ];
                if (globalVariables.size() == 0) {
                    globalVariables = null;
                }
            }
            return globalVariables;
        }
        set;
    }
    public static Map<String,Apex_Testing_Global_Variable__c> globalVariablesMap {
        public get {
            if (globalVariablesMap == null && globalVariables != null) {
                globalVariablesMap = new Map<String,Apex_Testing_Global_Variable__c>();
                for(Apex_Testing_Global_Variable__c var : globalVariables) {
                    globalVariablesMap.put(var.Name, var);
                }
            }
            return globalVariablesMap;
        }
        set;
    }
    public static Map<String,String> globalVariablesValueMap {
        public get {
            if (globalVariablesValueMap == null && globalVariables != null) {
                globalVariablesValueMap = new Map<String,String>();
                for(Apex_Testing_Global_Variable__c var : globalVariables) {
                    globalVariablesValueMap.put(var.Name, var.Value__c);
                }
            }
            return globalVariablesValueMap;
        }
        set;
    }
    
    public static void resetGlobalVariables() {
        globalVariables = null;
        globalVariablesMap = null;
        globalVariablesValueMap = null;
    }
    
    public static void updateGlobalVariables(List<Apex_Testing_Global_Variable__c> vars) {
        globalVariables = vars;
        globalVariablesMap = null;
        globalVariablesValueMap = null;
        upsert globalVariables;
    }
}