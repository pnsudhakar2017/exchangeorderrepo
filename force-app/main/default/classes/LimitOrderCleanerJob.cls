public class LimitOrderCleanerJob implements Database.Batchable<SObject>, Schedulable {

    //public List<Database.Error> erroredRecords = new List<Database.Error>();
    //public Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    public Database.Querylocator start(Database.BatchableContext bc){
        String query = 'Select id, Status__c from Exchange_Order__c where status__c = \'Open\' and Time_In_Force__c = \'Day\'';
        return Database.getQuerylocator(query);
    }

    public void execute (Database.BatchableContext bc,List<Exchange_Order__c> recordsBatch){
        List<Exchange_Order__c> ordersToCancel = new List<Exchange_Order__c>();
        for(Exchange_Order__c order : recordsBatch){
            order.status__c = Utility.CANCELSTATUS;
            ordersToCancel.add(order);
        }
        Database.SaveResult[] saveResultList = Database.update(ordersToCancel,false); //Results can be used for Success/failure processing.
        /*for(Database.SaveResult sr : saveResultList){
            if (sr.isSuccess()) {
                System.debug('Order Cancellation is successful for ID: ' + sr.getId());
            }
            else {              
                for(Database.Error err : sr.getErrors()) {
                    System.debug('An error occored with status code: '+err.getStatusCode()+' and with error: '+err.getMessage());                    
                    erroredRecords.add(err);
                }
            }
        }*/
    }

    public void finish(Database.BatchableContext bc){
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
        TotalJobItems, CreatedBy.Email
        FROM AsyncApexJob WHERE Id =
        :BC.getJobId()];
        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        /*String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('OrderCancellation job status ' + a.Status);
        mail.setPlainTextBody('\r\n'+'The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures. Following are the errors: '+erroredRecords);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});*/
    }
    
    public void execute (System.Schedulablecontext sc) {
        LimitOrderCleanerJob batchJob = new LimitOrderCleanerJob();
        Database.executeBatch(batchJob,200);
    }

}