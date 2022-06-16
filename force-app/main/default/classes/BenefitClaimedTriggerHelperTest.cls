/**
* Description : TestClass Of BenefitClaimedHelper
* Created Date : 07-04-2022
* Owner : PWC
* */

@isTest 
private  class BenefitClaimedTriggerHelperTest {
    testMethod static void testBcClaim(){
        cve__Claim__c claimRecord = TestDatafactory.createClaim();
        insert claimRecord;
        
        cve__Product__c productRecord = TestDatafactory.createProduct();
        insert productRecord;
        
        cve__Benefit__c benefitRecord = TestDatafactory.createBenefit(productRecord.Id);
        insert benefitRecord ;
        
        Group grouprec = TestDatafactory.GroupRecord();
        insert grouprec;
        
        Auth_Lid_Callout__c setting = new Auth_Lid_Callout__c();
        setting.Name = 'Auth_Lid_Callout__c';
        setting.Application__c = 'Whatever';
        setting.Client_Id__c = '&345678ccvhbjnkml';
        setting.Client_Secret__c = '&9876tgbnkgffghjmnbgh';
        setting.Content_Type__c = 'Content-Type';
        setting.Method__c = 'POST';
        setting.Endpoint__c = 'https://api-tst.sanlam.co.za/auth/oauth/v2/token';
        setting.Grant_Type__c = 'grant_type=password';  
        setting.Password__c = '&password4567u8i';
        setting.Refresh_Token__c = '6c11a20b-5d73-4a2f-b420-c1d3ac4c90e7';
        setting.Refresh_Token_Expiration__c = date.newInstance(2022, 02, 24);
        setting.Token_expiration__c = date.today();
        setting.User_Name__c = '&agvcbvghgh';
        insert setting;
        
        
        System.runAs(new User(Id=UserInfo.getUserId())){
            QueuesObject qRecord=TestDatafactory.QueuesRecord(grouprec.Id);
            insert qRecord;
        }
        System.runAs(new User(Id=UserInfo.getUserId())){
            GroupMember groupMember = TestDatafactory.GroupMemberRecord(grouprec.Id);
            insert groupMember;
            
            List<cve__Claim__c> claimList = [Select Id From cve__Claim__c Where cve__BenefitType__c='Test' ];
            List<cve__Benefit__c> benefitList = [Select Id, Benefit_Code__c From cve__Benefit__c Where Name='Test' Limit 1 ];
            List<group> groupList = [Select Id From Group where Type = 'Queue' AND Name = 'ISP'];
            cve__BenefitClaimed__c bcRecord = new cve__BenefitClaimed__c();
            bcRecord.cve__Claim__c = claimList[0].Id;
            bcRecord.cve__Benefit__c = benefitList[0].Id;
            bcRecord.cve__Status__c = 'Pending';
            cve__BenefitClaimed__c bcRecord1 = new cve__BenefitClaimed__c();
            bcRecord1.cve__Claim__c = claimList[0].Id;
            bcRecord1.cve__Benefit__c = benefitList[0].Id;
            bcRecord1.cve__Status__c = 'Pending';
            Test.setMock(HttpCalloutMock.class, new SearchLidControllermock());
            Test.startTest();
            insert bcRecord;
            insert bcRecord1; 
            Test.stopTest();
        }
    }
    private static testmethod void testClaimTriggerHelperUpdate()
    {
        cve__Product__c product = TestDatafactory.createProduct();
        insert product;
        cve__Claim__c claim = TestDatafactory.createClaim();
        cve__Benefit__c benefitId = TestDatafactory.createBenefit(product.Id);
        Test.setMock(HttpCalloutMock.class, new SearchLidControllermock());
        insert claim;
        cve__Policy__c Policy = TestDatafactory.policyCreationRecord(product.Id ,claim.Id);
        insert Policy;
        insert benefitId;
		cve__BenefitClaimed__c benefitClaimed = TestDatafactory.benefitClaimed(benefitId.Id,claim.Id,Policy.Id);
        insert benefitClaimed;
        Auth_Lid_Callout__c setting = new Auth_Lid_Callout__c();
        setting.Name = 'Auth_Lid_Callout__c';
        setting.Application__c = 'Whatever';
        setting.Client_Id__c = '&345678ccvhbjnkml';
        setting.Client_Secret__c = '&9876tgbnkgffghjmnbgh';
        setting.Content_Type__c = 'Content-Type';
        setting.Method__c = 'POST';
        setting.Endpoint__c = 'https://api-tst.sanlam.co.za/auth/oauth/v2/token';
        setting.Grant_Type__c = 'grant_type=password';  
        setting.Password__c = '&password4567u8i';
        setting.Refresh_Token__c = '6c11a20b-5d73-4a2f-b420-c1d3ac4c90e7';
        setting.Refresh_Token_Expiration__c = date.newInstance(2022, 02, 24);
        setting.Token_expiration__c = date.today();
        setting.User_Name__c = '&agvcbvghgh';
        insert setting;
        
        Test.startTest();
        benefitClaimed.cve__CoverageAmount__c = 56;
         benefitClaimed.cve__Status__c = 'Denied';
        Update benefitClaimed;
        Test.stopTest();
    }
    private static testmethod void testClaimTriggerHelperUpdateStatus()
    {
        cve__Product__c product = TestDatafactory.createProduct();
        insert product;
        cve__Claim__c claim = TestDatafactory.createClaim();
        cve__Benefit__c benefitId = TestDatafactory.createBenefit(product.Id);
        Test.setMock(HttpCalloutMock.class, new SearchLidControllermock());
        insert claim;
        cve__Policy__c Policy = TestDatafactory.policyCreationRecord(product.Id ,claim.Id);
        insert Policy;
        insert benefitId;
		cve__BenefitClaimed__c benefitClaimed = TestDatafactory.benefitClaimed(benefitId.Id,claim.Id,Policy.Id);
        insert benefitClaimed;
        Auth_Lid_Callout__c setting = new Auth_Lid_Callout__c();
        setting.Name = 'Auth_Lid_Callout__c';
        setting.Application__c = 'Whatever';
        setting.Client_Id__c = '&345678ccvhbjnkml';
        setting.Client_Secret__c = '&9876tgbnkgffghjmnbgh';
        setting.Content_Type__c = 'Content-Type';
        setting.Method__c = 'POST';
        setting.Endpoint__c = 'https://api-tst.sanlam.co.za/auth/oauth/v2/token';
        setting.Grant_Type__c = 'grant_type=password';  
        setting.Password__c = '&password4567u8i';
        setting.Refresh_Token__c = '6c11a20b-5d73-4a2f-b420-c1d3ac4c90e7';
        setting.Refresh_Token_Expiration__c = date.newInstance(2022, 02, 24);
        setting.Token_expiration__c = date.today();
        setting.User_Name__c = '&agvcbvghgh';
        insert setting;
        
        Test.startTest();
        benefitClaimed.cve__CoverageAmount__c = 56;
        benefitClaimed.cve__Status__c = 'Open';
        Update benefitClaimed;
        Test.stopTest();
    }
}