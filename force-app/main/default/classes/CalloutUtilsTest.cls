/**
 * @description       : 
 * @author            : Gabriel Mihaila
 * @group             : 
 * @last modified on  : 01-26-2022
 * @last modified by  : Gabriel Mihaila
**/
@isTest 
public with sharing class CalloutUtilsTest {
    
    @isTest 
    public static void testGetCallout() {
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, new WeatherHttpCalloutMock());
        // Call method to test
        String result = CalloutUtils.getAccountWeather(33.44,-94.04);
        System.assertEquals('light rain',result);
    }   

}
