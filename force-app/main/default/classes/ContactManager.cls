public with sharing class ContactManager {
    public static void createContacts() {
        
        HttpResponse response = CalloutService.makeCallout('https://dev-a5miu0z2xutcy1c.api.raw-labs.com/your/endpoint/6','GET');

        
        if (response.getStatusCode() == 200) {
            String responseBody = response.getBody();
            System.debug( 'Response Body ' +responseBody);

           
            ContactResponse contactResponse = (ContactResponse) JSON.deserialize(responseBody, ContactResponse.class);
            System.debug('Contacts data received: ' + contactResponse.contacts);

            List<Contact> contactsToInsert = new List<Contact>();

            
            for (ContactWrapper cst : contactResponse.contacts) {
                
                    Contact contact = new Contact();
                    contact.FirstName = cst.name;   
                    contact.LastName = cst.surname;  
                    contact.Email = cst.email;      
                    contact.Phone = cst.phone;       
                    
                    contact.MailingStreet = cst.address.street;
                    contact.MailingCity = cst.address.city;
                    contact.MailingPostalCode = cst.address.postalCode;
                    contact.MailingCountry = cst.address.country;

                    
                    contact.Birthdate = Date.valueOf(cst.dateOfBirth); 

                   

                   
                    Account account = [SELECT Id FROM Account WHERE Customer_Id__c = :cst.customerId LIMIT 1];
                    if (account != null) {
                        contact.AccountId = account.Id; 
                    } else {
                        System.debug('No account found for customer ID: ' + cst.customerId);
                    }

                    contactsToInsert.add(contact);
                
            }
            if (!contactsToInsert.isEmpty()) {
                try {
                    insert contactsToInsert;
                    System.debug('Contacts successfully created: ' + contactsToInsert);
                } catch (DmlException e) {
                    System.debug('Error inserting contacts: ' + e.getMessage());
                }
            }
        } else {
            System.debug('Error in callout response: ' + response.getStatus() + ' - ' + response.getBody());
        }
    }

    public class ContactResponse {
        public List<ContactWrapper> contacts { get; set; }
    }
    
   
    public class ContactWrapper {
        public String customerId { get; set; }
        public String name { get; set; }
        public String surname { get; set; }
        public String email { get; set; }
        public String phone { get; set; }
        public Address address { get; set; }
        public String dateOfBirth { get; set; }
        public String customerType { get; set; }
        public String notes { get; set; }
    }

    
    public class Address {
        public String street { get; set; }
        public String city { get; set; }
        public String postalCode { get; set; }
        public String country { get; set; }
    }
}


