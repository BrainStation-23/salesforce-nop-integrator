@isTest
public class NopBatchObjectTest {
    
    @isTest
    private static void testBatchClass() {
        
        // Contact test dataA
        List<Contact> contacts = new List<Contact>();
        for (Integer i=0; i<200; i++) {
            contacts.add(new Contact(Nop_FullName__c ='Tawfiqur Rahman', Nop_Company__c ='Brain Station 23'));
        }
        
        insert contacts;
        
        Test.startTest();
        //NopDataSyncBatch np = new NopDataSyncBatch();
        //Id batchId = Database.executeBatch(np, 20);
        Test.stopTest();
        
        List<Contact> updatedContacts = [SELECT Id FROM Contact WHERE Nop_Username__c = 'admin@yourStore.com'];
        System.assertEquals(20, updatedContacts.size(), 'ERROR: At least 1 Contact record not updated correctly');
    }
}