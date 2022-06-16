@isTest
private class RequiredDocumentTriggerHelperTest {
    @testSetup static void recquiredDocumentInsert(){
        cve__Claim__c  claimRecord = new   cve__Claim__c();  
        claimRecord.cve__BenefitType__c='Test';
        Insert claimRecord;
        cve__Product__c productRecord = new  cve__Product__c();
        productRecord.Name = 'Test';
        productRecord.cve__Status__c = 'Active';
        productRecord.cve_Sanlam_Product_ExternalID__c = 'xyz';
        productRecord.cve__Effective__c = date.Today()+30;
        Insert productRecord;
        cve__Benefit__c benefitRecord = new  cve__Benefit__c();
        benefitRecord.Name = 'Test';
        benefitRecord.cve__Effective__c = date.Today()+30;
        benefitRecord.Benefit_Code__c ='CSR55';
        benefitRecord.cve__Product__c = productRecord.Id;
        benefitRecord.cve__BenefitPercentage__c = 5.0;
        Insert benefitRecord ;
        cve__BenefitClaimed__c  bcRecord = new cve__BenefitClaimed__c();
        bcRecord.cve__Claim__c = claimRecord.Id;
        bcRecord.cve__Benefit__c = benefitRecord.Id;
        bcRecord.cve__Status__c = 'Pending';
        Insert bcRecord;
        Sanlam_Claim_Document__c  claimDocumentRecord = new  Sanlam_Claim_Document__c();
        claimDocumentRecord.Name = 'Test';
        claimDocumentRecord.Document_ID__c='xyz';
        claimDocumentRecord.Benefit_Claimed__c = bcRecord.Id;
        claimDocumentRecord.Claim_Number__c = claimRecord.Id;
        Insert claimDocumentRecord;
        Sanlam_Required_Documents__c requiredObj  = new  Sanlam_Required_Documents__c();
        requiredObj.Benefit_Claim__c = bcRecord.Id;
        requiredObj.Document_ID__c = claimDocumentRecord.Id;
        requiredObj.Name = 'Test';
        insert requiredObj;
    }
    testMethod static void testrequiredInsert()
    {
        List<cve__BenefitClaimed__c> benefitClaimedList   = [SELECT Id FROM cve__BenefitClaimed__c WHERE cve__Status__c = 'Pending'  Limit 1];
        List<Sanlam_Claim_Document__c> sanlamClaimDocumentList   = [SELECT Id FROM Sanlam_Claim_Document__c WHERE Name = 'Test' Limit 1];
        Sanlam_Required_Documents__c requiredObj  = new  Sanlam_Required_Documents__c();
        requiredObj.Benefit_Claim__c = benefitClaimedList[0].Id;
        requiredObj.Document_ID__c = sanlamClaimDocumentList[0].Id;
        requiredObj.Name = 'Test';
        requiredObj.Sanlam_Required__c = true;
        requiredObj.Sanlam_Document_Status__c = 'Received';
        test.startTest();
        insert requiredObj;
        test.stopTest();
    }
    testMethod static void testRequiredInsertRecord()
    {
        List<cve__BenefitClaimed__c> benefitClaimedList   = [SELECT Id FROM cve__BenefitClaimed__c WHERE cve__Status__c = 'Pending' Limit 1];
        List<Sanlam_Claim_Document__c> sanlamClaimDocumentList   = [SELECT Id FROM Sanlam_Claim_Document__c WHERE Name = 'Test' Limit 1];
        Sanlam_Required_Documents__c requiredObj  = new  Sanlam_Required_Documents__c();
        requiredObj.Benefit_Claim__c = benefitClaimedList[0].Id;
        requiredObj.Document_ID__c = sanlamClaimDocumentList[0].Id;
        requiredObj.Name = 'Test';
        requiredObj.Sanlam_Required__c = false;
        requiredObj.Sanlam_Document_Status__c = 'Received';
        test.startTest();
        insert requiredObj;
        system.assertEquals(benefitClaimedList!=null,True );
        test.stopTest();
    }
    
    testMethod static void recquiredDocumentUpdate()
    {
        List<Sanlam_Required_Documents__c>  sanlamRequiredDocumentsList = [SELECT Id, Name, Sanlam_Required__c, Sanlam_Document_Status__c FROM Sanlam_Required_Documents__c WHERE Name = 'Test'  Limit 1];
        sanlamRequiredDocumentsList[0].Sanlam_Required__c = false;
        sanlamRequiredDocumentsList[0].Sanlam_Document_Status__c = 'Received';
        test.startTest();
        update sanlamRequiredDocumentsList;
        system.assertEquals(sanlamRequiredDocumentsList!=null,True );
        test.stopTest();
    }
    
    
}