trigger ClaimTrigger on cve__Claim__c (after update) {
    if(Trigger.isAfter)
    {
        if(Trigger.isUpdate)
        {
            ClaimTriggerHelper.callOutClaim(Trigger.new, Trigger.oldMap);
        }
    }
}