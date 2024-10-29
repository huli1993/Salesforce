@RestResource(urlMapping='/tickets/*')
global with sharing class TicketService {

    // GET per ottenere tutti i ticket di un account
    @HttpGet
    global static List<Ticket__c> doGet() {
        RestRequest req = RestContext.request;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        
       
        List<Ticket__c> tickets = [SELECT Id, Subject__c, Status__c, CreatedDate FROM Ticket__c WHERE Account__c = :accountId];
        
        return tickets;
    }

    
    @HttpPost
    global static String doPost(String subject, String description, String accountId) {
        
        Ticket__c newTicket = new Ticket__c();
        newTicket.Subject__c = subject;
        newTicket.Description__c = description;
        newTicket.Account__c = accountId;

        
        insert newTicket;

        
        return newTicket.Id;
    }

   
    @HttpPatch
    global static String doPatch(String ticketId, String newStatus) {
        
        Ticket__c ticketToUpdate = [SELECT Id, Status__c FROM Ticket__c WHERE Id = :ticketId LIMIT 1];
        ticketToUpdate.Status__c = newStatus;
        update ticketToUpdate;
         return ticketToUpdate.Id;
    }
}
