import { LightningElement, track, wire, api } from 'lwc';
import saveNopMapping from '@salesforce/apex/NopCommerceTableMappingCtr.saveNopMapping';
import getNopMapping from '@salesforce/apex/NopCommerceTableMappingCtr.getNopMapping';
import getSFObjectInfo from '@salesforce/apex/NopCommerceTableMappingCtr.getSFObjectInfo';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Nop Field Label', fieldName: 'NopLabel' },
    { label: 'Nop Field API Name', fieldName: 'NopKey' },
    { label: 'Nop Data Type', fieldName: 'NopDataType' },
    { label: 'SF Mapping Fields', fieldName: 'SF_FieldName', editable: true }   
];

export default class NopCommerceTableMapping extends LightningElement {

    @api nopTableName;
    @api sfObjectName;
    @track pickListvalues;
    @track error;
    @track values;
    @track objectInfo;
    @track nopData;
    @track wiredobjectInfo;
    //nopDataDefinitions = [];
    
    connectedCallback() {
        //this.nopData = this.nopDataDefinitions[this.nopTableName];
        if(this.nopTableName == 'Customer'){
            this.nopData = this.nopCustomerData;;
        }
        else if(this.nopTableName == 'Product'){
            this.nopData = this.nopProductData;
        } 
        else if(this.nopTableName == 'Order'){
            this.nopData = this.nopOrderData;
        }
        else if(this.nopTableName == 'OrderItem'){
            this.nopData = this.nopOrderItemData;
        }
        

        console.log("sfObjectName ====="+this.sfObjectName);

        getSFObjectInfo( {sObjName: this.sfObjectName } )//sObjName: 'Contact' : this.sfObjectName
            .then(result => {
            console.log("Hlw =========="+ result);
            this.pickListvalues = result;
        }).catch(error => {
            console.log(error);
        });

        getNopMapping( {nopTable: this.nopTableName})
            .then(result => {
                var me = this;
                result.forEach(rec => {
                    me.nopData.forEach(nData => {
                        if(nData.NopKey == rec.Nop_Field__c) {
                            nData.SfFieldSelected = rec.SF_Field__c;
                            return;
                        }
                    });
                });    
            }).catch(error => {
                console.log(error);
            });
    }
    
    handleSaveMapping(event) {
        
        let allFields = this.template.querySelectorAll('.mapfield');
        let records = [];

        allFields.forEach(fld => {
            records.push({
                nopTable: this.nopTableName,
                nopFieldName: fld.dataset.nopFieldName,
                nopDataType: fld.dataset.nopDataType,
                sfFieldName: fld.value,
                sfObject: this.sfObjectName
                        });
        });
        
        saveNopMapping({params : records})
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: result.message,
                        variant: 'success'
                    })
                );
            }).catch(error => {
                console.log(error);
            });
    }
    
    handleSFFieldChange() { }

    nopCustomerData = [{
    //nopDataDefinitions = {'Customer':[]};
    //nopDataDefinitions['Customer'] = [{
    NopLabel: 'Id',
    NopKey: 'Id',
    NopDataType: 'Number'
}, {
    NopLabel: 'Username',
    NopKey: 'Username',
    NopDataType: 'String'
}, {
    NopLabel: 'Email',
    NopKey: 'Email',
    NopDataType: 'String'
}, {
    NopLabel: 'VendorId',
    NopKey: 'VendorId',
    NopDataType: 'Number'
}, {
    NopLabel: 'Gender',
    NopKey: 'Gender',
    NopDataType: 'Picklist'
}, {
    NopLabel: 'FirstName',
    NopKey: 'FirstName',
    NopDataType: 'String'
}, {
    NopLabel: 'LastName',
    NopKey: 'LastName',
    NopDataType: 'String'
}, {
    NopLabel: 'FullName',
    NopKey: 'FullName',
    NopDataType: 'String'
}, {
    NopLabel: 'DateOfBirth',
    NopKey: 'DateOfBirth',
    NopDataType: 'Date'
}, {
    NopLabel: 'Company',
    NopKey: 'Company',
    NopDataType: 'String'
}, {
    NopLabel: 'StreetAddress',
    NopKey: 'StreetAddress',
    NopDataType: 'String'
}, {
    NopLabel: 'StreetAddress2',
    NopKey: 'StreetAddress2',
    NopDataType: 'String'
}, {
    NopLabel: 'ZipPostalCode',
    NopKey: 'ZipPostalCode',
    NopDataType: 'Number'
}, {
    NopLabel: 'City',
    NopKey: 'City',
    NopDataType: 'String'
}, {
    NopLabel: 'Country',
    NopKey: 'Country',
    NopDataType: 'String'
}, {
    NopLabel: 'Phone',
    NopKey: 'Phone',
    NopDataType: 'Number'
}, {
    NopLabel: 'Fax',
    NopKey: 'Fax',
    NopDataType: 'String'
}, {
    NopLabel: 'RegisteredInStore',
    NopKey: 'RegisteredInStore',
    NopDataType: 'String'
}, {
    NopLabel: 'Active',
    NopKey: 'Active',
    NopDataType: 'Boolean'
}, {
    NopLabel: 'AffiliateId',
    NopKey: 'AffiliateId',
    NopDataType: 'Number'
}, {
    NopLabel: 'AffiliateName',
    NopKey: 'AffiliateName',
    NopDataType: 'String'
}, {
    NopLabel: 'TimeZoneId',
    NopKey: 'TimeZoneId',
    NopDataType: 'Number'
}, {
    NopLabel: 'VatNumber',
    NopKey: 'VatNumber',
    NopDataType: 'Number'
}, {
    NopLabel: 'CreatedOn',
    NopKey: 'CreatedOn',
    NopDataType: 'String'   
}, {
    NopLabel: 'LastActivityDate',
    NopKey: 'LastActivityDate',
    NopDataType: 'String'
}, {
    NopLabel: 'AddRewardPoints',
    NopKey: 'AddRewardPoints',
    NopDataType: 'Number'
}];


nopProductData = [{
    NopLabel: 'PictureThumbnailUrl',
    NopKey: 'PictureThumbnailUrl',
    NopDataType: 'URL'
}, {
    NopLabel: 'ProductTypeId',
    NopKey: 'ProductTypeId',
    NopDataType: 'String'
}, {
    NopLabel: 'ProductTypeName',
    NopKey: 'ProductTypeName',
    NopDataType: 'String'
}, {
    NopLabel: 'VisibleIndividually',
    NopKey: 'VisibleIndividually',
    NopDataType: 'Checkbox'
}, {
    NopLabel: 'ProductTemplateId',
    NopKey: 'ProductTemplateId',
    NopDataType: 'Number'
}, {
    NopLabel: 'Name',
    NopKey: 'Name',
    NopDataType: 'String'
}, {
    NopLabel: 'ShortDescription',
    NopKey: 'ShortDescription',
    NopDataType: 'String'
}, {
    NopLabel: 'FullDescription',
    NopKey: 'FullDescription',
    NopDataType: 'String'
}, {
    NopLabel: 'ShowOnHomepage',
    NopKey: 'ShowOnHomepage',
    NopDataType: 'Checkbox'
}, {
    NopLabel: 'SeName',
    NopKey: 'SeName',
    NopDataType: 'String'
}, {
    NopLabel: 'AllowCustomerReviews',
    NopKey: 'AllowCustomerReviews',
    NopDataType: 'Checkbox'
}, {
    NopLabel: 'Sku',
    NopKey: 'Sku',
    NopDataType: 'String'
}, {
    NopLabel: 'HasUserAgreement',
    NopKey: 'HasUserAgreement',
    NopDataType: 'Checkbox'
}, {
    NopLabel: 'UserAgreementText',
    NopKey: 'UserAgreementText',
    NopDataType: 'String'
}, {
    NopLabel: 'IsRental',
    NopKey: 'IsRental',
    NopDataType: 'Checkbox'
}, {
    NopLabel: 'DeliveryDateId',
    NopKey: 'DeliveryDateId',
    NopDataType: 'Number'
}, {
    NopLabel: 'StockQuantity',
    NopKey: 'StockQuantity',
    NopDataType: 'Number'
}, {
    NopLabel: 'Price',
    NopKey: 'Price',
    NopDataType: 'Number'
}, {
    NopLabel: 'OldPrice',
    NopKey: 'OldPrice',
    NopDataType: 'Boolean'
}, {
    NopLabel: 'ProductCost',
    NopKey: 'ProductCost',
    NopDataType: 'Number'
}, {
    NopLabel: 'BasepriceBaseAmount',
    NopKey: 'BasepriceBaseAmount',
    NopDataType: 'String'
}, {
    NopLabel: 'BasepriceBaseUnitId',
    NopKey: 'BasepriceBaseUnitId',
    NopDataType: 'Number'
}, {
    NopLabel: 'MarkAsNew',
    NopKey: 'MarkAsNew',
    NopDataType: 'Checkbox'
}, {
    NopLabel: 'Weight',
    NopKey: 'Weight',
    NopDataType: 'String'   
}, {
    NopLabel: 'Length',
    NopKey: 'Length',
    NopDataType: 'String'
}, {
    NopLabel: 'Width',
    NopKey: 'Width',
    NopDataType: 'Number'
}, {
    NopLabel: 'Height',
    NopKey: 'Height',
    NopDataType: 'Number'
}, {
    NopLabel: 'DisplayOrder',
    NopKey: 'DisplayOrder',
    NopDataType: 'Number'
}, {
    NopLabel: 'Published',
    NopKey: 'Published',
    NopDataType: 'Checkbox'
}, {
    NopLabel: 'VendorId',
    NopKey: 'VendorId',
    NopDataType: 'Number'
}];


nopOrderData = [{
    //nopDataDefinitions = {'Customer':[]};
    //nopDataDefinitions['Customer'] = [{

            NopLabel: 'Id',
            NopKey: 'Id',
            NopDataType: 'Number'
        }, {
            NopLabel: 'CustomOrderNumber',
            NopKey: 'CustomOrderNumber',
            NopDataType: 'Number'
        }, {
            NopLabel: 'OrderStatus',
            NopKey: 'OrderStatus',
            NopDataType: 'Picklist'
        }, {
            NopLabel: 'StoreName',
            NopKey: 'StoreName',
            NopDataType: 'String'
        }, {
            NopLabel: 'CustomerEmail',
            NopKey: 'CustomerEmail',
            NopDataType: 'String'
        }, {
            NopLabel: 'CustomerFullName',
            NopKey: 'CustomerFullName',
            NopDataType: 'String'
        }, {
            NopLabel: 'OrderTotal',
            NopKey: 'OrderTotalr',
            NopDataType: 'Price'
        }, {
            NopLabel: 'IsLoggedInAsVendor',
            NopKey: 'IsLoggedInAsVendor',
            NopDataType: 'Boolean'
        }, {
            NopLabel: 'PaymentStatus',
            NopKey: 'PaymentStatus',
            NopDataType: 'Picklist'
        }, {
            NopLabel: 'CustomerId',
            NopKey: 'CustomerId',
            NopDataType: 'Number'        
}];

//Product Order//
nopOrderItemData = [{
    //nopDataDefinitions = {'Customer':[]};
    //nopDataDefinitions['Customer'] = [{
        
            NopLabel: 'ProductId',
            NopKey: 'ProductId',
            NopDataType: 'Number'
        }, {
            NopLabel: 'ProductName',
            NopKey: 'ProductName',
            NopDataType: 'String'
        }, {
            NopLabel: 'VendorName',
            NopKey: 'VendorName',
            NopDataType: 'String'
        }, {
            NopLabel: 'Sku',
            NopKey: 'Sku',
            NopDataType: 'String'
        }, {
            NopLabel: 'PictureThumbnailUrl',
            NopKey: 'PictureThumbnailUrl',
            NopDataType: 'Url'
        }, {
            NopLabel: 'UnitPriceInclTaxValue',
            NopKey: 'UnitPriceInclTaxValue',
            NopDataType: 'Price'
        },  {
            NopLabel: 'UnitPriceExclTaxValue',
            NopKey: 'UnitPriceExclTaxValue',
            NopDataType: 'Price'
        }, {
            NopLabel: 'Quantity',
            NopKey: 'Quantity',
            NopDataType: 'Number'
        }, {
            NopLabel: 'DiscountInclTaxValue',
            NopKey: 'DiscountInclTaxValue',
            NopDataType: 'Price'
        }, {
            NopLabel: 'DiscountExclTaxValue',
            NopKey: 'DiscountExclTaxValue',
            NopDataType: 'Price'
        }, {
            NopLabel: 'SubTotalInclTaxValue',
            NopKey: 'SubTotalInclTaxValue',
            NopDataType: 'Price'
        }, {
            NopLabel: 'SubTotalExclTaxValue',
            NopKey: 'SubTotalExclTaxValue',
            NopDataType: 'Price'
        }, {
            NopLabel: 'AttributeInfo',
            NopKey: 'AttributeInfo',
            NopDataType: 'String'
        }, {
            NopLabel: 'IsDownload',
            NopKey: 'IsDownload',
            NopDataType: 'Boolean'
        }, {
            NopLabel: 'Id',
            NopKey: 'Id',
            NopDataType: 'Number'
        } ];

}