trigger ProductUpdateTrigger on Product__c (after insert, after update) {
    if (ProductUpdate.isTriggerRunning) {
        return; 
    }

    List<Id> productIds = new List<Id>();

    for (Product__c product : Trigger.new) {
        
        if (Trigger.isInsert || (Trigger.isUpdate && product.Stock__c != Trigger.oldMap.get(product.Id).Stock__c)) {
            productIds.add(product.Id);
        }
    }

    
    if (!productIds.isEmpty()) {
        ProductUpdate.isTriggerRunning = true;  
        System.enqueueJob(new ProductUpdate(productIds));
        ProductUpdate.isTriggerRunning = false; 
    }

    
//   for (Product__C pro : Trigger.new) { 
//   ProductUpdate pro1 = System.enqueueJob(new ProductUpdate());  
//     System.debug('Queued job for new account with ID: ' + jobID); 
//   } 

}
