public class OrderTriggerHandler {
    
    
    public void beforeUpdate(List<Order__c> orders) {
        for (Order__c ord : orders) {
            calculateTotalAmount(ord);
            statusChange(ord);
            calculateDiscount (ord);
        }
    }

    public void beforeInsert(List<Order__c> orders) {
        for (Order__c ord : orders) {
            calculateTotalAmount(ord);
            statusChange(ord);
            
        }
    }
        public void afterInsert(List<Order__c> orders) {
            for (Order__c ord : orders) {
                
                if (ord.TotalAmount__c > 500) {
                   
                    sendOrderNotificationEmail(ord.Id, ord.TotalAmount__c);

                }
                calculateDiscount (ord);
            }
        }
        
    

    
    public void calculateTotalAmount(Order__c order) {
        Decimal unitPrice = order.Unit_Price__c != null ? order.Unit_Price__c : 0;
        Decimal quantity = order.Quantity__c != null ? order.Quantity__c : 0;
        Decimal discount = order.Discount__c != null ? order.Discount__c : 0;

        
        Decimal totalAmount = unitPrice * quantity;

        
        // Decimal discountAmount = (discount / 100) * totalAmount;
        // totalAmount -= discountAmount;

        
        order.TotalAmount__c = totalAmount;
    }

   public void statusChange(Order__c order) {
    if (order.TotalAmount__c > 500) {
        order.Status__c = 'Elaborazione';
        sendOrderNotificationEmail(order.Id, order.TotalAmount__c);
    } else {
        order.Status__c = 'In Attesa';
    }
}

public void calculateDiscount (Order__c order) {
    
        Decimal totalAmount = order.Unit_Price__c * order.Quantity__c;
        Decimal discountAmount = totalAmount * (order.Discount__c/100);
        order.TotalAmount__c = totalAmount - discountAmount;
    
    }
   


    
    @future
    public  static void sendOrderNotificationEmail (Id orderId, Decimal totalAmount) {
        System.debug('Method sendOrderNotificationEmail called with orderId: ' + orderId + ' and totalAmount: ' + totalAmount);
        List<Order__c> orders = [SELECT Name, TotalAmount__c FROM Order__c WHERE Id = :orderId];
        
        // Verifica se è stato trovato un record
        if (!orders.isEmpty()) {
            Order__c order = orders[0];
            
            // Definisci i dettagli dell'email
            String subject = 'Notifica di Ordine - Totale Superiore a 500€';
            String body = 'L\'ordine con ID ' + order.Name + ' ha un totale di ' + totalAmount + '€. Supera i 500€ e richiede attenzione.';
            
            // Lista degli indirizzi email a cui inviare la notifica
            List<String> salesTeamEmails = new List<String>{'huljan.harshova@dunegroup.it'};
            
            // Crea un nuovo oggetto email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(salesTeamEmails);
            mail.setSubject(subject);
            mail.setPlainTextBody(body);
            
            // Invia l'email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}




