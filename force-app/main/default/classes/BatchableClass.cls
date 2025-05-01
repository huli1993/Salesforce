public with sharing class BatchableClass implements Database.Batchable<SObject>, Database.Stateful {
    public String query;
    private Integer totalDeletedRecords = 0; 

    public BatchableClass() {
        this.query = 'SELECT Id FROM Lead where Rating =  \'Hot\' '; 
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<SObject> scope) {
        try {
            delete scope; 
            totalDeletedRecords += scope.size(); 
            System.debug('Deleted records in this batch: ' + scope.size());
        } catch (Exception e) {
            System.debug('Error during batch execution: ' + e.getMessage());
        }
    }

    public void finish(Database.BatchableContext BC) {
       
        System.debug('Batch job completed successfully. Total records deleted: ' + totalDeletedRecords);
    }
}