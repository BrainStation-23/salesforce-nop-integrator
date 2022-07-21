public class NopCommerceTableMappingCtr {

    @AuraEnabled
    public static List<Nop_Mapping__c> getNopMapping(String nopTable, String nopAPI){
        List<Nop_Mapping__c> listNopMapping = [SELECT Id, Nop_Table__c, Nop_Field__c, Nop_Data_type__c, SF_Object__c, SF_Field__c, Nop_External_Key__c FROM Nop_Mapping__c 
                                               WHERE Nop_Table__c = :nopTable];
        return listNopMapping;
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
        
        Map<String,String> retMap = new Map<String,String>();
        retMap.put('status', 'success');
        retMap.put('message', 'Successfully Saved');
        return retMap;
    }
}