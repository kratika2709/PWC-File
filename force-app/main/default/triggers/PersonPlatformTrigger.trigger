trigger PersonPlatformTrigger on PE_Sanlam_Retrieve_Person__e (after insert) {

    if(trigger.IsInsert && trigger.IsAfter){
        PartySearchPlatformController.personSearch(trigger.new);
    }
}