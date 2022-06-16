/**
* Description : Test Class for ClaimEventType.
* Created Date : 07-04-2022
* Owner : PWC
* */

@isTest
private class ClaimEventTypeTest {
    
    @testsetup static void insertRecord(){
        Account accRecord = new Account();
        accRecord = TestDatafactory.Accountrecord();
        insert accRecord;
        
        Claim_Event_Log__c firstClaim = new Claim_Event_Log__c();
        firstClaim = TestDatafactory.createClaimFirstEvent();
        insert firstClaim;
        
        Claim_Event_Log__c secondClaim = new Claim_Event_Log__c();
        secondClaim = TestDatafactory.createClaimSecondEvent();
        insert secondClaim;
        
        Claim_Event_Log__c thirdClaim = new Claim_Event_Log__c();
        thirdClaim = TestDatafactory.createClaimThirdEvent();
        insert thirdClaim;
        
        Task taskRecord = new Task();
        taskRecord = TestDatafactory.taskRecord();
        insert taskRecord;
        
        Auth_Lid_Callout__c setting = new Auth_Lid_Callout__c();
        setting.Name = 'Auth_Lid_Callout__c';
        setting.Application__c = 'Whatever';
        setting.Client_Id__c = '&345678ccvhbjnkml';
        setting.Client_Secret__c = '&9876tgbnkgffghjmnbgh';
        setting.Content_Type__c = 'Content-Type';
        setting.Method__c = 'POST';
        setting.Endpoint__c = 'https://api-tst.sanlam.co.za/spf/claimmanagement/event/v1/claim';
        setting.Grant_Type__c = 'grant_type=password';  
        setting.Password__c = '&password4567u8i';
        setting.Refresh_Token__c = '6c11a20b-5d73-4a2f-b420-c1d3ac4c90e7';
        setting.Refresh_Token_Expiration__c = date.newInstance(2022, 02, 24);
        setting.Token_expiration__c = date.today();
        setting.User_Name__c = '&agvcbvghgh';
        insert setting;
        
    }   
    
    public class MockHttpClaimEventError implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            if (req.getEndpoint().contains('https://virtserver.swaggerhub.com/Private596/ClaimAdministrationAPI/1.0.1/event/v1.0/single')) {
                res.setBody('{"eventId" : 123, "eventStatus" : "accepted"}');
            }
            res.setStatusCode(500);
            return res;
        }
    }
    
    private static testMethod void claimManagementDetails(){  
        List<Task> taskList = [SELECT Id, Priority FROM Task WHERE Priority ='High' LIMIT 1];
        List<Account> accList = [SELECT Id, Name, cve_Sanlam_Member_ID__c, RecordType.Id, RecordType.Name FROM Account WHERE Name ='Jordan' LIMIT 1];
        List<Claim_Event_Log__c> claimList = [SELECT Id, Status__c FROM Claim_Event_Log__c WHERE Status__c = 'Accepted' LIMIT 1];
        String UserId =  UserInfo.getUserId();
        String UserName = UserInfo.getUserName();
        Test.setMock(HttpCalloutMock.class, new SearchLidControllermock());
        Test.StartTest();
        ClaimEventType.createMemberPortfolio(accList[0], taskList[0].Id, claimList[0].Id, UserId, UserName);
        Test.StopTest();
    }
    
    private static testMethod void createContext(){
        Mainwrapper.ClaimMangement claim = mockRecord();
        Test.setMock(HttpCalloutMock.class, new SearchLidControllermock());
        Test.startTest();
        ClaimEventType.createContext(claim);
        Test.stopTest();
        
    }
    
    private static testMethod void bcClaimClosed(){         
        Mainwrapper.ClaimMangement claim = mockRecord();
        Test.setMock(HttpCalloutMock.class, new MockHttpClaimEventError());
        Test.startTest();
        ClaimEventType.bcClaimClosed(claim);
        Test.stopTest();
    }
    
    private static  Mainwrapper.ClaimMangement mockRecord(){
        List<Account> accList = [SELECT Id, Name, cve_Sanlam_Member_ID__c, RecordType.Id, RecordType.Name FROM Account WHERE Name ='Jordan' LIMIT 1];
        
        List<Claim_Event_Log__c> claimevent = [SELECT Id, Status__c FROM Claim_Event_Log__c WHERE Status__c = 'Accepted' LIMIT 1];
        List<Task> taskRecord =[Select Id, Priority FROM Task WHERE Priority ='High' LIMIT 1];
        Mainwrapper.EventContext event = new Mainwrapper.EventContext();
        event.eventId =  claimevent[0].Id;                    
        event.taskId  =  taskRecord[0].Id;
        event.userId = UserInfo.getUserId();                                                 
        event.userName = UserInfo.getUserName();
        
        Mainwrapper.ClaimEventResponse claimResponse = new Mainwrapper.ClaimEventResponse();
        claimResponse.eventId = '0030C00000AxyuzQAB';
        claimResponse.eventStatus = '0030C00000AdefzQAB';  
        
        //Reinsurance
        List<Mainwrapper.Reinsurance> reeinsuranceList = new List<Mainwrapper.Reinsurance>(); 
        Mainwrapper.Reinsurance reinsurance = new Mainwrapper.Reinsurance();
        reinsurance.reinsuranceId = 'a1m0C000000x8mFQAQ';
        reinsurance.reinsuranceName = 'R-2022-00029';
        reeinsuranceList.add(reinsurance);
        
        //CommunicationBenefit
        List<Mainwrapper.CommunicationBenefit> cBenefit = new List<Mainwrapper.CommunicationBenefit>();
        Mainwrapper.CommunicationBenefit communication = new Mainwrapper.CommunicationBenefit(); 
        communication.claimDocumentId = '1Q0C000000w55JUAQ';
        communication.claimDocumentName = 'CD-2022-000049';
        cBenefit.add(communication);
        
     
        //Taxdirective 
        List<Mainwrapper.Taxdirective> taxList = new List<Mainwrapper.Taxdirective>();
        Mainwrapper.Taxdirective taxdirective = new Mainwrapper.Taxdirective();
        taxdirective.taxDirectiveId = 'a2j0C000000AC7WQAW';
        taxdirective.taxDirectiveName = 'TD-0001';
        taxList.add(taxdirective);
		
        //BenefitClaimed
        List<Mainwrapper.BenefitClaimed> bClaimedList =  new List<Mainwrapper.BenefitClaimed> ();
        Mainwrapper.BenefitClaimed bClaimed  = new Mainwrapper.BenefitClaimed();
        bClaimed.policyId ='a1W3M000000IPFdUAO';
        bClaimed.policyName = '040734173X4';
        bClaimed.benefitid = 'a0M0C000000gTunUAE';
        bClaimed.benefitClaimedid = 'a0H0C000003szIoUAI';
        bClaimed.benefitClaimedName = 'BC-2022-000012';
        bClaimed.reinsurance = reeinsuranceList;
        bClaimed.communicationBenefit = cBenefit;
        bClaimed.paymentSpecification = new List<Mainwrapper.Paymentspecification>();
        bClaimed.taxDirective = taxList;
        bClaimedList.add(bClaimed);
        
        
        Mainwrapper.ClaimContext context = new Mainwrapper.ClaimContext();
        context.accountId = accList[0].id;
        context.accountName = accList[0].Name;
        context.sanlamMemberNumber = accList[0].cve_Sanlam_Member_ID__c;
        context.recordTypeId = accList[0].RecordType.Id;
        context.recordTypeName = 'Test09';
        context.benefitClaimed = bClaimedList;
        
        //ClaimMangement
        Mainwrapper.ClaimMangement claim = new Mainwrapper.ClaimMangement();
        claim.eventType = 'claimEvent';
        //claim.claimEventType ='Risk Assessment';
        //claim.claimSubEventType = NULL;
        claim.eventContext = event;
        claim.claimContext = context;
        //claim.benefitClaimed = bClaimedList;
        claim.systemDate = String.valueOf(Date.today());
        return claim;
    }
}