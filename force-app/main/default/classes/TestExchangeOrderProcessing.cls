@isTest
private class TestExchangeOrderProcessing {
/** 
    verifies order creation and their statuses
*/
 static testMethod void testOrderCreation() {
    Exchange_Order__c sellOrder = TestUtility.createOrder('Sell', 'Market', 100, 10,'');
    Exchange_Order__c buyOrder = TestUtility.createOrder('Buy', 'Market', 101, 10,'');
    Test.startTest();
    sellOrder = TestUtility.getOrderById(sellOrder.id);
    buyOrder = TestUtility.getOrderById(buyOrder.id);
    System.assertEquals(sellOrder.Status__c, 'Open');
    System.assertEquals(buyOrder.Status__c, 'Open');
    Test.stopTest();
 }
 
/** 
    verifies order filling on creation/finding of match and verifies their statuses as Filled
*/
 static testMethod void testOrderMatch() {
    Exchange_Order__c sellOrder = TestUtility.createOrder('Sell', 'Market', 100, 10,'');
    Exchange_Order__c buyOrder = TestUtility.createOrder('Buy', 'Market', 100, 10,'');
    Exchange_Order_Match__c orderMatch = TestUtility.createOrderMatch(sellOrder.id, buyOrder.id);
    Test.startTest();
    sellOrder = TestUtility.getOrderById(sellOrder.id);
    buyOrder = TestUtility.getOrderById(buyOrder.id);
    System.assertEquals(sellOrder.Status__c, 'Filled');
    System.assertEquals(buyOrder.Status__c, 'Filled');
    Test.stopTest();
 }
 
 /**
     verifies whether limit order with no match has been cancelled at the end with status as Cancelled
 */
 static testMethod void testLimitOrderCancelling() {
    Exchange_Order__c sellOrder = TestUtility.createOrder('Sell', 'Limit', 100, 10,'FoK (Fill or Kill)');
    Test.startTest();
    sellOrder = TestUtility.getOrderById(sellOrder.id);
    System.assertEquals(sellOrder.Status__c, 'Cancelled');
    Test.stopTest();
 }
}