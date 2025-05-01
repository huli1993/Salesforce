@isTest
public class BatchableClassTest {
    @isTest
    static void testBatchableClass() {
        // Step 1: Create test data
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 10; i++) {
            leads.add(new Lead(FirstName = 'Test', LastName = 'Lead' + i, Company = 'Test Company', Rating = 'Hot'));
        }
        insert leads;

        // Verify that the test data was inserted
        System.assertEquals(10, [SELECT COUNT() FROM Lead WHERE Rating = 'Hot']);

        // Step 2: Execute the batch
        Test.startTest();
        BatchableClass batch = new BatchableClass();
        Database.executeBatch(batch, 2); // Batch size of 2
        Test.stopTest();

        // Step 3: Verify that the records were deleted
        Integer remainingLeads = [SELECT COUNT() FROM Lead WHERE Rating = 'Hot'];
        System.assertEquals(0, remainingLeads, 'All hot leads should be deleted.');

        // Step 4: Verify debug logs (optional, for manual review)
        // Check debug logs in the Developer Console to ensure the totalDeletedRecords count is logged correctly.
    }
}