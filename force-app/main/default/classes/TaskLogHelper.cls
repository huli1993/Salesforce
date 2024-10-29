public with sharing class TaskLogHelper {
    
    @AuraEnabled(cacheable=true)
    public static Task getTaskDetails(Id taskLogId) {
        
        Task_Log__c taskLog = [SELECT Task_ID__c FROM Task_Log__c WHERE Id = :taskLogId ];
        System.debug('Task ID from Task_Log__c: ' + taskLog.Task_ID__c);
        
        Task task = [SELECT Id, Subject, Description, Status, Priority ,Owner.name
                     FROM Task 
                     WHERE Id = :taskLog.Task_ID__c
                     ];
                     System.debug('Retrieved Task record: ' + task);
        return task;
    }
}
