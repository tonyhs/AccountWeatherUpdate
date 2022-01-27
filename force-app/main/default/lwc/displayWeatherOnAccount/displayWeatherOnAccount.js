import { LightningElement, wire,api,track } from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';
import getAccounts from '@salesforce/apex/DisplayWeatherOnAccountLWCController.getAccounts';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
export default class DisplayWeatherOnAccount extends LightningElement {
    
    @api recordId;
    @api channelName = "/data/AccountChangeEvent";

    subscription = {}; //subscription information
    responseMessage; //message to be shown at UI
    isDisplayMsg; //indicator for message to be displayed
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

    connectedCallback() {       
        this.handleSubscribe();
        // Register error listener       
        this.registerErrorListener();   
        this.isDisplayMsg = false;   
    }

    // Handles subscribing
    handleSubscribe() {
        // Callback invoked whenever a new event message is received
        const messageCallback = (response) => {
            console.log('New message received: ', JSON.stringify(response));
            // Response contains the payload of the new message received
            this.handleNotification(response);
        };

        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, messageCallback).then(response => {
            // Response contains the subscription information on subscribe call
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
            this.handleNotification(response);
        });
    }

    // Handles unsubscribing
    handleUnsubscribe() {
        // Invoke unsubscribe method of empApi
        unsubscribe(this.subscription, response => {
            console.log('unsubscribe() response: ', JSON.stringify(response));
            // Response is true for successful unsubscribe
        });
    }


    registerErrorListener() {
        // Invoke onError empApi method
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }

    //this method checks if current record got updated and shows message on UI
    handleNotification(response){
        if(response.hasOwnProperty('data')){
            let jsonObj = response.data;
            
            if(jsonObj.hasOwnProperty('payload')){
                let payload = response.data.payload;
                let recordIds = payload.ChangeEventHeader.recordIds;

                //find the current recordId in the array and if found then display message
                const recId = recordIds.find(element=> element == this.recordId);
                if(recId !=undefined){
                    this.isDisplayMsg = true;
                    this.responseMessage = 'Current record has changed, please refresh the page';
                    //this.handleRefresh()
                    getRecordNotifyChange([{recordId: this.recordId}]);
                    window.location.reload()
                   
                }
            }
        }
    }

    //this method refreshes current record page
    handleRefresh(){
        getRecordNotifyChange([{recordId: this.recordId}]);
        this.isDisplayMsg = false;
    }
}