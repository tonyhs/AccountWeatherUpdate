/**
 * @description       : 
 * @author            : Gabriel Mihaila
 * @group             : 
 * @last modified on  : 01-25-2022
 * @last modified by  : Gabriel Mihaila
**/
public with sharing class CalloutUtils {
   
    public static string getAccountWeather(Decimal latitude, Decimal longitude) {

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('https://api.openweathermap.org/data/2.5/onecall?lat='+latitude+'&lon='+longitude+'&exclude='+Label.OpenWeatherMapsExclude+'&appid='+Label.OpenWeatherMaps);
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        String weatherDescription;
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug(JSON.serializePretty(results));
            System.debug(JSON.serializePretty(results.get('weather')));
            // Cast the values in the 'animals' key as a list]
            Map<String, Object>  currentWeather = (Map<String, Object>) results.get('current');
            List<Object> weatherDescriptions = (List<Object>) currentWeather.get('weather');
            System.debug('Received the following descriptions:');
            // Iterate over the results and get the weather description.
            for(Object description : weatherDescriptions) {
                System.debug(description);
                WrapResponse tempDescription = (WrapResponse)JSON.deserialize(JSON.serialize(description), WrapResponse.class);
                weatherDescription = tempDescription.description;
            }
            
        }

        return weatherDescription;
    }
    public class WrapResponse {
        public String description {get; set;}
 
        //This is the contructor method. When we create a new wrapAccount object we pass a Account that is set to the acc property. We also set the selected value to false
        public WrapResponse(String wr) {
            description = wr;
        }
    }
}
