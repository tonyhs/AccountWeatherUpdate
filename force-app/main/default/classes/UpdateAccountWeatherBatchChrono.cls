/**
 * @description       : 
 * @author            : Gabriel Mihaila
 * @group             : 
 * @last modified on  : 01-26-2022
 * @last modified by  : Gabriel Mihaila
**/
public with sharing class UpdateAccountWeatherBatchChrono {
    
    public static void startBatch(){

        String cronID = System.scheduleBatch( new UpdateAccountWeatherBatch(null,null), 'Update Account Weather', 60);

    }

}
