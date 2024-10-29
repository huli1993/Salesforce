trigger OrderTrigger on Order__c (before insert, before update,after insert) {
    OrderTriggerHandler handler = new OrderTriggerHandler();

    
    if (Trigger.isBefore && Trigger.isInsert) {
        handler.beforeInsert(Trigger.new);
    }

   
    if (Trigger.isBefore && Trigger.isUpdate) {
        handler.beforeUpdate(Trigger.new); 
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        handler.afterInsert(Trigger.new);  
    }
}
