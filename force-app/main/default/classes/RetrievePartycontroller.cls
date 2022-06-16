public class RetrievePartycontroller {
    @AuraEnabled
    public static String tableController(String clientNumber, String radioval){
        System.debug('clientNumber'+clientNumber);
        System.debug('radioval---'+radioval);
        String requestBody;  
        String claimUserID = UserInfo.getUserId();
        System.debug('claimUserID'+ claimUserID);
        String corelationID = claimUserID+ '-' +Date.today();
        System.debug('CorelationID'+ CorelationID);
        
        String recordTypeId;
        String partyType;
        String context;
        if(radioval == 'Person'){
            recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            partyType = 'PersonAccount';
            Context = 'Client Details';
            System.debug('recordTypeId'+ recordTypeId);
            //requestBody = recordTypeId;
        } else if(radioval == 'LegalEntity'){
            partyType = 'Business_Record_Type';
            Context ='Client Details';
            recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Record_Type').getRecordTypeId();
            System.debug('recordTypeId'+ recordTypeId);
            //requestBody=recordTypeId;
        } else if(radioval == 'Policy'){
            partyType = 'Business_Record_Type';
            Context ='Policy and Benefit Detail';
            System.debug('recordTypeId'+ recordTypeId);
        }
        
        Map<String,String> reqMap = new Map<String,String>{'correlationId' => corelationID,
            'claimUserID' => claimUserID,
            'businessContext' => Context,
            'clientNumber'=> clientNumber,
            'partyTypeID'=> recordTypeId,
            'partyType' =>  partyType};
             
        
        String requestBodyStr =  JSON.serialize(reqMap);
        System.debug(requestBodyStr);
        
        
        List<Party_Search__mdt> clientSearch = [Select Id, Enpoint__c, Header__c, Method__c, Bearer__c From Party_Search__mdt Where MasterLabel = 'Person retrieve' WITH SECURITY_ENFORCED];
        HttpController.ResponseTokenWrapper responseWrapper = Mainwrapper.getToken();
        String headerWithToken = clientSearch[0].Bearer__c+' '+responseWrapper.access_token;
        HttpResponse clientResponse = HttpController.createCallout(requestBodyStr, clientSearch[0].Enpoint__c, clientSearch[0].Method__c, '', '', headerWithToken, clientSearch[0].Header__c,true);
        system.debug('clientResponse----->'+clientResponse);
        String returnRes = 'client user : '+ reqMap.get('claimUserID') + ' Business context : ' + reqMap.get('businessContext')+ ' client Number : '+ reqMap.get('clientNumber') +' party TypeID : '+ reqMap.get('partyTypeID') +' party Type : '+reqMap.get('partyType')+ '-' + ' Response : '+ clientResponse;
        return returnRes;
    }
     
}