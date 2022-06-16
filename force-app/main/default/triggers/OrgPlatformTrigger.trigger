trigger OrgPlatformTrigger on PE_Sanlam_Retrieve_Legal_Entity__e (after insert) {
    
    if(trigger.IsInsert && trigger.IsAfter){
        PartySearchPlatformController.organisationSearch(trigger.new);
    }
}