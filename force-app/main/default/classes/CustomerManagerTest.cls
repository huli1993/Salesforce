@IsTest
public class CustomerManagerTest {
    
    @IsTest
    static void testCreateCustomer() {
        CustomerManagerMock mock = new CustomerManagerMock();
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        
        CustomerManager.createCustomer();
        
        Test.stopTest();
        
        Customer__c insertedCustomer = [SELECT Customer_Id__c, First_Name__c, Last_Name__c, Email__c, Phone_Number__c, 
                                        Street__c, City__c, State__c, Postal_Code__c, Country__c,
                                        Date_Of_Birth__c, Registration_Date__c, Customer_Status__c, Preferred_Language__c
                                        FROM Customer__c 
                                        WHERE Email__c = 'johndoe@example.com' LIMIT 1];
        
        System.assertEquals('12345', insertedCustomer.Customer_Id__c);
        System.assertEquals('John', insertedCustomer.First_Name__c);
        System.assertEquals('Doe', insertedCustomer.Last_Name__c);
        System.assertEquals('johndoe@example.com', insertedCustomer.Email__c);
        System.assertEquals('+1234567890', insertedCustomer.Phone_Number__c);
        System.assertEquals('123 Main St', insertedCustomer.Street__c);
        System.assertEquals('New York', insertedCustomer.City__c);
        System.assertEquals('NY', insertedCustomer.State__c);
        System.assertEquals('10001', insertedCustomer.Postal_Code__c);
        System.assertEquals('USA', insertedCustomer.Country__c);
        System.assertEquals(Date.newInstance(1985, 6, 15), insertedCustomer.Date_Of_Birth__c);
        System.assertEquals(Date.newInstance(2024, 10, 13), insertedCustomer.Registration_Date__c);
        System.assertEquals('Active', insertedCustomer.Customer_Status__c);
        System.assertEquals('English', insertedCustomer.Preferred_Language__c);
    }
}