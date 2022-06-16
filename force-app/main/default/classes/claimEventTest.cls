@IsTest
public with sharing class claimEventTest {
    @testSetup static void CreateMemberPortfolioTest()
    {
        Id personAccountRecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();        
        Account acc = new Account();
        acc.RecordTypeId=personAccountRecordTypeId;
        acc.FirstName = 'Test';
        acc.LastName = '1901';
        acc.cve_Sanlam_Member_ID__c = 'AV7EC315';
        Insert acc;
        
        Account accNew = new Account();
        accNew.RecordTypeId=personAccountRecordTypeId;
        accNew.FirstName = 'Test';
        accNew.LastName = '1902';
        accNew.cve_Sanlam_Member_ID__c = '';
        Insert accNew;
        
    }
    testMethod static void testmethod1()
    {
        account acc1  = [SELECT Id, firstname,lastname,cve_Sanlam_Member_ID__c FROM Account WHERE lastname = '1901'  LIMIT 1];
        string jsonData = '{"lastname":"'+acc1.LastName+'","dob":"2022-02-02","idnumber":"123","countryofissue":"A","firstname":"joe1901","membernumber":"'+acc1.cve_Sanlam_Member_ID__c+'","intermediarynumber":"001"}';
        
        try {
            test.startTest();
            claimEvent.requestClaimEvent(jsonData,true , 'Record Member Portfolio',true);
            Test.setMock(HttpCalloutMock.class, new ClaimEventMockClass());
            test.stopTest();  
        } catch (AuraHandledException e) {
            System.debug(e.getMessage());
            System.debug(e.getTypeName());
            
        }
    }
    
    testMethod static void testmethod2()
    {
        account acc2  = [SELECT Id, firstname,lastname,cve_Sanlam_Member_ID__c FROM Account WHERE lastname = '1902'  LIMIT 1];
        string jsonData = '{"lastname":"'+acc2.LastName+'","dob":"2022-02-02","idnumber":"123","countryofissue":"A","firstname":"joe1901","membernumber":"'+acc2.cve_Sanlam_Member_ID__c+'","intermediarynumber":"001"}';
        
        try {
            test.startTest();
            claimEvent.requestClaimEvent(jsonData,true , 'Record Member Portfolio',true);
            Test.setMock(HttpCalloutMock.class, new ClaimEventMockClass());
            test.stopTest();  
        } catch (AuraHandledException e) {
            System.debug(e.getMessage());
            System.debug(e.getTypeName());
            
        }
    }
}