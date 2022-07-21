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
    }
    
    public class NopReqData{
        
        public integer SelectedCustomerRoleIds;
        public integer Page;
        public integer PageSize;
        public string AvailablePageSizes;
        public string Draw;
        public integer Start;
        public integer Length;
        public map<String, String> CustomProperties;
        public NopReqAvailableCustomerRoles AvailableCustomerRoles;
        public NopReqData (){
            CustomProperties = new map<String, String>();
            AvailablePageSizes ='7, 15, 20, 50, 100';
            AvailableCustomerRoles = new NopReqAvailableCustomerRoles();
        }
    }
    public class NopReqAvailableCustomerRoles{
        public boolean Disabled;
        public string Groups;
        public boolean Selected;
        public string Text= 'Administrators';
        public integer Value;
        
    }

}