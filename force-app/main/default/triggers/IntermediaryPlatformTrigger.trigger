trigger IntermediaryPlatformTrigger on PE_Sanlam_Retrieve_Intermediary__e (after insert) {
    
    if(trigger.IsInsert && trigger.IsAfter){
        PartySearchPlatformController.intermediarySearch(trigger.new);
    }
}