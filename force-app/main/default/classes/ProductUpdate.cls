public class ProductUpdate implements Queueable {
     List<Id> productIds;
     public static Boolean isTriggerRunning = false;

    
    public ProductUpdate(List<Id> productIds) {
        this.productIds = productIds;
    }

    public void execute(QueueableContext context) {
       
        List<Product__c> products = [SELECT Id, Stock__c, Status__c, Price__c 
                                     FROM Product__c 
                                     WHERE Id IN :productIds];

        
        List<Product__c> productsToUpdate = new List<Product__c>();

        for (Product__c product : products) {
           
            if (product.Stock__c < 10) {
                product.Status__c = 'Basso Stock';
            }
            if (product.Stock__c > 10) {
                product.Status__c = 'Attivo';
            }

            
            if (product.Status__c == 'Attivo') {
                product.Price__c = product.Price__c * 1.05; 
            }

            
            productsToUpdate.add(product);
        }
update productsToUpdate;
    }
}
