trigger ExchangeOrderMatchTrigger on Exchange_Order_Match__c (after insert) {
    //before
    if(Trigger.isAfter){
        //insert
        if(Trigger.isInsert){
            ExchangeOrderHelper.fillMatchedOrders(Trigger.New);
        }
    }
}