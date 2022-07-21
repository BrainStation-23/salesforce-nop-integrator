public with sharing class lwcContact {
    @AuraEnabled(Cacheable = true)
    public static List<Contact> getContacts() {
        List <Contact> conList = [SELECT AccountId FROM Contact LIMIT 200];
        return conList;
    }
}