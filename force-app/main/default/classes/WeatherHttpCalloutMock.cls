/**
 * @description       : 
 * @author            : Gabriel Mihaila
 * @group             : 
 * @last modified on  : 01-26-2022
 * @last modified by  : Gabriel Mihaila
**/
@isTest
global with sharing class WeatherHttpCalloutMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"lat": 33.44,"lon": -94.04,"timezone": "America/Chicago","timezone_offset": -21600, "current": {"dt": 1618317040,"sunrise": 1618282134,"sunset": 1618333901,' +
                         '"temp": 284.07,"feels_like": 282.84,"pressure": 1019,"humidity": 62,"dew_point": 277.08,"uvi": 0.89,"clouds": 0,"visibility": 10000,"wind_speed": 6,"wind_deg": 300,' +
                         '"weather":[{"id": 500,"main": "Rain", "description":"light rain","icon":"10d"}]}}');
        response.setStatusCode(200);
        return response; 
    }
}
