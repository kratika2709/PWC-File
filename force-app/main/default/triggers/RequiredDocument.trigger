trigger RequiredDocument on Sanlam_Required_Documents__c (after insert, after update) {
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            RequiredDocumentTriggerHelper.updateBenifitClaim(Trigger.new, Trigger.oldMap);
        }
    }
}