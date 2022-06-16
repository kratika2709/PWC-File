trigger BenefitClaimed on cve__BenefitClaimed__c (After insert) {
    if( trigger.isAfter && trigger.isInsert){
        BenefitClaimedTriggerHelper.afterInsert(trigger.new);
    }
}