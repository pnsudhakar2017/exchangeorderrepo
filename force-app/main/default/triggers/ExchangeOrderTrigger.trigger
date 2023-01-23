trigger ExchangeOrderTrigger on Exchange_Order__c (after insert,after update) {
    if(Utility.triggerFirstRun()){
        //after
        if(Trigger.isAfter){
            //insert
            if(Trigger.isInsert){
                ExchangeOrderHelper.processExchangeOrder(Trigger.New);
            }
            //udpate
            if(Trigger.isUpdate){
                ExchangeOrderHelper.processExchangeOrder(Trigger.New);
            }
        }
    }
}