/**
 * @description       : 
 * @author            : Gabriel Mihaila
 * @group             : 
 * @last modified on  : 01-25-2022
 * @last modified by  : Gabriel Mihaila
**/
public with sharing class DisplayWeatherOnAccountLWCController {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String accountId) {
    
        List<Account> accounts = new List<Account>();
        accounts = [SELECT Id, Name,BillingCity,BillingCountry,BillingPostalCode,BillingState,
                    BillingStreet, BillingLatitude, BillingLongitude,AccountCurrentWeather__c 
                    FROM Account
                    WHERE Id = :accountId];
        
        for(Account account : accounts) {
            account.AccountCurrentWeather__c = CalloutUtils.getAccountWeather(account.BillingLatitude, account.BillingLongitude);
        }
    
        return accounts;
    }
}
