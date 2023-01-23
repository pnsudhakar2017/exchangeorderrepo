public class TestUtility{

    public static Security__c  createSecurity(String Name){
         Security__c security = new Security__c(Name = Name , Symbol__c = Name);
         insert security;
         return security;
    }
    public static Exchange_Order__c createOrder(String orderSide, String orderType, Integer price, Integer quantity, String TimeInForce){
         Exchange_Order__c order = new Exchange_Order__c(Order_Side__c =orderSide , Order_Type__c=orderType , Quantity__c=quantity, Price__c=price, Security__c = TestUtility.createSecurity('test').id, Time_in_Force__c = TimeInForce);
         insert order;
         return order;
    }
    
    public static Exchange_Order_Match__c createOrderMatch(String sellOrderId, String buyOrderId){
        Exchange_Order_Match__c orderMatch = new Exchange_Order_Match__c(Sell_Order__c=sellOrderId , Buy_Order__c=buyOrderId);
        insert orderMatch;
        return orderMatch;
    }
    
    public static Exchange_Order_Match__c getOrderMatch(String sellOrderId, String buyOrderId){
        return [select id,Sell_Order__c,Buy_Order__c from Exchange_Order_Match__c where Sell_Order__c=: sellOrderId and Buy_Order__c =: buyOrderId]; 
    }
    
    public static Exchange_Order__c getOrderById(String orderId){
        return [select id,Status__c from Exchange_Order__c where id =: orderId limit 1]; 
    }
}