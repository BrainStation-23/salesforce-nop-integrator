public class NopCommerceTableMappingCtr {
    
    @AuraEnabled
    public static List<Nop_Mapping__c> getNopMapping(String nopTable){
        List<Nop_Mapping__c> listNopMapping = [SELECT Id, Nop_Table__c, Nop_Field__c, Nop_Data_type__c, SF_Object__c, SF_Field__c, Nop_External_Key__c FROM Nop_Mapping__c 
                                               WHERE Nop_Table__c = :nopTable];
        return listNopMapping;
    }
    
    @AuraEnabled
    public static List <NopModels.PicklistOption> getSFObjectInfo(String sObjName){        
        List <NopModels.PicklistOption> listOptions = new List <NopModels.PicklistOption>();
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
        for(String fieldName: objectFields.keySet())
        {
            Schema.DescribeFieldResult sfField = objectFields.get(fieldName).getDescribe();
            if(sfField.isAccessible() && sfField.isCreateable()){ 
                NopModels.PicklistOption po = new NopModels.PicklistOption(); 
                po.label = sfField.getLabel();
                po.value = sfField.getName();
                Schema.DisplayType dType = sfField.getType();
                string fieldType = String.ValueOf(dType);
                po.description = 'Data Type: '+fieldType;
                listOptions.add(po);    
            }   
        }
        system.debug('listOptions ='+listOptions);
        return listOptions;
    }
    
    @AuraEnabled
    public static Map<String,String> saveNopMapping(List<Map<String, String>> params){
        System.debug(params);
        List<Nop_Mapping__c> listNopMapping = new List< Nop_Mapping__c >();
        for(Map<String, String> param : params) {
            listNopMapping.add(new Nop_Mapping__c(
                Nop_Field__c 		= param.get('nopFieldName'),
                Nop_Table__c 		= param.get('nopTable'),
                Nop_Data_type__c 	= param.get('nopDataType'),
                SF_Field__c 		= param.get('sfFieldName'),
                SF_Object__c 		= param.get('sfObject'),
                Nop_External_Key__c = param.get('nopTable')+'___'+param.get('nopFieldName')
            ));
        }
        upsert listNopMapping Nop_External_Key__c;
        system.debug('listNopMapping ='+listNopMapping);
        
        Map<String,String> retMap = new Map<String,String>();
        retMap.put('status', 'success');
        retMap.put('message', 'Successfully Saved');
        return retMap;
    }
}