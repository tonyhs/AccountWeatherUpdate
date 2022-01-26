import { LightningElement, wire,api,track } from 'lwc';
import { getSObjectValue } from '@salesforce/apex';
import getAccounts from '@salesforce/apex/DisplayWeatherOnAccountLWCController.getAccounts';
import { updateRecord } from 'lightning/uiRecordApi';
import StayInTouchSignature from '@salesforce/schema/User.StayInTouchSignature';

export default class DisplayWeatherOnAccount extends LightningElement {
    
    @api recordId;
    accounts;
    weatherDescription;

    @wire(getAccounts, { accountId: '$recordId' })
    wiredRelatedRecords(result) {

        this.accounts = result;
        if(this.accounts.data != undefined) {
            this.weatherDescription =this.accounts.data[0].AccountCurrentWeather__c
        }
    }

    refreshWeather() {
        getAccounts({ accountId: this.recordId }).then((result) => {
            let inputList = this.template.querySelectorAll("[data-id='" + this.recordId + "']");
            for (let input of inputList) {
                if(result != undefined) {
                    this.weatherDescription = result[0].AccountCurrentWeather__c
                    input.value = result[0].AccountCurrentWeather__c
                } 
            }
        })
    }
}