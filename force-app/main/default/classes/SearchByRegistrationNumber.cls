public class SearchByRegistrationNumber {
    @AuraEnabled
    public static String serchPartyByRegistrationNumber(string jsonString, string radioVal){
        Mainwrapper.ResponseWrapper obj  = new  Mainwrapper.ResponseWrapper();
        Mainwrapper.LegalEntityWrapper Entityobj = new Mainwrapper.LegalEntityWrapper();
        String responseString;
        String body;
        system.debug('LID object json--->'+jsonString);
        Mainwrapper.LidWrapper lidObj = (Mainwrapper.LidWrapper) JSON.deserialize(jsonString, Mainwrapper.LidWrapper.class);
        system.debug('LID object---'+lidObj);
        if(radioVal == 'Person'){
            body = '{"searchType":"Person",';
        } else if(radioVal == 'LegalEntity'){
            body = '{"searchType":"Organisation",';
        }
        
        String bodyFields = '';
        bodyFields += !String.isEmpty(lidObj.name) ? '"name":"'+lidObj.name+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.surname) ? '"surname":"'+lidObj.surname+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.birth_date) ? '"birthDate":"'+lidObj.birth_date+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.phone_details) ? '"phoneDetails":"'+lidObj.phone_details+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.email_address) ? '"emailAddress":"'+lidObj.email_address+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.registration_type) && !String.isEmpty(lidObj.registration_number) ? '"registrationType":"'+lidObj.registration_type+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.client_number) ? '"clientNumber":"'+lidObj.client_number+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.plan_number) ? '"planNumber":"'+lidObj.plan_number+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.registration_type) && !String.isEmpty(lidObj.registration_number) ? '"registrationNumber":"'+lidObj.registration_number+'"'+',': '';
        bodyFields += !String.isEmpty(lidObj.member_number) ?'"organisationNumber":"'+lidObj.member_number+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.organisation_name) ?'"organisationName":"'+lidObj.organisation_name+'"'+',' : '';
        
        if(bodyFields.endsWith(',')){
            bodyFields = bodyFields.removeEnd(',');
        }
        bodyFields += '}';
        String reqBody = body+bodyFields;
        system.debug(reqBody);
        HttpController.ResponseTokenWrapper responseWrapper = Mainwrapper.getToken();
        List<Party_Search__mdt> partySearch = [Select Id, Content_Type__c, Enpoint__c, Header__c, Method__c, Application__c,Bearer__c 
                                               From Party_Search__mdt Where MasterLabel = 'Person Search'];
        system.debug(partySearch);
        String headerWithToken = partySearch[0].Bearer__c+' '+responseWrapper.access_token;
        HttpResponse response = HttpController.createCallout(reqBody, partySearch[0].Enpoint__c, partySearch[0].Method__c, partySearch[0].Content_Type__c, partySearch[0].Application__c, headerWithToken, partySearch[0].Header__c,true);
        if(response.getStatusCode() == 200 || response.getStatusCode() == 202){
            if(radioVal == 'Person'){
                obj = (Mainwrapper.ResponseWrapper) JSON.deserialize(response.getBody(), Mainwrapper.ResponseWrapper.class);  
                responseString = JSON.serialize(obj);
            } else if(radioVal == 'LegalEntity'){
                Entityobj = (Mainwrapper.LegalEntityWrapper) JSON.deserialize(response.getBody(), Mainwrapper.LegalEntityWrapper.class); 
                system.debug('Response---->'+Entityobj);
                responseString = JSON.serialize(Entityobj);
            }
        }
        System.debug(responseString);
        Mainwrapper.updateCustomSetting(responseWrapper);
        return responseString;//JSON.serialize(obj);
    }
    
}