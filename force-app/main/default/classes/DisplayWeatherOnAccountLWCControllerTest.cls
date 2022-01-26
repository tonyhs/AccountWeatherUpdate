/**
 * @description       : 
 * @author            : Gabriel Mihaila
 * @group             : 
 * @last modified on  : 01-26-2022
 * @last modified by  : Gabriel Mihaila
**/
@isTest
public with sharing class DisplayWeatherOnAccountLWCControllerTest {
   
    @testSetup 
    static void setup() {
        // Create common test accounts
        List<Account> accounts = new List<Account>();
        for(Integer i=0;i<2;i++) {
            Account account = new Account();
            account.Name = 'TestAcct'+i;
            account.BillingCity = 'Voluntari';
            account.BillingCountry = 'Romania';
            account.BillingPostalCode ='077190';
            account.BillingState = '';
            account.BillingStreet = 'Popasului';
            accounts.add(account);
        }
        insert accounts;        
    }

    @isTest 
    static void tesGetAccountMethod() {
        // Get the first test account by using a SOQL query
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WeatherHttpCalloutMock());
        Account account1 = [SELECT Id, Name,BillingCity,BillingCountry,BillingPostalCode,BillingState,
                            BillingStreet, AccountCurrentWeather__c 
                            FROM Account
                            WHERE Name='TestAcct0' LIMIT 1];
        account1.AccountCurrentWeather__c='light rain';
        List<Account> accountsToCheck1 = DisplayWeatherOnAccountLWCController.getAccounts(account1.Id);

        System.assertEquals(accountsToCheck1[0],account1);
        
        Account account2 = [SELECT Id, Name,BillingCity,BillingCountry,BillingPostalCode,BillingState,
                            BillingStreet, AccountCurrentWeather__c 
                            FROM Account
                            WHERE Name='TestAcct1' LIMIT 1];
        account2.AccountCurrentWeather__c='light rain';
        List<Account> accountsToCheck2 = DisplayWeatherOnAccountLWCController.getAccounts(account2.Id);

        System.assertEquals(accountsToCheck2[0],account2);
        Test.stopTest();
    }

}
