/**
 * @description       : 
 * @author            : Gabriel Mihaila
 * @group             : 
 * @last modified on  : 01-26-2022
 * @last modified by  : Gabriel Mihaila
**/
@isTest
public with sharing class UpdateAccountWeatherBatchTest {
    @testSetup 
    static void setup() {
        // Create common test accounts
        List<Account> accounts = new List<Account>();
        for(Integer i=0;i<20;i++) {
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
    static void tesBatch() {
        // Get the first test account by using a SOQL query
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WeatherHttpCalloutMock());
        UpdateAccountWeatherBatch batch = new UpdateAccountWeatherBatch(null,null); // Your batch class
        Database.executeBatch(batch);
        Test.stopTest();
    }
}
