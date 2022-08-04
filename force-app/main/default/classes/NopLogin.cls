public class NopLogin {
    @InvocableMethod(label='Reset Nop Token' description='Set the NopCommerce login token.')
    public static void setLoginToken(){
        
        HttpRequest req = new HttpRequest();
        NopModels.MetaDataModel nopMetaData = new NopMetaDataService().GetFromNopMetaData();
        NopModels.LoginModel login = new NopModels.LoginModel();
        
        req.setEndpoint(nopMetaData.Base_Url + '/admincustomer/login');
        req.setHeader('Content-Type', nopMetaData.Content_Type);
        login.Data.Email = nopMetaData.Email;
        login.Data.Password = nopMetaData.Password;
        
        req.setMethod('POST');
        string body = JSON.serialize(login);
        req.setBody(body); 
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        Map<String,Object> rawResMp = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
        Map<String,Object> resDataMp = (Map<String,Object>) rawResMp.get('Data');
        String token = (String) resDataMp.get('Token');
        NopMetadataUtility.upsertRecord(token);        
    }
}