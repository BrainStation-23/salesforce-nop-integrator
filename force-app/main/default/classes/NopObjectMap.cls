public class NopObjectMap {
    public void MapObject(){
        List<Nop_Mapping__c> listNP = [Select Id, SF_Object__c, SF_Field__c, Nop_Table__c, Nop_Field__c FROM Nop_Mapping__c  LIMIT 2];
        
        for(Nop_Mapping__c np :  listNP){
            
        }
        
    }
}