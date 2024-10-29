public with sharing class CustomerManager {
    public static void createCustomer () {
        
        HttpResponse response = CalloutService.makeCallout('https://mocki.io/v1/5e8f91c7-185e-47ef-b1ae-ff971f60626a', 'GET');

        
        if (response.getStatusCode() == 200) {
           
            String responseBody = response.getBody();

            CustomerWrapper cst = (CustomerWrapper) JSON.deserialize(responseBody, CustomerWrapper.class);
            System.debug('Customer created: ' + cst);

            
            
            Customer__c customer = new Customer__c();
            customer.Email__c = cst.email;
            customer.Customer_Id__c = cst.customer_id;
            customer.First_Name__c = cst.first_name;
            customer.Last_Name__c = cst.last_name;
            customer.Phone_Number__c = cst.phone_number;
            customer.Status__c = cst.status;

            
            if (cst.address != null) {
                customer.Street__c = cst.address.street;
                customer.City__c = cst.address.city;
                customer.State__c = cst.address.state;
                customer.Postal_Code__c = cst.address.postal_code;
                customer.Country__c = cst.address.country;
            }

            
            customer.Date_Of_Birth__c = cst.date_of_birth;
            customer.Registration_Date__c = cst.registration_date;
            customer.Customer_Status__c = cst.customer_status;
            customer.Preferred_Language__c = cst.preferred_language;

           
            insert customer;
        } else {
            System.debug('Errore nella risposta: ' + response.getStatus());
        }
    }

   
    public class CustomerWrapper {
        public String customer_id {get;set;}
        public String first_name {get;set;}
        public String last_name {get;set;}
        public String email {get;set;}
        public String phone_number {get;set;}
        public String status {get;set;}
        public Date date_of_birth {get;set;}
        public Date registration_date {get;set;}
        public String customer_status {get;set;}
        public String preferred_language {get;set;}
        public Address address {get;set;}
    }

    
    public class Address {
        public String street {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String postal_code {get;set;}
        public String country {get;set;}
    }
}
