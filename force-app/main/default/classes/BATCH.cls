public with sharing class BATCH {
    public class BatchableClass implements Database.Batchable<SObject> {
        public String query;

        public BatchableClass() {
            this.query = 'SELECT Id FROM Lead where Rating =  \'Hot\' '; 
        }

        public Database.QueryLocator start(Database.BatchableContext BC) {
            return Database.getQueryLocator(query);
        }

        public void execute(Database.BatchableContext BC, List<SObject> scope) {
            try {
                delete scope; // Deletes the records in the current batch
            } catch (Exception e) {
                
                System.debug('Error during batch execution: ' + e.getMessage());
            }
        }

        public void finish(Database.BatchableContext BC) {
            // Optional: Add any post-processing logic here
            System.debug('Batch job completed successfully.');
        }
    }
}