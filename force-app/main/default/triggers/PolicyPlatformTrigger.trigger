trigger PolicyPlatformTrigger on PE_Sanlam_Retrieve_Policy__e (after insert) {
    
    if(trigger.IsInsert && trigger.IsAfter){
        PartySearchPlatformController.policySearch(trigger.new);
    }
}