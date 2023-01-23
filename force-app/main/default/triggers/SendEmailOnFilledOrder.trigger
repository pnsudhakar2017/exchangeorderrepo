trigger SendEmailOnFilledOrder on FilledExchangeOrders__e (after insert) {
try{
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    for(FilledExchangeOrders__e event :Trigger.New){
        String[] toAddresses = new String[] {event.Email__c};
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Order Management');
        mail.setSubject('Order has been filled');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody('Congratulations, your order with id: '+event.Order_Id__c+' has been filled.');
        mails.add(mail);
    }
    if(!mails.isEmpty()){
        Messaging.sendEmail(mails);
    }
    }catch(Exception ex){
        System.debug('**** event trigger email has been sent');
    }
}