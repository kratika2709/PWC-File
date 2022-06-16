public with sharing class RequiredDocumentTriggerHelper {
    public static void updateBenifitClaim(List<Sanlam_Required_Documents__c> sanlamRequiredDocumentList, Map<Id, Sanlam_Required_Documents__c> sanlamRequiredDocumentOldMap){
        List<String> benefitClaimedIdLst = new List<String>();
        for(Sanlam_Required_Documents__c sanlamRequiredDocumentObj : sanlamRequiredDocumentList)
        {
            if(sanlamRequiredDocumentObj.Benefit_Claim__c != null && 
               (sanlamRequiredDocumentOldMap != null && (sanlamRequiredDocumentOldMap.get(sanlamRequiredDocumentObj.Id).Sanlam_Required__c != sanlamRequiredDocumentObj.Sanlam_Required__c 
                                                         || sanlamRequiredDocumentOldMap.get(sanlamRequiredDocumentObj.Id).Sanlam_Document_Status__c != sanlamRequiredDocumentObj.Sanlam_Document_Status__c))
               || (sanlamRequiredDocumentObj.Sanlam_Required__c == true && sanlamRequiredDocumentObj.Sanlam_Document_Status__c == 'Received'))
            {
                benefitClaimedIdLst.add(sanlamRequiredDocumentObj.Benefit_Claim__c);
            }
        }
        List<cve__BenefitClaimed__c> listBenefitSanlamRequiredDocument = [SELECT Id, Required_Documents_Received__c ,(SELECT Id, Benefit_Claim__c, Sanlam_Required__c, Sanlam_Document_Status__c FROM Sanlam_Required_Documents__r) FROM cve__BenefitClaimed__c WHERE Id IN : benefitClaimedIdLst];
        if(!listBenefitSanlamRequiredDocument.isEmpty())
        {
            List<cve__BenefitClaimed__c> benefitClaimedList = new List<cve__BenefitClaimed__c>();
            for(cve__BenefitClaimed__c benefitClaimedObj : listBenefitSanlamRequiredDocument)
            {
                Boolean allReceved = false;
                for(Sanlam_Required_Documents__c sanlamRequiredDocumentObj : benefitClaimedObj.Sanlam_Required_Documents__r)
                {
                    if((sanlamRequiredDocumentObj.Sanlam_Required__c && sanlamRequiredDocumentObj.Sanlam_Document_Status__c != 'Received') || 
                       (sanlamRequiredDocumentObj.Sanlam_Required__c == false && sanlamRequiredDocumentObj.Sanlam_Document_Status__c == 'Received')){
                           allReceved = true;
                       } 
                }
                benefitClaimedObj.Required_Documents_Received__c = allReceved == true ? 'No' : 'Yes';
                benefitClaimedList.add(benefitClaimedObj);
            }
            update benefitClaimedList;
        }    
    }
}