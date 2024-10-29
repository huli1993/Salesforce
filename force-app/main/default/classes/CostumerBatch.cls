public class CostumerBatch implements Schedulable, Database.Batchable<sObject> {
    
    
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Email__c, TotalSpent__c, CustomerTier__c, Status__c, ChangeLog__c
            FROM Customer__c
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Customer__c> scope) {
        List <Customer__c> customersToUpdate = new List<Customer__c>();
        for (Customer__c customer : scope) {
            try {
                
                if (!isValidEmail(customer.Email__c)) {
                    customer.Status__c = 'Email Non Valida';
                }

                
                if (customer.TotalSpent__c > 10000) {
                    customer.CustomerTier__c = 'Gold';
                } else {
                    customer.CustomerTier__c = 'Silver';
                }

              
                customer.ChangeLog__c += 'Updated Customer Tier to ' + customer.CustomerTier__c + '\n';
            } catch (DmlException e) {
                customer.ChangeLog__c += 'Error: ' + e.getMessage() + '\n';
            }
        }
        update customersToUpdate;
    }
    public void execute(SchedulableContext sc) {
        
        Database.executeBatch(this);
    }

    public void finish(Database.BatchableContext bc) {
       
    }

    private boolean isValidEmail(String email) {
        
        return Pattern.matches('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$', email);
    }
}