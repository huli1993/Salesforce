public with sharing class AccountOpportunitiesController {
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getAccountOpportunities(String accountId) {
        return [SELECT Id, Name, StageName, Amount FROM Opportunity WHERE AccountId = :accountId AND StageName !='Closed'];
    }
}