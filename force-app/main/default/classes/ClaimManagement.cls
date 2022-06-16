public class ClaimManagement {
    
    public static void claimManagementDetails(List<Account> acc, String taskId, String  EventId, String UserId, String UserName  ){
        
        /* Account , taskId, EventId , UserId, UserName 
Mainwrapper.ClaimMangement  clientObj = new  Mainwrapper.ClaimMangement();
clientObj.claimeventtype = 'recordMemberPortfolio';

Mainwrapper.claimContext claimObj = new Mainwrapper.claimContext();
claimObj.accountId = '0030C00000Pn8uzQAB';
claimObj.accountName = 'Anna Kaufman';
claimObj.effectiveDate ='2022-03-01T01:00:00.1234567+02:00';
claimObj.recordTypeId = '0030C00000Pn8asdQAB';
claimObj.recordTypeName = 'PersonRecord';
claimObj.sanlamMemberNumber = 'AQ789531'; 

Mainwrapper.eventContext eventObj = new  Mainwrapper.eventContext();
eventObj.eventId = '0030C00000AxyuzQAB';
eventObj.taskId =  '0030C00000AdefzQAB';
eventObj.userId =  '0030C00000Pn7uzPAL';
eventObj.userName = 'sanlam03082021';   */
        
        // String reqBody = '{"claim-event-type": "recordMemberPortfolio","claim-context": [{"accountId": "0030C00000Pn8uzQAB","accountName": "Anna Kaufman","sanlamMemberNumber": "AQ789531","recordTypeId": "0030C00000Pn8asdAB","recordTypeName": "PersonRecord","effectiveDate": "2022-03-01T01:00:00.1234567+02:00"}],"event-context": {"eventId": "0030C00000AxyuzQAB","taskId": "0030C00000AdefzQAB","userId": "0030C00000Pn7uzPAL","userName": "sanlam03082021"},"systemDate": "2022-03-01T01:00:00.1234567+02:00"}';
        
        String reqBody = '{"ClaimEventType": "recordMemberPortfolio","claimContext": [{"accountId": "'+acc[0].Id+'", "accountName": "'+acc[0].Name+'", "sanlamMemberNumber": "'+acc[0].Member_Number__pc+'", "recordTypeId": "'+acc[0].RecordType.Id+'", "recordTypeName": "'+acc[0].RecordType.Name+'","effectiveDate": "'+Date.today()+'"}],"eventContext": {"eventId": "'+EventId+'", "taskId": "'+taskId+'", "userId": "'+UserId+'", "userName": "'+UserName+'"},"systemDate": "2022-03-01T01:00:00.1234567+02:00"}';
        List<Party_Search__mdt> partySearch = [Select Id, Content_Type__c, Enpoint__c, Header__c, Method__c, Application__c,Bearer__c 
                                               From Party_Search__mdt Where MasterLabel = 'Claim Management'];
        system.debug(partySearch);
        String response = HttpController.createCallout(reqBody, partySearch[0].Enpoint__c, partySearch[0].Method__c, partySearch[0].Content_Type__c, partySearch[0].Application__c,'Claim Management','',false);
        System.debug('Response---->'+response);
    }
}