@isTest

public with sharing class OrderTriggerTest {
    @isTest
    static void testOrderInsert() {
        
        Order__c newOrder = new Order__c(
            Unit_Price__c = 100,
            Quantity__c = 5,
            Discount__c = 10 // 10% discount
        );
        insert newOrder;

        
        Order__c insertedOrder = [SELECT TotalAmount__c, Status__c FROM Order__c WHERE Id = :newOrder.Id];

        
        
        System.assertEquals(450, insertedOrder.TotalAmount__c, 'The TotalAmount__c should be 450.');

        System.assertEquals('In Attesa', insertedOrder.Status__c, 'The Status__c should be "Elaborazione" when total is > 500.');
    }

    
    @isTest
    static void testOrderUpdate() {
        
        Order__c newOrder = new Order__c(
            Unit_Price__c = 50,
            Quantity__c = 2,
            Discount__c = 0 
        );
        insert newOrder;

        
        newOrder.Discount__c = 20; 
        update newOrder;

       
        Order__c updatedOrder = [SELECT TotalAmount__c, Status__c FROM Order__c WHERE Id = :newOrder.Id];

        
       
        System.assertEquals(80, updatedOrder.TotalAmount__c, 'The TotalAmount__c should be 80 after applying the 20% discount.');

        
        System.assertEquals('In Attesa', updatedOrder.Status__c, 'The Status__c should be "In Attesa" when total is <= 500.');
    }
}
