public class NopMetaDataService {
    
    public NopModels.MetaDataModel GetFromNopMetaData(){
        
       List<NopCommerce_Setting__mdt> mcs = NopCommerce_Setting__mdt.getAll().values();
       NopModels.MetaDataModel nopMeta = new NopModels.MetaDataModel();
        
        for(NopCommerce_Setting__mdt m : mcs)
        {
            //system.debug(m);
            
            if(m.DeveloperName == 'BASE_URL_PROD_LOGIN'){
                nopMeta.Base_Url = m.Value__c;
            }
            
            if(m.DeveloperName == 'Content_Type'){
                nopMeta.Content_Type = m.Value__c;
            }
            
            if(m.DeveloperName == 'Email'){
                nopMeta.Email = m.Value__c;
            }
            
            if(m.DeveloperName == 'Password'){
                nopMeta.Password = m.Value__c;
            }
            
         }
        
        return nopMeta;
    }
    
    public void UpdateNopToken(string newToken){
        
    	List<NopCommerce_Setting__mdt> mcs = NopCommerce_Setting__mdt.getAll().values();
        
		for(NopCommerce_Setting__mdt m : mcs)
        { 
            if(m.DeveloperName == 'Token'){
                m.Value__c = newToken;
            }
        }
        
    }
}