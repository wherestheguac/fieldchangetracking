@isTest
private class NebulaLoggerWrapper_Test {

    private static final String EXCEPTION_MESSAGE = 'Unique exception message for testing purposes';
    private static String methodExecuted;
    private static Object param;

    @isTest
    static void testExceptionRethrowWhenNoLogger() {
        TestUtility.ALLOW_LOGGING = true;
        NebulaLoggerWrapper.logger = null;
        try{
            NebulaLoggerWrapper.call(
                NebulaLoggerWrapper.Method.RUN_EXCEPTION,
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
        NebulaLoggerWrapper.call(NebulaLoggerWrapper.Method.RUN_INFO);
        System.Assert.areEqual(NebulaLoggerWrapper.NEW_ENTRY, methodExecuted);
    }

    @isTest
    static void testRunError() {
        TestUtility.ALLOW_LOGGING = true;
        NebulaLoggerWrapper.logger = new CallableTestLogger();
        NebulaLoggerWrapper.call(NebulaLoggerWrapper.Method.RUN_ERROR);
        System.Assert.areEqual(NebulaLoggerWrapper.NEW_ENTRY, methodExecuted);
    }

    @isTest
    static void testRunException() {
        TestUtility.ALLOW_LOGGING = true;
        NebulaLoggerWrapper.logger = new CallableTestLogger();
        NebulaLoggerWrapper.call(NebulaLoggerWrapper.Method.RUN_EXCEPTION);
        System.Assert.areEqual(NebulaLoggerWrapper.NEW_ENTRY, methodExecuted);
    }

    @isTest
    static void testRunSave() {
        TestUtility.ALLOW_LOGGING = true;
        NebulaLoggerWrapper.logger = new CallableTestLogger();
        NebulaLoggerWrapper.call(NebulaLoggerWrapper.Method.RUN_SAVE);
        System.Assert.areEqual(NebulaLoggerWrapper.SAVE_LOG, methodExecuted);
    }

    @isTest
    static void testDataTypeString() {
        TestUtility.ALLOW_LOGGING = true;
        NebulaLoggerWrapper.logger = new CallableTestLogger();
        NebulaLoggerWrapper.call(
            NebulaLoggerWrapper.Method.RUN_INFO,
            NebulaLoggerWrapper.DataType.TYPE_STRING,
            EXCEPTION_MESSAGE
        );
        System.Assert.areEqual(EXCEPTION_MESSAGE, param.toString());
    }

    @isTest
    static void testDataTypeException() {
        TestUtility.ALLOW_LOGGING = true;
        NebulaLoggerWrapper.logger = new CallableTestLogger();
        NebulaLoggerWrapper.call(
            NebulaLoggerWrapper.Method.RUN_INFO,
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
                    if (key != NebulaLoggerWrapper.LOGGING_LEVEL_KEY) {
                        param = args.get(key);
                    }
                }
            }
            return true;
        }
    }
}