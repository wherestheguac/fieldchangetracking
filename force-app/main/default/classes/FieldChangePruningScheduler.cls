public class FieldChangePruningScheduler implements Schedulable {
    private Integer numOfDays = 200;

    public FieldChangePruningScheduler() {}

    public FieldChangePruningScheduler(Integer numOfDays) {
        this.numOfDays = numOfDays;
    }

    public void execute(SchedulableContext sc) {
        try {
            FieldChangePruningBatch b = new FieldChangePruningBatch(numOfDays);
            Database.executeBatch(b);
        } catch(Exception e) {
            NebulaLoggerWrapper.log(
                NebulaLoggerWrapper.Method.RUN_EXCEPTION,
                'Exception in apex class: FieldChangePruningScheduler.execute',
                NebulaLoggerWrapper.DataType.TYPE_EXCEPTION,
                e
            );
        }
    }
}