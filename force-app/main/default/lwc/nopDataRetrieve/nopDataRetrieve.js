import { LightningElement ,track, wire, api} from 'lwc';
import retrieveNopData from '@salesforce/apex/NopReqDataService.retrieveNopData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class NopDataRetrieve extends LightningElement {

    isLoading = false;
    @api nopTableName;
    @api sfObjectName;
    @api nopExternalValue;
    @track error;
    
    connectedCallback() {}
    
    handleStartSync(event) {
        if(!this.isLoading){
            this.isLoading = true;
        }
        
        retrieveNopData({sObjName:this.sfObjectName ,nopTableName:this.nopTableName, nopExternalKey:this.nopExternalValue})
        .then(result => {
            console.log("In call back");
            this.isLoading = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message:'Successfully Saved'+success.message,
                    variant: 'success'
                })
            );

        }).catch(error => {
            console.log(error);
            console.log("In call back catch");
            this.isLoading = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Failed',
                    message:'Failed. '+error.message,
                    variant: 'error'
                })
            );
        });     
        
        console.log("After call back");
       
    }
    
    handleSFFieldChange() { }
}
