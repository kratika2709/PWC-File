@IsTest
public with sharing class RetrieveRiskAssessmentTest {
    @testSetup static void getPersonMemberTest(){
        Id personAccountRecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId(); 
        Account acc = new Account();
        acc.Name = 'Test';
        acc.cve_Sanlam_Member_ID__c = 'AV7EC315';
        Insert acc;
        
        Account accnew = new Account();
        accnew.RecordTypeId=personAccountRecordTypeId;
        accnew.FirstName = 'Test1';
        accnew.LastName = '1901';
        accnew.cve_Sanlam_Member_ID__c = 'ASW23BU';
        Insert accnew;
    }
    testMethod static void callClaimEventTest(){
        account accountRec  = [SELECT Id, name, cve_Sanlam_Member_ID__c FROM Account WHERE name = 'Test'  LIMIT 1];
        account personAccountRec  = [SELECT Id, firstname,lastname,cve_Sanlam_Member_ID__c FROM Account WHERE lastname = '1901'  LIMIT 1];
        string jsonData = '{"lastname":"'+personAccountRec.LastName+'","dob":"2022-02-02","idnumber":"123","countryofissue":"A","firstname":"joe1901","membernumber":"'+personAccountRec.cve_Sanlam_Member_ID__c+'","intermediarynumber":"001"}';
        test.startTest();
        RetrieveRiskAssessment.getPersonMember(accountRec.id);
        RetrieveRiskAssessment.callClaimEvent(jsonData,true , 'Record Member Portfolio',true);
        Test.setMock(HttpCalloutMock.class, new ClaimEventMockClass());
        test.stopTest(); 
        
    }
    testMethod static void callClaimEventTestForNull(){
        account accountRec  = [SELECT Id, name, cve_Sanlam_Member_ID__c FROM Account WHERE name = 'Test'  LIMIT 1];
        account personAccountRec  = [SELECT Id, firstname,lastname,cve_Sanlam_Member_ID__c FROM Account WHERE lastname = '1901'  LIMIT 1];
        string jsonData = null;
        test.startTest();
        try{
            RetrieveRiskAssessment.getPersonMember(accountRec.Id);
            RetrieveRiskAssessment.callClaimEvent(jsonData,true , 'Record Member Portfolio',true);
            Test.setMock(HttpCalloutMock.class, new ClaimEventMockClass());
        }catch (AuraHandledException e) {
            System.debug(e.getMessage());
            System.debug(e.getTypeName());
            
        }
        
        test.stopTest(); 
    }
}