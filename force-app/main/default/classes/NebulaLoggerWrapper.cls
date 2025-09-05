public with sharing class NebulaLoggerWrapper {
    public Enum Method {RUN_INFO, RUN_ERROR, RUN_EXCEPTION, RUN_SAVE}
    private static final Map<Method,String> LOGGING_LEVEL_MAP = new Map<Method,String> {
        Method.RUN_INFO => 'INFO',
        Method.RUN_ERROR => 'ERROR',
        Method.RUN_EXCEPTION => 'ERROR',
        Method.RUN_SAVE => 'INFO'
    };
    @TestVisible private static final String NEW_ENTRY = 'newEntry';
    @TestVisible private static final String SAVE_LOG = 'saveLog';
    private static final Map<Method,String> METHOD_NAME_MAP = new Map<Method,String> {
        Method.RUN_INFO => NEW_ENTRY,
        Method.RUN_ERROR => NEW_ENTRY,
        Method.RUN_EXCEPTION => NEW_ENTRY,
        Method.RUN_SAVE => SAVE_LOG
    };
    public Enum DataType {TYPE_ID, TYPE_RECORD, TYPE_LIST, TYPE_MAP, TYPE_REQUEST_ID, TYPE_EXCEPTION}
    @TestVisible private static final Map<DataType,String> DATA_TYPE_MAP = new Map<DataType,String> {
        DataType.TYPE_ID => 'recordId',
        DataType.TYPE_RECORD => 'record',
        DataType.TYPE_LIST => 'recordList',
        DataType.TYPE_MAP => 'recordMap',
        DataType.TYPE_REQUEST_ID => 'requestId',
        DataType.TYPE_EXCEPTION => 'exception'
    };
    @TestVisible private static final String MESSAGE_KEY = 'message';
    private static final String LOGGING_LEVEL_KEY = 'loggingLevel';
    private static Type loggerType = Type.forName('Nebula', 'CallableLogger') ?? Type.forName('CallableLogger');
    @TestVisible private static Callable logger =  (Callable) loggerType?.newInstance();
    
    public static void log(Method methodName) {
        log(methodName, null, null, null);
    }

    public static void log(Method methodName, String message) {
        log(methodName, message, null, null);
    }

    public static void log(Method methodName, String message, DataType argtype, Object arg) {
        if (logger != null && (!Test.isRunningTest() || (Test.isRunningTest() && TestUtility.ALLOW_LOGGING))) {
            Map<String,Object> args = new Map<String,Object>{
                MESSAGE_KEY => message
            };
            if (methodName != Method.RUN_SAVE) {
                args.put(LOGGING_LEVEL_KEY, LOGGING_LEVEL_MAP.get(methodName));
                args.put(DATA_TYPE_MAP.get(argtype), arg);
                if (methodName == Method.RUN_EXCEPTION) {
                    args.put(SAVE_LOG, true);
                }
            }
            logger.call(METHOD_NAME_MAP.get(methodName), args);
            if (methodName == Method.RUN_EXCEPTION) {
                throw (Exception) arg;
            }
        } else {
            if (methodName == Method.RUN_EXCEPTION) {
                throw (Exception) arg;
            }
        }
    }
}