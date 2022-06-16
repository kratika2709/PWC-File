public with sharing class ClaimTriggerHelper 
{
    public static void callOutClaim(List<cve__Claim__c> claimList, Map<Id, cve__Claim__c> claimOldMAP)
    {
        Set<String> claimId = new Set<String>();
        List<Mainwrapper.ClaimContext> contextList = new List<Mainwrapper.ClaimContext>();
        Set<Mainwrapper.ClaimContext> contextSet = new Set<Mainwrapper.ClaimContext>();
        List<Mainwrapper.PolicyContext> policyList =  new List<Mainwrapper.PolicyContext> ();
        Mainwrapper.EventContext event = new Mainwrapper.EventContext();
        Set<String> policyNamesSet = new Set<String>();
        if(claimList != Null )
        {
            for(cve__Claim__c claimObj : claimList)
            {
                if(!claimObj.ClaimEventLogTrigger__c && claimOldMAP != null)
                { 
                    if(claimOldMAP.get(ClaimObj.Id).cve__Status__c != ClaimObj.cve__Status__c && ClaimObj.cve__Status__c == 'Open')
                    {
                        claimId.add(claimObj.Id);
                    }
                }
            }
        }
        if(claimId != null)
        {
            for(cve__Claim__c claim : [Select cve__ClaimantInsuredAccount__c, cve__ClaimantInsuredAccount__r.Name, cve__ClaimantInsuredAccount__r.cve_Sanlam_Member_ID__c ,cve__ClaimantInsuredAccount__r.recordTypeId, cve__ClaimantInsuredAccount__r.recordType.Name, cve__PolicyNames__c From cve__Claim__c Where Id IN :claimId])
            {
                Mainwrapper.ClaimContext context = new Mainwrapper.ClaimContext();
                context.accountId = claim.cve__ClaimantInsuredAccount__c;
                context.accountName = claim.cve__ClaimantInsuredAccount__r.Name;
                context.sanlamMemberNumber = claim.cve__ClaimantInsuredAccount__r.cve_Sanlam_Member_ID__c;
                context.recordTypeId = claim.cve__ClaimantInsuredAccount__r.recordTypeId;
                context.recordTypeName = 'personRecord'; //claim.cve__ClaimantInsuredAccount__r.recordType.Name;
                //context.effectiveDate =  '2022-03-01T01:00:00.1234567+02:00';
                contextSet.add(context);
            }
        } 
        Set<String> policyIds = new Set<String>();
        for(cve__BenefitClaimed__c bcClaim : [Select cve__Policy__c From cve__BenefitClaimed__c Where cve__Claim__c IN :claimId]){
            policyIds.add(bcClaim.cve__Policy__c);
        }
        
        List<cve__Policy__c> listPolicy = [Select Id, Name , (SELECT Id, Name, cve__Claim__c, cve__Benefit__c, cve__Policy__c 
                                                              FROM cve__BenefitClaimeds__r where cve__Claim__c IN : claimId) from cve__Policy__c WHERE Id In : policyIds];
        for(cve__Policy__c policyObj : listPolicy)
        {
            List<Mainwrapper.Benefits> benefitList = new List<Mainwrapper.Benefits>();
            Mainwrapper.PolicyContext policy  = new Mainwrapper.PolicyContext();
            policy.policyId = policyObj.Id;
            policy.policyName = policyObj.Name;
            for(cve__BenefitClaimed__c bcClaim : policyObj.cve__BenefitClaimeds__r)
            {
                Mainwrapper.Benefits benefit = new Mainwrapper.Benefits();
                benefit.benefitId = bcClaim.cve__Benefit__c;
                benefit.benefitClaimedId = bcClaim.Id;
                benefit.benefitClaimedNumber= bcClaim.Name;  
                benefitList.add(benefit);
            }
            policy.Benefits = benefitList;
            policyList.add(policy);
        }
        Mainwrapper.ClaimMangement claim = new Mainwrapper.ClaimMangement();
        if(!contextSet.isEmpty() && contextSet.size()> 0 && !policyList.isEmpty() && policyList.size()> 0 && event != null)
        {
            Claim_Event_Log__c obj = claimEventLog();
            event.eventId =  obj.Id;
            event.userId = userinfo.getuserid();                                                 
            event.userName = userinfo.getName();
            
            List<cve__Claim__c> claimUpdate =new  List<cve__Claim__c>();
            for(cve__Claim__c claimObj : claimList){
                cve__Claim__c claimObject = new cve__Claim__c();
                claimObject.Id = claimObj.Id;
                claimObject.ClaimEventLogTrigger__c =True;
                claimUpdate.add(claimObject);
            }
            if(claimUpdate !=Null){
                try{
                    update claimUpdate;
                } catch(Exception ex){
                }
            }
            contextList.addAll(contextSet);
            claim.claimEventType = 'createClaim';
            claim.eventContext = event;
            claim.claimContext = contextList;
            claim.policyContext = policyList; 
            makeCreateClaimCallout(JSON.serialize(claim));
        }
    }
    private static Claim_Event_Log__c claimEventLog()
    {
        Claim_Event_Log__c eve = new Claim_Event_Log__c();
        eve.EventType__c = '';
        eve.EventSubType__c = '';
        eve.Status__c = 'Not Yet Started';
        try{
            insert eve;
        } catch(Exception ex){
            
        }
        return eve;
    }
    @Future(callout=true)
    public static void makeCreateClaimCallout(String claim){
        Mainwrapper.ClaimMangement ClaimMangementobj = ( Mainwrapper.ClaimMangement) JSON.deserialize(claim,  Mainwrapper.ClaimMangement.class); 
        ClaimEventType.createContext(ClaimMangementobj);
    }
    
    public static void finaliseClaimEvent(List<cve__Claim__c> claimList, Map<Id, cve__Claim__c> claimOldMAP){
        Set<String> claimId = new Set<String>();
        List<Mainwrapper.ClaimContext> contextList = new List<Mainwrapper.ClaimContext>();
        Set<Mainwrapper.ClaimContext> contextSet = new Set<Mainwrapper.ClaimContext>();
        List<Mainwrapper.PolicyContext> policyList =  new List<Mainwrapper.PolicyContext> ();
        Mainwrapper.EventContext event = new Mainwrapper.EventContext();
        Set<String> policyNamesSet = new Set<String>();
        if(claimList != Null )
        { system.debug('claimOldMAP : '+claimOldMAP);
            for(cve__Claim__c claimObj : claimList)
            {
                if(claimOldMAP != null)
                { 
                    if(claimOldMAP.get(ClaimObj.Id).cve__Status__c != ClaimObj.cve__Status__c && ClaimObj.cve__Status__c == 'Closed')
                    {
                        claimId.add(claimObj.Id);
                    }
                }
            }
        }
        if(claimId != null)
        {
            for(cve__Claim__c claim : [Select cve__ClaimantInsuredAccount__c, cve__ClaimantInsuredAccount__r.Name, cve__ClaimantInsuredAccount__r.cve_Sanlam_Member_ID__c ,cve__ClaimantInsuredAccount__r.recordTypeId, cve__ClaimantInsuredAccount__r.recordType.Name, cve__PolicyNames__c From cve__Claim__c Where Id IN :claimId])
            {
                Mainwrapper.ClaimContext context = new Mainwrapper.ClaimContext();
                context.accountId = claim.cve__ClaimantInsuredAccount__c;
                context.accountName = claim.cve__ClaimantInsuredAccount__r.Name;
                context.sanlamMemberNumber = claim.cve__ClaimantInsuredAccount__r.cve_Sanlam_Member_ID__c;
                context.recordTypeId = claim.cve__ClaimantInsuredAccount__r.recordTypeId;
                context.recordTypeName = 'personRecord'; //claim.cve__ClaimantInsuredAccount__r.recordType.Name;
                //context.effectiveDate =  '2022-03-01T01:00:00.1234567+02:00';
                contextSet.add(context);
            }
        } 
        Set<String> policyIds = new Set<String>();
        for(cve__BenefitClaimed__c bcClaim : [Select cve__Policy__c From cve__BenefitClaimed__c Where cve__Claim__c IN :claimId]){
            policyIds.add(bcClaim.cve__Policy__c);
        }
        
        List<cve__Policy__c> listPolicy = [Select Id, Name , (SELECT Id, Name, cve__Claim__c, cve__Benefit__c, cve__Policy__c 
                                                              FROM cve__BenefitClaimeds__r where cve__Claim__c IN : claimId) from cve__Policy__c WHERE Id In : policyIds];
        for(cve__Policy__c policyObj : listPolicy)
        {
            List<Mainwrapper.Benefits> benefitList = new List<Mainwrapper.Benefits>();
            Mainwrapper.PolicyContext policy  = new Mainwrapper.PolicyContext();
            policy.policyId = policyObj.Id;
            policy.policyName = policyObj.Name;
            for(cve__BenefitClaimed__c bcClaim : policyObj.cve__BenefitClaimeds__r)
            {
                Mainwrapper.Benefits benefit = new Mainwrapper.Benefits();
                benefit.benefitId = bcClaim.cve__Benefit__c;
                benefit.benefitClaimedId = bcClaim.Id;
                benefit.benefitClaimedNumber= bcClaim.Name;  
                benefitList.add(benefit);
            }
            policy.Benefits = benefitList;
            policyList.add(policy);
        }
        Mainwrapper.ClaimMangement claim = new Mainwrapper.ClaimMangement();
        if(!contextSet.isEmpty() && contextSet.size()> 0 && !policyList.isEmpty() && policyList.size()> 0 && event != null)
        {
            Claim_Event_Log__c obj = claimEventLog();
            event.eventId =  obj.Id;
            event.userId = userinfo.getuserid();                                                 
            event.userName = userinfo.getName();
            
          
            contextList.addAll(contextSet);
            claim.claimEventType = 'finaliseClaim';
            claim.eventContext = event;
            claim.claimContext = contextList;
            claim.policyContext = policyList; 
            makeCreateClaimCallout(JSON.serialize(claim));
        }
    }
    
}