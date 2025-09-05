@isTest
private class NebulaLoggerWrapper_Test {

    private static final String EXCEPTION_MESSAGE = 'Unique exception message for testing purposes';
    private static String methodExecuted;
    private static Object param;
    private static String message;

    @isTest
    static void testExceptionRethrowWhenNoLogger() {
        TestUtility.ALLOW_LOGGING = true;
        NebulaLoggerWrapper.logger = null;
        try {
            NebulaLoggerWrapper.log(
                NebulaLoggerWrapper.Method.RUN_EXCEPTION,
                EXCEPTION_MESSAGE,
                NebulaLoggerWrapper.DataType.TYPE_EXCEPTION,
                new TestUtility.GenericTestingException(EXCEPTION_MESSAGE)
            );
            throw new TestUtility.FailedTestingException('GenericTestingException was not thrown in call');
        } catch(TestUtility.GenericTestingException e) {
            System.assertEquals(EXCEPTION_MESSAGE, e.getMessage());
        }
    }

    @isTest
    static void testRunInfo() {
        TestUtility.ALLOW_LOGGING = true;
        NebulaLoggerWrapper.logger = new CallableTestLogger();
        NebulaLoggerWrapper.log(NebulaLoggerWrapper.Method.RUN_INFO);
        System.Assert.areEqual(NebulaLoggerWrapper.NEW_ENTRY, methodExecuted);
    }

    @isTest
    static void testRunError() {
        TestUtility.ALLOW_LOGGING = true;
        NebulaLoggerWrapper.logger = new CallableTestLogger();
        NebulaLoggerWrapper.log(NebulaLoggerWrapper.Method.RUN_ERROR);
        System.Assert.areEqual(NebulaLoggerWrapper.NEW_ENTRY, methodExecuted);
    }

    @isTest
    static void testRunException() {
        try {
            TestUtility.ALLOW_LOGGING = true;
            NebulaLoggerWrapper.logger = new CallableTestLogger();
            NebulaLoggerWrapper.log(
                NebulaLoggerWrapper.Method.RUN_EXCEPTION,
                EXCEPTION_MESSAGE,
                NebulaLoggerWrapper.DataType.TYPE_EXCEPTION,
                new TestUtility.GenericTestingException(EXCEPTION_MESSAGE)
            );
        } catch(TestUtility.GenericTestingException e) {
            System.Assert.areEqual(EXCEPTION_MESSAGE, ((Exception)param).getMessage());
            System.Assert.areEqual(NebulaLoggerWrapper.NEW_ENTRY, methodExecuted);
            System.Assert.areEqual(EXCEPTION_MESSAGE, e.getMessage());
        }
    }

    @isTest
    static void testRunSave() {
        TestUtility.ALLOW_LOGGING = true;
        NebulaLoggerWrapper.logger = new CallableTestLogger();
        NebulaLoggerWrapper.log(NebulaLoggerWrapper.Method.RUN_SAVE);
        System.Assert.areEqual(NebulaLoggerWrapper.SAVE_LOG, methodExecuted);
    }

    @isTest
    static void testMessage() {
        TestUtility.ALLOW_LOGGING = true;
        NebulaLoggerWrapper.logger = new CallableTestLogger();
        NebulaLoggerWrapper.log(NebulaLoggerWrapper.Method.RUN_INFO, EXCEPTION_MESSAGE);
        System.Assert.areEqual(EXCEPTION_MESSAGE, message);
    }

    @isTest
    static void testDataTypeList() {
        TestUtility.ALLOW_LOGGING = true;
        NebulaLoggerWrapper.logger = new CallableTestLogger();
        NebulaLoggerWrapper.log(
            NebulaLoggerWrapper.Method.RUN_INFO,
            EXCEPTION_MESSAGE,
            NebulaLoggerWrapper.DataType.TYPE_LIST,
            new List<String>{EXCEPTION_MESSAGE}
        );
        System.Assert.areEqual(EXCEPTION_MESSAGE, ((List<String>)param)[0]);
    }

    @isTest
    static void testDataTypeException() {
        TestUtility.ALLOW_LOGGING = true;
        NebulaLoggerWrapper.logger = new CallableTestLogger();
        NebulaLoggerWrapper.log(
            NebulaLoggerWrapper.Method.RUN_INFO,
            null,
            NebulaLoggerWrapper.DataType.TYPE_EXCEPTION,
            new TestUtility.GenericTestingException(EXCEPTION_MESSAGE)
        );
        System.Assert.areEqual(EXCEPTION_MESSAGE, ((Exception)param).getMessage());
    }

    private class CallableTestLogger implements System.Callable {
        public Boolean call(String action, Map<String, Object> args) {
            methodExecuted = action;
            if (args != null) {
                for (String key : args.keySet()) {
                    if (key == NebulaLoggerWrapper.MESSAGE_KEY) {
                        message = (String)args.get(key);
                    } else if ((key == NebulaLoggerWrapper.DATA_TYPE_MAP.get(NebulaLoggerWrapper.DataType.TYPE_EXCEPTION)) ||
                               (key == NebulaLoggerWrapper.DATA_TYPE_MAP.get(NebulaLoggerWrapper.DataType.TYPE_LIST))) {
                        param = args.get(key);
                    }
                }
            }
            return true;
        }
    }
}