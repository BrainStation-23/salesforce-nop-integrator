global class NopDataSyncBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    
    global  Integer pageNumber;
    global  Integer totalRecords;
    global  String sObjectName;
    global  String nopTableName;
    global  String nopExternalKey;
    
    global NopDataSyncBatch(String sObjName, String nopTName,String nopExtKey,Integer page)
    {
        sObjectName = sObjName; 
        nopTableName = nopTName;
        nopExternalKey = nopExtKey;
        pageNumber= page;
    }
    global Database.QueryLocator start(Database.BatchableContext dbc){
        return Database.getQueryLocator([SELECT Nop_Id__c, Nop_Username__c FROM Contact Limit 1]);
    }
    
    global void execute(Database.BatchableContext dbc, List<Contact> contacts){
        Map<String,String> mapResp = NopReqDataService.getFromNopData(sObjectName,nopTableName,nopExternalKey,pageNumber);
        totalRecords = Integer.valueOf(mapResp.get('totalRecords'));
    }
    // page = 1, t = 25, ps = 7, r = 18||  page = 2, t = 25, ps = 7, r = 14 || page = 3, t = 25, ps = 7, r = 21 ||  page = 4, t = 25, ps = 7, r = 28
    global void finish(Database.BatchableContext dbc){
        NopCommerce_Setting__mdt pageSizeMDT = NopCommerce_Setting__mdt.getInstance('Nop_API_Default_Page_Size');
        integer ps = integer.valueOf(pageSizeMDT.Value__c);
        if(totalRecords > pageNumber * ps){
            Database.executeBatch(new NopDataSyncBatch(sObjectName,nopTableName,nopExternalKey,pageNumber+1));
        }
    }    
}