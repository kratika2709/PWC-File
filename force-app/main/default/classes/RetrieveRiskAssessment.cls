public with sharing class RetrieveRiskAssessment {
    
    @AuraEnabled(cacheable=true) 
    public static string getPersonMember( String recId ){
        
        return [ SELECT Id, cve_Sanlam_Member_ID__c FROM Account WHERE Id= :recId LIMIT 1 ].cve_Sanlam_Member_ID__c;
    }
    
    @AuraEnabled
    public static string callClaimEvent( String accountData, Boolean isTask, String eventType, Boolean isAccount ){
        
        try
        {
            claimEvent.requestClaimEvent( accountData,  isTask,  eventType, isAccount );
            
            return 'Success';
        }
        catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
}