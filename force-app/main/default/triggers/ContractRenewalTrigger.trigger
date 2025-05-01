trigger ContractRenewalTrigger on Contract_Renewal__c (after insert, after update) {

    // Define the threshold
    Decimal threshold = 10000;
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    List<Task> activities = new List<Task>();

    for (Contract_Renewal__c renewal : Trigger.new) {

        // 1. Send Notification
        if (renewal.Value_c != null && renewal.Value_c > threshold) {
            // Query the owner's email address
            User owner = [SELECT Email FROM User WHERE Id = :renewal.OwnerId LIMIT 1];
            
            // Create and configure email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] { owner.Email });
            email.setSubject('Renewal Notification');
            email.setPlainTextBody('A renewal with a value exceeding €10,000 has been created.');
            emails.add(email);
        }

        // 2. Update the Record
        if (renewal.Value__c == null) {
            renewal.Renewal_Status__c = 'Pending';
        } else if (renewal.Value__c > 0) {
            renewal.Renewal_Status__c = 'Completed';
        }

        // // 3. Create Activity Record
        // Task activity = new Task();
        // activity.WhatId = renewal.Id;
        // activity.Subject = 'Contract Renewal';
        // activity.Activity_Type__c = 'Contract Renewal';
        // activity.Description = 'Contract renewal for ' + renewal.Product_Service__c + 
        //                        ' with value of ' + renewal.Value__c;
        // activities.add(activity);

        // 4. Check Expirations
        // if (renewal.Renewal_Date__c != null && 
        //     Date.today().addDays(30) >= renewal.Renewal_Date__c) {
        //     renewal.Renewal_Expiring_Message__c = 'Renewal Expiring';
        // }

        // // 5. Link Renewal to Account and Update Information
        // if (renewal.Account__c != null) {
        //     Account acc = [SELECT Id, Total_Contract_Value_c FROM Account WHERE Id = :renewal.Account__c LIMIT 1];
        //     if (acc != null) {
        //         acc.Total_Contract_Value_c = (acc.Total_Contract_Value_c == null ? 0 : acc.Total_Contract_Value_c) + renewal.Value__c;
        //         update acc;
        //     }
        // }
    }

    // Send emails if there are any to send
    if (!emails.isEmpty()) {
        Messaging.sendEmail(emails);
    }

    // Insert all activity records
    if (!activities.isEmpty()) {
        insert activities;
    }
}