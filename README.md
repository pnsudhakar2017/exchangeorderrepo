# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)


oAuth API: https://{domain}/services/oauth2/token
Documentation: https://developer.salesforce.com/docs/atlas.en-us.chatterapi.meta/chatterapi/intro_using_oauth.htm

Apex Rest API: https://{domainName}/services/apexrest/order

    GET:
        it fetches the order with given id and returns the same.

        curl -H "Authorization: Bearer <ACCESS_TOKEN>" https://{domainName}/services/apexrest/order
        sample payload: NONE
        sample reponse:
            Success:
                "fetched order for the given id: (Exchange_Order__c:{Id=********, Name=ORDER-00018, Security__c=********, Order_Side__c=Sell, Order_Type__c=Market, Quantity__c=110, Order_Total__c=11000.00})"
            Error:
                Failed Reason
    
    POST:
        it creates order with the given details.

        curl -H "Authorization: Bearer <ACCESS_TOKEN>" https://{domainName}/services/apexrest/order
    sample payload:
        {
            "orderToCreate" : {
            "Order_Side__c" : "Buy",
            "Order_Type__c" : "Market",
            "Price__c" : 100,
            "Quantity__c" : 110,
            "Security__c" : "***********"
            }
        }
    sample reponse:
        Success:
            "Order with id: ********, been created successfully as : Exchange_Order__c:{Price__c=100.0, Order_Type__c=Market, Id=********, Security__c=********, Order_Side__c=Buy, Quantity__c=110.0}"
        Error:
            Failed Reason

    PUT:
        it updates order with the given details.

        curl -H "Authorization: Bearer <ACCESS_TOKEN>" https://{domainName}/services/apexrest/order
        
        sample payload:
        {
            "orderToUpdate" : {
            "Order_Side__c" : "Sell",
            "Order_Type__c" : "Market",
            "Price__c" : 100,
            "Quantity__c" : 110,
            "Security__c" : "a002w00000XRd0GAAT",
            "Id" : "a012w000014dxqnAAA"
            }
        }
        
        sample reponse:
        Success:
            "Order with id: ******** been updated successfully as: Exchange_Order__c:{Price__c=100.0, Order_Type__c=Market, Id=********, Security__c=********, Order_Side__c=Sell, Quantity__c=110.0}"
        Error:
            Failed Reason
