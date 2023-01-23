/**
 * ExchangeOrderRestResource Description
 * It's Rest resource exposed with apis to handle create, update exchange orders and also for fetching order information.
 * @author undefined
 * @version Version number
 */
@RestResource(urlMapping='/order/*')
global class ExchangeOrderRestResource {

    /**
     * createOrder Description
     * creates exchange order with the given information.
     * @param orderToCreate (Exchange_Order__c): input order object to create.
     * @return String: returns status with created order information.
     */
    @HttpPost
    global static String createOrder(Exchange_Order__c orderToCreate){
       String result = '';
       try{
           insert orderToCreate;
           result = 'Order with id: '+orderToCreate.id+'has been created successfully as : '+orderToCreate;
       }catch(DmlException ex){
           result = 'Order creation has been failed with error :'+ex.getMessage();
       }
       return result;
    }
    
    /**
     * updateOrder Description
     * updates the exchange order as given information.
     * @param orderToUpdate (Exchange_Order__c): input order object
     * @return String: returns status with updated order information.
     */
    @HttpPut
    global static String updateOrder(Exchange_Order__c orderToUpdate){
       String result = '';
       try{
           update orderToUpdate;
           result = 'Order with id: '+orderToUpdate.id+'has been updated successfully as: '+orderToUpdate;
       }catch(DmlException ex){
           result = 'Order update has been failed with error :'+ex.getMessage();
       }
       return result;
    }
    
    /**
     * getOrder Description
     * queries and returns the information for the given order id.
     * @return String: returns order information.
     */
    @HttpGet
    global static String getOrder(){
        String orderId = RestContext.request.params.get('id');
        try{ 
            List<Exchange_Order__c> orderRecord = [SELECT Id, Name, Security__c, Order_Side__c,Order_Type__c, Quantity__c,Time_In_Force__c,Order_Total__c FROM Exchange_Order__c WHERE Id = :orderId WITH SECURITY_ENFORCED LIMIT 1];
            if(orderRecord.isEmpty()){
                return 'no records found for the given id: '+orderId; 
            }else{
                return 'fetched order for the given id: '+orderRecord; 
            }
        }catch(QueryException ex){
            return  'Order Fetch has been failed with error :'+ex.getMessage();
        }
    }
}