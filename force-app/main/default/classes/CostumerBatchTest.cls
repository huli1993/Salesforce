@IsTest
public class CostumerBatchTest {
    @TestSetup
    static void setup() {
        // Create a test customer
        Customer__c customer = new Customer__c(
            Email__c = 'test@example.com',
            TotalSpent__c = 5000,
            CustomerTier__c = 'Bronze',
            Status__c = 'Active',
            ChangeLog__c = ''
        );
        insert customer;
    }

    @IsTest
    static void testExecute() {
        
        CostumerBatch batch = new CostumerBatch();

        
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

       
        Customer__c customer = [SELECT Id, Email__c, TotalSpent__c, CustomerTier__c, Status__c, ChangeLog__c FROM Customer__c WHERE Email__c = 'test@example.com'];

        System.assertEquals('Silver', customer.CustomerTier__c);

        
        System.assertNotEquals('', customer.ChangeLog__c);
    }

    @IsTest
    static void testExecuteInvalidEmail() {
       
        Customer__c customer = new Customer__c(
            Email__c = 'invalid-email',
            TotalSpent__c = 5000,
            CustomerTier__c = 'Bronze',
            Status__c = 'Active',
            ChangeLog__c = ''
        );
        insert customer;

        
        CostumerBatch batch = new CostumerBatch();

       
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        Customer__c updatedCustomer = [SELECT Id, Email__c, TotalSpent__c, CustomerTier__c, Status__c, ChangeLog__c FROM Customer__c WHERE Email__c = 'invalid-email'];

        
        System.assertEquals('Email Non Valida', updatedCustomer.Status__c);

        
        System.assertNotEquals('', updatedCustomer.ChangeLog__c);
    }

    @IsTest
    static void testExecuteGoldTier() {
        
        Customer__c customer = new Customer__c(
            Email__c = 'test@example.com',
            TotalSpent__c = 15000,
            CustomerTier__c = 'Bronze',
            Status__c = 'Active',
            ChangeLog__c = ''
        );
        insert customer;

       
        CostumerBatch batch = new CostumerBatch();

       
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        Customer__c updatedCustomer = [SELECT Id, Email__c, TotalSpent__c, CustomerTier__c, Status__c, ChangeLog__c FROM Customer__c WHERE Email__c = 'test@example.com'];

        
        System.assertEquals('Gold', updatedCustomer.CustomerTier__c);

        
        System.assertNotEquals('', updatedCustomer.ChangeLog__c);
    }
}