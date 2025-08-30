public with sharing class NebulaLoggerWrapper {
    private static final String RUN_INFO = 'INFO';
    private static final String RUN_ERROR = 'ERROR';
    private static final String RUN_EXCEPTION = 'ERROR';
    private static final String RUN_SAVE = 'SAVE';
    public Enum Method {RUN_INFO, RUN_ERROR, RUN_EXCEPTION, RUN_SAVE}
    private static final String TYPE_STRING = 'message';
    private static final String TYPE_ID = 'recordId';
    private static final String TYPE_RECORD = 'record';
    private static final String TYPE_LIST = 'recordList';
    private static final String TYPE_MAP = 'recordMap';
    private static final String TYPE_REQUEST_ID = 'requestId';
    private static final String TYPE_EXCEPTION = 'exception';
    public Enum DataType {TYPE_STRING, TYPE_ID, TYPE_RECORD, TYPE_LIST, TYPE_MAP, TYPE_REQUEST_ID, TYPE_EXCEPTION}
    @TestVisible private static final String LOGGING_LEVEL_KEY = 'loggingLevel';
    @TestVisible private static final String NEW_ENTRY = 'newEntry';
    @TestVisible private static final String SAVE_LOG = 'saveLog';
    private static Type loggerType = Type.forName('Nebula', 'CallableLogger') ?? Type.forName('CallableLogger');
    @TestVisible private static Callable logger =  (Callable) loggerType?.newInstance();
    
    public static void call(Method method, DataType datatype, Object arg) {
        if (logger != null) {
            String methodName;
            Map<String,Object> args;
            if (datatype != null && arg != null) {
                args = new Map<String,Object>{
                    datatype.name() => arg
                };
            }
            switch on method {
                when RUN_INFO,RUN_ERROR,RUN_EXCEPTION {
                    methodName = NEW_ENTRY;
                    args?.put(LOGGING_LEVEL_KEY, method.name());
                }
                when RUN_SAVE {
                    methodName = SAVE_LOG;
                }
            }
            logger.call(methodName, args);
        } else {
            switch on method {
                when RUN_EXCEPTION {
                    throw (Exception) arg;
                }
            }
        }
    }
}