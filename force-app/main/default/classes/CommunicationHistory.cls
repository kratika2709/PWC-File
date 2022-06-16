public with sharing class CommunicationHistory {
    @AuraEnabled
    public static List<Sanlam_Communication_History__c> fetchCommunicationHistory(String recordId) {
    
        return [Select Name,Message_Contact_Details__c, Activity_Type__c, Contact_Category__c, Communication_ID__c,communication_link__c,
         Claim_Number__c, CreatedDate, CreatedById,Policy_Number__c From Sanlam_Communication_History__c WHERE Member_Name__c = :recordId 
         OR Policy_Number__c = :recordId OR Person__c = :recordId OR Benefit_Claimed_Relationship__c = :recordId OR Claim_Number__c = :recordId];
    }
}