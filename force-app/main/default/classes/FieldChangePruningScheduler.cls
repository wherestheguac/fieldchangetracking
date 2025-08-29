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
            if (Test.isRunningTest()) {
                throw e;
            } else {
                Logger.exception('Exception in apex class: FieldChangePruningScheduler.execute', e);
            }
        }
    }
}