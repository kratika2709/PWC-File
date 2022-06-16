@isTest
public class ClaimTriggerHelperTest {
    
    private static testmethod void testClaimTriggerHelperUpdate()
    {
        cve__Product__c product = TestDatafactory.createProduct();
        insert product;
        
        cve__Claim__c claim = TestDatafactory.createClaim();
        cve__Benefit__c benefitId = TestDatafactory.createBenefit(product.Id);
        insert claim;
        insert benefitId;
        cve__Policy__c Policy = TestDatafactory.policyCreationRecord(product.Id ,claim.Id);
        insert Policy;
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
        Test.setMock(HttpCalloutMock.class, new SearchLidControllermock());
        Test.startTest();
        claim.cve__Status__c = 'pending';
        Update claim;
        claim.cve__Status__c = 'Open';
        Update claim;
        Test.stopTest();
    } 
    /*private static testmethod void testFinaliseClaim()
    {
        cve__Product__c product = TestDatafactory.createProduct();
        insert product;
        
        cve__Claim__c claim = TestDatafactory.createClaim();
        cve__Benefit__c benefitId = TestDatafactory.createBenefit(product.Id);
        insert claim;
        insert benefitId;
        cve__Policy__c Policy = TestDatafactory.policyCreationRecord(product.Id ,claim.Id);
        insert Policy;
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
        Test.setMock(HttpCalloutMock.class, new SearchLidControllermock());
        Test.startTest();
        system.debug('claim : '+claim);
        claim.cve__Status__c = 'Closed';
        Update claim;
        system.debug('claim : '+claim);
        Test.stopTest();
    } */
}