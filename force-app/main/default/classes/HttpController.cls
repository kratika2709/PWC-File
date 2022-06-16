/**
* @author Manish Kaushik
* @date 10/07/2021
* @Description HttpController For Rest Api callouts.
*/
public with sharing class HttpController {
    
    public static HttpResponse createCallout(String requestBody, String restAPIURL, String method, String contentType, String application, String header, String auth, boolean hasToken){
        System.debug(requestBody+'----'+restAPIURL+'----'+method+'-----'+header+'---'+auth+'----'+hasToken+'----'+contentType+'----'+application);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(restAPIURL);  
        req.setMethod(method);
        if(hasToken){
            system.debug(auth+','+header);
            req.setHeader(auth, header);
            req.setHeader('Content-Type','application/json;charset=UTF-8');
        } else if(!String.isEmpty(header) && header == 'Claim Management'){
            req.setHeader(contentType,application);
        } else {
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
        }
        if(!String.isEmpty(requestBody)){
            req.setBody(requestBody);
        }
        req.setTimeout(120000);
        
        HttpResponse response = http.send(req);
        system.debug('responseStatus--->'+response.getStatus());
        system.debug('responseBody--->'+response.getBody());
        return response;
    }
    
    /**
* @author Manish Kaushik 
* @date 09/24/2021
* @description Method use to authorize and receive token from sanlam.
* @return token 
*/
    public static ResponseTokenWrapper authorizationCallForPartySearch(){
        ResponseTokenWrapper responseWraper = new ResponseTokenWrapper();
        Auth_Lid_Callout__c authLidCallout = Auth_Lid_Callout__c.getOrgDefaults();
        String client_id = authLidCallout.Client_Id__c;
        String client_secret = authLidCallout.Client_Secret__c+authLidCallout.User_Name__c	+authLidCallout.Password__c;
        String grant_type = authLidCallout.Grant_Type__c;
        String restAPIURL = authLidCallout.Endpoint__c;
        String method = authLidCallout.Method__c;
        String contentType = authLidCallout.Content_Type__c;
        String application = authLidCallout.Application__c; 
        String requestBody = grant_type+client_id+client_secret;
        HttpResponse response = createCallout(requestBody, restAPIURL, method, contentType, application, '','', false);
        if(response.getStatusCode() == 200 || response.getStatusCode() == 202){
            responseWraper = (ResponseTokenWrapper)JSON.deserialize(response.getBody(), ResponseTokenWrapper.class);
        }
        system.debug(responseWraper);
        return responseWraper;
    }
    
    public class ResponseTokenWrapper{	
        public String access_token;
        public String token_type;
        public String expires_in;
        public String refresh_token;
    }
}