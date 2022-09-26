public class NopReqDataService { 
    
    @AuraEnabled
    public static void retrieveNopData(String sObjName, String nopTableName, String nopExternalKey){
        //if(1==1) throw new MyException(nopTableName);
        //getFromNopData(sObjName,nopTableName,nopExternalKey,1);
        NopDataSyncBatch ndb = new NopDataSyncBatch(sObjName, nopTableName, nopExternalKey, 1);
        Database.executeBatch(ndb);
    }
    
    
    public static HttpRequest setReqBody (String nopTableName, HttpRequest req, integer page, integer pageSize){
        
        
        if(nopTableName == 'Customer'){
            NopModels.NopCustomerReq NopData = new NopModels.NopCustomerReq(page,pageSize,((page-1)*pageSize),pageSize);
            string body = JSON.serialize(NopData);
            system.debug(body);
            req.setBody(body); 
        }
        else if(nopTableName == 'Product'){
            NopModels.NopProductReq NopData = new NopModels.NopProductReq(page,pageSize,((page-1)*pageSize),pageSize);
            string body = JSON.serialize(NopData);
            req.setBody(body); 
        }
        else if(nopTableName == 'Order'){
            NopModels.NopOrderReq NopData = new NopModels.NopOrderReq(page,pageSize,((page-1)*pageSize),pageSize);
            string body = JSON.serialize(NopData);
            req.setBody(body); 
        }
        //else if(nopTableName == 'OrderItem'){
           // NopModels.NopOrderReq NopData = new NopModels.NopOrderReq(page,pageSize,((page-1)*pageSize),pageSize);
           // string body = JSON.serialize(NopData);
           // req.setBody(body); 
       // }
                
        return req;
    }    
    
    public static Map<String,String> getFromNopData(String sObjName, String nopTableName, String nopExternalKey, integer pageNumber){
        
        HttpRequest req = new HttpRequest();        
        //NopModels.MetaDataModel nopMetaData = new NopMetaDataService().getFromNopMetaData();
        NopCommerce_Setting__mdt baseURLMDT = NopCommerce_Setting__mdt.getInstance('BASE_URL_PROD_LOGIN');
        NopCommerce_Setting__mdt nstMDT = NopCommerce_Setting__mdt.getInstance('Admin_NST');
        NopCommerce_Setting__mdt ctMDT = NopCommerce_Setting__mdt.getInstance('Content_Type');
        NopCommerce_Setting__mdt mcs = NopCommerce_Setting__mdt.getInstance('Access_Token');
        NopCommerce_Setting__mdt apiEndPoint = NopCommerce_Setting__mdt.getInstance(nopTableName + '_API_End_Point');
        NopCommerce_Setting__mdt pageSizeMDT = NopCommerce_Setting__mdt.getInstance('Nop_API_Default_Page_Size');
        String token = mcs.Value__c; 
        
        req.setEndpoint(baseURLMDT.Value__c + apiEndPoint.Value__c);
        req.setHeader('Content-Type', ctMDT.Value__c);
        req.setHeader('Admin_Token', token);
        req.setHeader('Admin_NST', nstMDT.Value__c);
        req.setMethod('POST');
        
        setReqBody(nopTableName, req, pageNumber, integer.valueOf(pageSizeMDT.Value__c));
        
        //string body ='{ "Data": { "SelectedCustomerRoleIds": [ 3 ], "AvailableCustomerRoles": [ { "Disabled": false, "Group": null, "Selected": false, "Text": "Administrators", "Value": "1" } ], "Page": 1, "PageSize": 7, "AvailablePageSizes": "7, 15, 20, 50, 100", "Draw": null, "Start": 0, "Length": 5, "CustomProperties": {} } }';
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        system.debug('res ='+ res);
        system.debug(res.getBody());
        Map<String, Nop_Mapping__c> mapFieldMapping = new Map<String, Nop_Mapping__c>();
        for(Nop_Mapping__c nm: [Select Id , Nop_Field__c, SF_Field__c, Nop_Data_type__c FROM Nop_Mapping__c WHERE SF_Object__c=:sObjName AND Nop_Table__c=:nopTableName]){
            mapFieldMapping.put(nm.Nop_Field__c, nm);            
        }
        
        Map<String,Object> rawResMp = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
        Map<String,Object> resDataMp = (Map<String,Object>) rawResMp.get('Data');
        Integer totalRecords = (Integer) resDataMp.get('RecordsTotal');
        List<Object> listData = (list<Object>) resDataMp.get('Data');
        Map<String,sObject> mapObjSave = new  Map<String,sObject>();        
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
                
        mapObjSave= parseJSON(listData,sObjName,nopExternalKey,mapFieldMapping,objectFields,true);
        
        if(!mapObjSave.isEmpty()){
            upsert mapObjSave.values();
            //database.upsert(mapObjSave.values(),false);
        }
        
        Map<String,String> retMap = new Map<String,String>();
        retMap.put('status', 'success');
        retMap.put('totalRecords', String.valueOf(totalRecords));
        retMap.put('pageNumber', String.valueOf(pageNumber));
        retMap.put('message', 'Successfully Saved');
        return retMap;
    }
    
    private static Map<String,sObject> parseJSON (List<Object> listData,String sObjName,String nopExternalKey,Map<String, Nop_Mapping__c> mapFieldMapping,Map<String, Schema.SObjectField> objectFields,boolean hasItems){
        
        Map<String,sObject> mapObjSave = new  Map<String,sObject>(); 
        for(Object objData: listData){
            sObject recObj = Schema.getGlobalDescribe().get(sObjName).newSObject();            
            Map<String,Object> aData = (Map<String,Object>) objData;
            system.debug(aData);
            string extKey = string.valueof(aData.get(nopExternalKey));
            system.debug(extKey);
            if(extKey == null) {
                continue;
            }
            
            recObj.put('Nop_External_Key__c', extKey);
            system.debug(extKey);  
            
            for(String nopField : mapFieldMapping.keySet()) {
                string sfField = mapFieldMapping.get(nopField).SF_Field__c;
                string nopDataType = mapFieldMapping.get(nopField).Nop_Data_type__c;
                system.debug('nopDataType = '+ nopDataType);
                
                if(aData.containsKey(nopField) && sfField!= null){
                    system.debug(nopField + '=' +aData.get(nopField));
                    
                    if(objectFields.containsKey(sfField)){
                        Schema.DescribeFieldResult lfieldLabel = objectFields.get(sfField).getDescribe();
                        Schema.DisplayType dType = lfieldLabel.getType();
                        string fieldType = String.ValueOf(dType);
                        system.debug(fieldType);
                        
                        //DOUBLE EMAIL PICKLIST DATE BOOLEAN
                        if(fieldType == 'DOUBLE'){
                            Decimal val = (Decimal)aData.get(nopField);
                            //Decimal val = Decimal.valueof(aData.get(nopField));
                            if(val!= null ){
                                recObj.put(sfField, val);
                            }
                        }
                        else if(fieldType == 'BOOLEAN'){
                            BOOLEAN val = BOOLEAN.valueof(aData.get(nopField));
                            if(val!= null ){
                                recObj.put(sfField, val);
                            }
                        }
                        else if(fieldType == 'DATE'){
                            DATE val = DATE.valueof(aData.get(nopField));
                            if(val!= null ){
                                recObj.put(sfField, val);
                            }
                        }
                        else if(fieldType == 'DATETIME'){
                            DATETIME val = DATETIME.valueof(aData.get(nopField));
                            if(val!= null ){
                                recObj.put(sfField, val);
                            }
                        }
                        else if(fieldType == 'REFERENCE'){
                            String val = String.valueof(aData.get(nopField));
                            if(val!= null ){
                                if(val instanceof Id){
                                     recObj.put(sfField, val);
                                }
                                else{
                                    for(Account a : [Select Id, Nop_External_Key__c from Account where Nop_External_Key__c=:val]){
                                        if(a.Nop_External_Key__c == val){
                                            recObj.put(sfField, a.Id);
                                        }
                                    }  
                                }
                               
                            }
                        }
                        
                        else{
                            STRING val = STRING.valueof(aData.get(nopField));
                            if(val!= null ){
                                recObj.put(sfField, val);
                            }
                        }
                    }
                }
            }
            setDefaultValues(sObjName,recObj); 
            
            //Items parse
            if(hasItems== true){
                
                string sObjItemName = 'OrderItem';
                string nopTableItemName = 'OrderItem';
                Map<String, Schema.SObjectField> objectItemFields = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
                Map<String, Nop_Mapping__c> mapItemFieldMapping = new Map<String, Nop_Mapping__c>();
                Map<String,sObject> mapObjItemSave = new  Map<String,sObject>(); 
                for(Nop_Mapping__c nm: [Select Id , Nop_Field__c, SF_Field__c, Nop_Data_type__c FROM Nop_Mapping__c WHERE SF_Object__c=:sObjItemName AND Nop_Table__c=:nopTableItemName]){
                    mapItemFieldMapping.put(nm.Nop_Field__c, nm);            
                }
                List<Object> listItemObj = (List<Object>)aData.get('Items');
                mapObjItemSave= parseJSON(listItemObj,'OrderItem',nopExternalKey,mapItemFieldMapping,objectItemFields,true);
           
            }
                
            system.debug('recObj: '+recObj);
            mapObjSave.put(extKey,recObj);
            system.debug('mapObjSave: '+mapObjSave);            
        }
        
        Set<String> setExtKeys = mapObjSave.keySet();
        system.debug('setExtKeys: '+setExtKeys.iterator().next());
        String qry = 'SELECT Id, Name, Nop_External_Key__c FROM '+ sObjName + ' WHERE Nop_External_Key__c = :setExtKeys ';
        system.debug('qry='+ qry);
        List<sObject> listSObj = Database.query(qry);
        system.debug('listSObj='+ listSObj);
        for(sObject so : listSObj) {
            //system.debug('Name='+ so.get('Name'));
            mapObjSave.get((String)so.get('Nop_External_Key__c')).put('Id', (String)so.get('Id'));
            system.debug('Name='+ so.get('Name'));
        }
        
        return mapObjSave;
        
    } 
    
    private static void setDefaultValues(String sObjName, SObject recObj)
    {
        if(sObjName == 'Order'){
            if(recObj.get('Status')== null){
               recObj.put('Status','Draft'); 
            }
            if(recObj.get('EffectiveDate')==null){
               recObj.put('EffectiveDate',system.today()); 
            }
        }
    }
    
}