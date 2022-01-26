/**
 * @description       : 
 * @author            : Gabriel Mihaila
 * @group             : 
 * @last modified on  : 01-26-2022
 * @last modified by  : Gabriel Mihaila
**/
global with sharing class UpdateAccountWeatherBatch implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts {

    global Set<Id> accountsId;
    public Map<String, String> inheritedErrors;
    private String query;

    public UpdateAccountWeatherBatch (Set<Id> accountsIds,Map<String, String> errors) {
		if (accountsIds != null) {
			this.accountsId = accountsIds;
		} else {
			this.accountsId = new Set<Id>();
		}
        if (errors != null) {
			this.inheritedErrors = errors;
		} else {
			this.inheritedErrors = new Map<String, String>();
		}
	}

    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('in start');
        Set<String> inheritedErrorsKeys = inheritedErrors.keySet();

        query = 'SELECT Id, Name,BillingCity,BillingCountry,BillingPostalCode,BillingState, ' +
                'BillingStreet, BillingLatitude, BillingLongitude,AccountCurrentWeather__c ' +
                'FROM Account ' +
                'WHERE Id NOT IN :accountsId AND Id NOT IN :inheritedErrorsKeys LIMIT 10 ';

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> accounts){
        
        for(Account account : accounts){
            account.AccountCurrentWeather__c = CalloutUtils.getAccountWeather(account.BillingLatitude, account.BillingLongitude);
            accountsId.add(account.Id);
        }

        Database.SaveResult[] saveResult = Database.Update(accounts, false);
        errorHandling(saveResult,accounts);
    }

    global void finish(Database.BatchableContext BC){
        
        Set<String> inheritedErrorsKeys = inheritedErrors.keySet();
        List<Account> accounts = new List<Account>();
        for(Account account : database.query(query)) {
            accounts.add(account);
        }

        if(accounts.size() > 0) {
            UpdateAccountWeatherBatch batchCls = new UpdateAccountWeatherBatch(this.accountsId,this.inheritedErrors);
            Database.executeBatch(batchCls);
        }
        else {
            List<ErrorLog__c> errorLogs = new List<ErrorLog__c>();
            for(Account account : accounts) {
                ErrorLog__c errorLog = new ErrorLog__c();
                errorLog.ErrorDescription__c = 'The Account with id: ' + account.Id + ' encounter the following errors: ' + inheritedErrors.get(account.Id) + ' in UpdateAccountWeatherBatch.';
                errorLogs.add(errorLog);
            }
            Database.SaveResult[] saveResultErrorLogs = Database.Insert(errorLogs, false);
            // insert the errors in a log object
        }
    }

    global void errorHandling(Database.SaveResult[] saveresult,List<Account> accounts){
        Integer counter = 0;
			for(Database.SaveResult sr : saveresult) {
				if(!sr.isSuccess()) {
					String errorMessage;
					for(Database.Error err : sr.getErrors()) {
						errorMessage += err.getStatusCode() + ': ' + err.getMessage();
						errorMessage += 'Fields that affected this error: ' + err.getFields();
					}
					Id recordId = accounts.get(counter).Id;

					if(inheritedErrors.containsKey(recordId)) {
						inheritedErrors.put(recordId, inheritedErrors.get(recordId) + errorMessage);
					} else {
						inheritedErrors.put(recordId, errorMessage);
					}
				}
				counter++;
			}
    }
}
