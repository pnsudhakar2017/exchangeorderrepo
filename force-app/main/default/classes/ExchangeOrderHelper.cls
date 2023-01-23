/**
 * ExchangeOrderHelper Description:
 * It process the exchange orders as per their order-side, order-type and other information.
 * creates the ExchangeOrderMatch records with sell-order and buy-order if match found and Fills the matched orders.
 * cancels the limit orders with Time-in-Force as "FoK (Fill or Kill)" if there is no match found.
 * @author developer
 */
public class ExchangeOrderHelper {

    public static void processExchangeOrder(List<Exchange_Order__c> newExchangeOrders){
        try{
            Set<Exchange_Order__c> existingOrders = new Set<Exchange_Order__c>();
            Map<Exchange_Order__c, Exchange_Order__c> matchedOrdersMap = new Map<Exchange_Order__c, Exchange_Order__c>();
            List<Exchange_Order_Match__c> exchangeOrderMatchesToCreate = new List<Exchange_Order_Match__c>();
            List<Exchange_Order__c> ordersToCancel = new List<Exchange_Order__c>();
            Boolean isSellOrder = false;
            existingOrders.addAll(getExistingOrders());
            for(Exchange_Order__c newExchangeOrder : newExchangeOrders){
                isSellOrder = (newExchangeOrder.Order_Side__c == Utility.SELLSIDE ? true : false);
                Exchange_Order__c matchedOrder = findOrderToMatch(newExchangeOrder, existingOrders);
                if(matchedOrder != null){
                    existingOrders.remove(matchedOrder);
                    matchedOrdersMap.put(newExchangeOrder, matchedOrder);
                    exchangeOrderMatchesToCreate.add(new Exchange_Order_Match__c(Price__c=newExchangeOrder.Price__c,Quantity__c=newExchangeOrder.Quantity__c,Sell_Order__c=(isSellOrder ? newExchangeOrder.Id : matchedOrder.Id),Buy_Order__c=(isSellOrder ? matchedOrder.Id : newExchangeOrder.Id)));
                }else if(newExchangeOrder.Order_Type__c == Utility.LIMITTYPE && newExchangeOrder.Time_in_Force__c == Utility.FOKLIMIT){
                    ordersToCancel.add(new Exchange_Order__c(id=newExchangeOrder.id, Status__c = Utility.CANCELSTATUS));
                }
            }
            if(!exchangeOrderMatchesToCreate.isEmpty()){
                Database.insert(exchangeOrderMatchesToCreate,false);
            }
            if(!ordersToCancel.isEmpty()){
                Database.update(ordersToCancel,false);
            }
        }catch(Exception ex){
            System.debug('There is some error while processing, please contact sys-admin: '+ex.getMessage());
        }
    }

    /**
     * findOrderToMatch Description
     *
     * @param newExchangeOrder (Exchange_Order__c): new order created
     * @param existingOrdersToVerify (Set<Exchange_Order__c>): existing exchange orders
     * @return Exchange_Order__c: matched exchange order, it returns null if no match found.
     */
    public static Exchange_Order__c findOrderToMatch(Exchange_Order__c newExchangeOrder, Set<Exchange_Order__c> existingOrdersToVerify){
        Exchange_Order__c matchedOrder = null;
        String orderSideToMatch = (newExchangeOrder.Order_Side__c == Utility.SELLSIDE ? Utility.BUYSIDE : Utility.SELLSIDE);
        for(Exchange_Order__c order : existingOrdersToVerify){
            if(order.Security__c == newExchangeOrder.Security__c &&
                order.Order_Side__c == orderSideToMatch && 
                order.Order_Type__c == newExchangeOrder.Order_Type__c && 
                order.Quantity__c == newExchangeOrder.Quantity__c &&
                order.Price__c == newExchangeOrder.Price__c){
                    matchedOrder = order;
                    break;
            }
        }
        return matchedOrder;
    }

    /**
     * getExistingOrders Description
     * queries the existing open exchange orders and returns.
     * @return List<Exchange_Order__c>: existing open exchange orders.
     * query: this has been placed in custom label and refered 
     * select id, Order_Side__c, Order_Total__c, Order_Type__c, Price__c,       Quantity__c, Security__c, 
        Status__c, Time_in_Force__c from Exchange_Order__c where Status__c = 'Open' ORDER BY CreatedDate
     */
    public static List<Exchange_Order__c> getExistingOrders(){
        List<Exchange_Order__c> existingOrders = new List<Exchange_Order__c>();
        existingOrders = Database.query(Label.SOQL_to_query_existing_orders);
        return existingOrders;
    }
    
    /**
     * fillMatchedOrders Description
     * fills the matched sell-order and buy-order
     * @param newExchangeOrderMatches (List<Exchange_Order_Match__c>): exchange orders to fill
     * @throws Class name here Write the class description
     */
    public static void fillMatchedOrders(List<Exchange_Order_Match__c> newExchangeOrderMatches){
        List<Exchange_Order__c> exchangeOrdersToFill = new List<Exchange_Order__c>();
        for(Exchange_Order_Match__c newExchangeOrderMatch : newExchangeOrderMatches){
            exchangeOrdersToFill.add(new Exchange_Order__c(id=newExchangeOrderMatch.Sell_Order__c, Status__c='Filled'));
            exchangeOrdersToFill.add(new Exchange_Order__c(id=newExchangeOrderMatch.Buy_Order__c, Status__c='Filled'));
        }
        if(!exchangeOrdersToFill.isEmpty()){
            Database.update(exchangeOrdersToFill,false);
            generateEmailEventForFilledOrders(exchangeOrdersToFill);
        }
    }
    
    /**
     * generateEmailEventForFilledOrders 
     * it creates events into Platform Event which in turn sends an email to owner on order fulfilment.
     * @param exchangeOrdersToFill (List<Exchange_Order__c>): order to push for event
     */
    public static void generateEmailEventForFilledOrders(List<Exchange_Order__c> exchangeOrdersToFill){
    List<FilledExchangeOrders__e> platformEventList = new List<FilledExchangeOrders__e>();
        for(Exchange_Order__c filledOrder : exchangeOrdersToFill){
            platformEventList.add(new FilledExchangeOrders__e(Email__c = filledOrder.Owner.Email, Order_Id__c = filledOrder.id));
        }
        if(!platformEventList.isEmpty()){
            EventBus.publish(platformEventList);
        }
    }
            
}