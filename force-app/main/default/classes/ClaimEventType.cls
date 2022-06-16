/**
* Description : ClaimEventType is responsible to make event callouts based on different claim type
* Created Date : 07-04-2022
* Owner : PWC
* */
public class ClaimEventType {
    public static void createMemberPortfolio(Account acc, String taskId, String EventId, String UserId, String UserName  ){        
        String reqBody = '{"eventType": "claimEvent","claimEventType": "recordMemberPortfolio","claimContext": [{"contextType":"accountIdentifierRecord","accountId": "'+acc.Id+'", "accountName": "'+acc.Name+'", "sanlamMemberNumber": "'+acc.cve_Sanlam_Member_ID__c+'", "recordTypeId": "'+acc.RecordType.Id+'", "recordTypeName": "personRecord"}],"eventContext": {"eventId": "'+EventId+'", "taskId": "'+taskId+'", "userId": "'+UserId+'", "userName": "'+UserName+'"},"systemDate": "2022-03-01T01:00:00.1234567+02:00"}';
        callout(reqBody, EventId, taskId, 'Record Member Portfolio');
    }
    
    public static void createContext(Mainwrapper.ClaimMangement claimWrapper){
        // String reqBody = '{"claimEventType": "recordMemberPortfolio","claimContext": [{"accountId": "0030C00000Pn8uzQAB", "accountName": "Anna Kaufman", "sanlamMemberNumber": "AQ789531", "recordTypeId": "0030C00000Pn8asdAB", "recordTypeName": "PersonRecord","effectiveDate": "2022-03-01T01:00:00.1234567+02:00"}],"eventContext": {"eventId": "0030C00000AxyuzQAB", "taskId": "00T3M000005mpnRUAQ", "userId": "0054L000002auJLQAY", "userName": "Salesforce Admin"}, "policyContext": [{"policyId": "a1W3M000000IPFdUAO", "policyName": "040734173X4", "Benefits": [{"benefitId": "a0M0C000000gTunUAE", "benefitClaimedId": "a0H0C000003szIoUAI", "benefitClaimedNumber": "BC-2022-000012" }] }], "systemDate": "2022-03-01T01:00:00.1234567+02:00"}';
        callout(JSON.serialize(claimWrapper), claimWrapper.eventContext.eventId, claimWrapper.eventContext.taskId, claimWrapper.eventType);
    }
    
    /*public static void initialBenefitClaimedProvision(Mainwrapper.ClaimMangementCoverage manageWrapper){
        callout(JSON.serialize(manageWrapper), manageWrapper.eventContext.eventId, manageWrapper.eventContext.taskId, manageWrapper.claimEventType);
    }*/
    
    public static void bcClaimClosed(Mainwrapper.ClaimMangement claimWrapper){
        callout(JSON.serialize(claimWrapper), claimWrapper.eventContext.eventId, NULL, claimWrapper.eventType);
    }
     
    public static void callout(String reqBody, String eventId, String taskId, String eventName){
        List<Sobject> slist = new List<Sobject> ();
        Mainwrapper.claimEventResponse responseWrapper = new Mainwrapper.claimEventResponse();
        List<Party_Search__mdt> partySearch = [Select Id, Content_Type__c, Enpoint__c, Header__c, Method__c, Application__c,Bearer__c 
                                               From Party_Search__mdt Where MasterLabel = 'Claim Management New'];
		system.debug('MDT---'+ partySearch[0]);
        if(!partySearch.isEmpty()){
            HttpController.ResponseTokenWrapper responseTokenWrapper = Mainwrapper.getToken();
            String headerWithToken = 'Bearer '+responseTokenWrapper.access_token;
            HttpResponse response = HttpController.createCallout(reqBody, partySearch[0].Enpoint__c, partySearch[0].Method__c, partySearch[0].Content_Type__c, partySearch[0].Application__c,headerWithToken,'Authorization',true);
            System.debug('Response---->'+response);
            //Mainwrapper.ClaimMangement requestWrapper = (Mainwrapper.ClaimMangement)JSON.deserialize(reqBody, Mainwrapper.ClaimMangement.class);
            Claim_Event_Log__c claimEvent = new Claim_Event_Log__c();
            claimEvent.Request__c = reqBody;
            claimEvent.Response__c = response.getStatusCode() +'-'+response.getStatus();//response.getBody();
            claimEvent.Id = !String.isEmpty(eventId) ? eventId : null;
            claimEvent.EventType__c = eventName;
            
            if(response != NULL && (response.getStatusCode() == 200 || response.getStatusCode() == 202)){
                //responseWrapper = (Mainwrapper.claimEventResponse)JSON.deserialize(response.getBody(), Mainwrapper.claimEventResponse.class);
                claimEvent.Status__c = 'Accepted';
            } else{
                claimEvent.Status__c = 'Error';
                if(!String.IsEmpty(taskId)){
                    Task taskRecord = new Task();
                    taskRecord.Status = 'Complete';
                    taskRecord.Subject = eventName;
                    taskRecord.Id = taskId;
                    system.debug('task'+taskRecord.Id);
                    taskRecord.Integration_Status__c = 'Error';
                    slist.add(taskRecord);
                } 
            }
            slist.add(claimEvent);
            try{
                update slist;
            } catch(Exception ex){
                system.debug('---Exception--- '+ex.getMessage());
                //TODO Exception handling
            }
        }  
    }
}