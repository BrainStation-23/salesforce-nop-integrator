public class NopModels {
    public class LoginModel{
        public LoginData Data = new LoginData();
    }
    
    public class LoginData{
        public string Email;
        public string Password;
    }
    
    public class MetaDataModel{
        public string Base_Url;
        public string Content_Type;
        public string Email;
        public string Password;
        public string Token;
        public string Admin_NST;
    }
    
    public class NopProductReq{
        public NopProductPayload Data ;
        public NopProductReq(integer p, integer pS, integer s, integer l){            
            Data = new NopProductPayload(p,ps,s,l);
        }         
    }
    
    public class NopProductPayload{
        
        public integer Page;
        public integer PageSize;
        public string AvailablePageSizes;
        public string Draw;
        public integer Start;
        public integer Length;        
        public NopProductPayload (){
            Page = 1;
            PageSize = 100;
            Start = 0;
            Length = 100;
            AvailablePageSizes ='7, 15, 20, 50, 100';            
        }
        
        public NopProductPayload (integer page, integer pageSize, integer start, integer length){
            this.Page = page;
            this.PageSize = pageSize;
            this.Start = start;
            this.Length = length;
            AvailablePageSizes ='7, 15, 20, 50, 100';            
        }
    }    
    
    public class NopCustomerReq{
        public NopCustomerPayload Data ;
        public NopCustomerReq(integer p, integer pS, integer s, integer l){
            Data = new NopCustomerPayload( p, pS, s, l);
        }
        
    }
    
    public class NopCustomerPayload{
        
        public List<integer> SelectedCustomerRoleIds;
        public integer Page;
        public integer PageSize;
        public string AvailablePageSizes;
        public string Draw;
        public integer Start;
        public integer Length;
        public map<String, String> CustomProperties;
        public List<NopReqAvailableCustomerRoles> AvailableCustomerRoles;
        public NopCustomerPayload (){
            CustomProperties = new map<String, String>();
            SelectedCustomerRoleIds = new List<integer>();
            SelectedCustomerRoleIds.add(3);
            Page = 1;
            PageSize = 100;
            Start = 0;
            Length = 100;
            AvailablePageSizes ='7, 15, 20, 50, 100';
            AvailableCustomerRoles = new List<NopReqAvailableCustomerRoles>();
            NopReqAvailableCustomerRoles nopr = new NopReqAvailableCustomerRoles();
            AvailableCustomerRoles.add(nopr);            
        }
        
        public NopCustomerPayload (integer page, integer pageSize, integer start,integer length ){
            system.debug('page'+page);
            CustomProperties = new map<String, String>();
            SelectedCustomerRoleIds = new List<integer>();
            SelectedCustomerRoleIds.add(3);
            this.Page = page;
            this.PageSize = pageSize;
            this.Start = start;
            this.Length = length;
            AvailablePageSizes ='7, 15, 20, 50, 100';
            AvailableCustomerRoles = new List<NopReqAvailableCustomerRoles>();
            NopReqAvailableCustomerRoles nopr = new NopReqAvailableCustomerRoles();
            AvailableCustomerRoles.add(nopr);            
        }
        
    }
    
    //Customer full order
    public class NopCustomerOrderIteamReq{ 
        public NopOrderIteamPayload Data ; 
        public NopCustomerOrderIteamReq(integer id, integer p, integer pS, integer s, integer l){            
            Data = new NopOrderIteamPayload(id,p,ps,s,l);
        }         
    }
    
    public class NopOrderIteamPayload{
        
        public integer CustomerId;
        public integer Page;
        public integer PageSize;
        public string AvailablePageSizes;
        public integer Start;
        public integer Length;        
        public NopOrderIteamPayload (){
            CustomerId= 1;
            Page = 1;
            PageSize = 15;
            Start = 0;
            Length = 15;
            AvailablePageSizes ='7, 15, 20, 50, 100';            
        }
        
        public NopOrderIteamPayload (integer id, integer page, integer pageSize, integer start, integer length){
            this.CustomerId=id;
            this.Page = page;
            this.PageSize = pageSize;
            this.Start = start;
            this.Length = length;
            AvailablePageSizes ='7, 15, 20, 50, 100';            
        }
    } 
    
    //Order
    public class NopOrderReq{ 
        public NopOrderPayload Data ; 
        public NopOrderReq(integer p, integer pS, integer s, integer l){            
            Data = new NopOrderPayload(p,ps,s,l);
        }         
    }
    
    public class NopOrderPayload{
        
        public integer Page;
        public integer PageSize;
        public string AvailablePageSizes;
        public string Draw;
        public integer Start;
        public integer Length;        
        public NopOrderPayload (){
            Page = 1;
            PageSize = 15;
            Start = 0;
            Length = 15;
            AvailablePageSizes ='7, 15, 20, 50, 100';            
        }
        
        public NopOrderPayload (integer page, integer pageSize, integer start, integer length){
            this.Page = page;
            this.PageSize = pageSize;
            this.Start = start;
            this.Length = length;
            AvailablePageSizes ='7, 15, 20, 50, 100';            
        }
    } 

    
    
    public class NopReqAvailableCustomerRoles{
        public boolean Disabled = False;
        public string Groups;
        public boolean Selected = False;
        public string Text= 'Administrators';
        public string Value = '1';        
    }
    
    public class PicklistOption{
        
        @AuraEnabled public string label;
        @AuraEnabled public string value;
        @AuraEnabled public string description;        
    }    
}