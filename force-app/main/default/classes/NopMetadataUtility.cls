public with sharing class NopMetadataUtility {
    public NopMetadataUtility() {
        
    }
    public static void upsertRecord(String TokenValue){
        
        Map<String,NopCommerce_Setting__mdt> mdtMap = new Map<String,NopCommerce_Setting__mdt>();      
        for(NopCommerce_Setting__mdt mdt : [Select MasterLabel, DeveloperName, Value__c From NopCommerce_Setting__mdt]){            
            mdtMap.put(mdt.DeveloperName, mdt);
        }
        
        
        Metadata.CustomMetadata mdata = new Metadata.CustomMetadata();
        mdata.fullName = 'NopCommerce_Setting__mdt.Access_Token';
        mdata.label = mdtMap.get('Access_Token').MasterLabel;
        
        Metadata.CustomMetadataValue instance = new Metadata.CustomMetadataValue();
        instance.field = 'Value__c';
        instance.value = TokenValue;
        mdata.values.add(instance);
        
        Metadata.DeployContainer container = new Metadata.DeployContainer();
        container.addMetadata(mdata);
        
        Metadata.Operations.enqueueDeployment(container, null);
        
    }
}