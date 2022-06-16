/**
* Description : Helper Class For BenefitClaimedTrigger
* Created Date : 07-04-2022
* Owner : PWC
* */

public with sharing class BenefitClaimedTriggerHelper {
    public static void afterInsert(List<cve__BenefitClaimed__c> benefitClaimedList, Map<Id, cve__BenefitClaimed__c> newMAP) {
        Set<String> parentBenefitId = new Set<String>();
        Map<String, String> parentBenefitCodeMap = new Map<String, String>();
        Map<String, String> benefitWithParentBenefitMap = new Map<String, String>();
        for(cve__BenefitClaimed__c benefitClaimedObject: benefitClaimedList){
            parentBenefitId.add(benefitClaimedObject.cve__Benefit__c); 
            benefitWithParentBenefitMap.put(benefitClaimedObject.Id, benefitClaimedObject.cve__Benefit__c);
        }
        
        if(!parentBenefitId.isEmpty()){
            List<cve__Benefit__c> benefitList = [SELECT Id, Benefit_Code__c FROM cve__Benefit__c WHERE Id IN : parentBenefitId];
            for(cve__Benefit__c benefitObj : benefitList){
                parentBenefitCodeMap.put(benefitObj.Id, benefitObj.Benefit_Code__c);
            }
        }
        Map<String, List<Required_Documents__mdt>> mapOfRequiredDocument = new Map<String, List<Required_Documents__mdt>>();
        List<Required_Documents__mdt> requiredDocument = [SELECT DeveloperName,Benefit_Code__c FROM Required_Documents__mdt WHERE Benefit_Code__c != NULL];
        for(Required_Documents__mdt requiredMdt: requiredDocument){
            List<String> benefitCodes = requiredMdt.Benefit_Code__c.split(',');
            for(String benefitCodeStr :benefitCodes){
                List<Required_Documents__mdt>  listOfDocument = new List<Required_Documents__mdt>();                
                if(mapOfRequiredDocument.containsKey(benefitCodeStr))
                {
                    listOfDocument = mapOfRequiredDocument.get(benefitCodeStr);
                }
                listOfDocument.add(requiredMdt);
                mapOfRequiredDocument.put(benefitCodeStr,listOfDocument);
            }
        }            
        
        List<Sanlam_Required_Documents__c> requiredDocumentList = new List<Sanlam_Required_Documents__c>();
        for(String benefitClaimedObject: benefitWithParentBenefitMap.keySet()){
            if(benefitWithParentBenefitMap.get(benefitClaimedObject) != null &&
               parentBenefitCodeMap.containsKey(benefitWithParentBenefitMap.get(benefitClaimedObject)) 
               && parentBenefitCodeMap.get(benefitWithParentBenefitMap.get(benefitClaimedObject)) != null
               && mapOfRequiredDocument.containsKey(parentBenefitCodeMap.get(benefitWithParentBenefitMap.get(benefitClaimedObject)))){
                   for(Required_Documents__mdt key:  mapOfRequiredDocument.get(parentBenefitCodeMap.get(benefitWithParentBenefitMap.get(benefitClaimedObject)))){
                       Sanlam_Required_Documents__c claim = new  Sanlam_Required_Documents__c();
                       claim.Name = key.DeveloperName;
                       claim.Benefit_Claim__c = benefitClaimedObject;
                       claim.Sanlam_Required__c = true;
                       requiredDocumentList.add(claim);
                   }
               }
        }
        updateBenefitOwner(benefitClaimedList); 
        
        try{
            insert requiredDocumentList;
        } catch(Exception ex){
            
        }
    }
    
    private static void updateBenefitOwner(List<cve__BenefitClaimed__c> benefitClaimedList){
        List<cve__BenefitClaimed__c> benefitCodeAndOwnerList = [Select Id, cve__Benefit__r.Benefit_Code__c, Benefit_Claimed_Owner__c 
                                                                From cve__BenefitClaimed__c where Id IN : benefitClaimedList];
        Map<String, List<cve__BenefitClaimed__c>> mapOfCodeBenefit = createCodeBenefitMap(benefitCodeAndOwnerList);
        Map<String,List<String>> mapOfCodeAndUserId = getUserFromGroup();
        String lastAssignedUser;
        Map<String, String> mapOfCodeLastUserId = new Map<String, String>();
        list<cve__BenefitClaimed__c> bcToUpdate = new List<cve__BenefitClaimed__c>();
        List<cve__BenefitClaimed__c> latestBenefitClaimed = [Select Id, cve__Benefit__r.Benefit_Code__c, Benefit_Claimed_Owner__c 
                                                             From cve__BenefitClaimed__c where cve__Benefit__r.Benefit_Code__c != null 
                                                             AND cve__Benefit__r.Benefit_Code__c IN : mapOfCodeBenefit.keyset() ORDER BY CreatedDate DESC];        
        for(cve__BenefitClaimed__c bc : latestBenefitClaimed){
            if(!String.isEmpty(bc.Benefit_Claimed_Owner__c) && !mapOfCodeLastUserId.containsKey(bc.cve__Benefit__r.Benefit_Code__c)){
                mapOfCodeLastUserId.put(bc.cve__Benefit__r.Benefit_Code__c, bc.Benefit_Claimed_Owner__c);
            } 
        }
        for(cve__BenefitClaimed__c newBc : benefitCodeAndOwnerList){
            if(mapOfCodeAndUserId != null && mapOfCodeAndUserId.containsKey(newBc.cve__Benefit__r.Benefit_Code__c)){
                List<String> userList =  mapOfCodeAndUserId.get(newBc.cve__Benefit__r.Benefit_Code__c);
                if(mapOfCodeLastUserId != null && mapOfCodeLastUserId.containsKey(newBc.cve__Benefit__r.Benefit_Code__c) && string.isEmpty(lastAssignedUser)){
                    lastAssignedUser = mapOfCodeLastUserId.get(newBc.cve__Benefit__r.Benefit_Code__c);
                }
                if(!String.isEmpty(lastAssignedUser) && userList.contains(lastAssignedUser)){
                    integer indexOfLastUser = userList.indexOf(lastAssignedUser) + 1;
                    if(indexOfLastUser == userList.size()){
                        newBc.Benefit_Claimed_Owner__c = userList[0];
                    } else {
                        newBc.Benefit_Claimed_Owner__c = userList[indexOfLastUser];
                    }
                } else {
                    newBc.Benefit_Claimed_Owner__c =  userList[0];
                }
                lastAssignedUser = newBc.Benefit_Claimed_Owner__c;
                bcToUpdate.add(newBc);
            }
        }
        try{
            update bcToUpdate;
        } catch(Exception ex){
            system.debug('---Exception--- '+ex.getMessage());
            //TODO Exception handling
        }
    }
    
    private static Map<String, List<String>> getUserFromGroup(){
        Map<String, List<String>> mapCodeId = new Map<String, List<String>>();
        List<GroupMember> userGroupMembers = [SELECT UserOrGroupId, group.Name FROM GroupMember ORDER By UserOrGroupId];
        for(GroupMember userGroup : userGroupMembers){
            List<String> userId = new List<String>();
            if(mapCodeId.containsKey(userGroup.group.Name)){
                userId = mapCodeId.get(userGroup.group.Name);
            }
            userId.add(userGroup.UserOrGroupId);
            mapCodeId.put(userGroup.group.Name, userId);
        }
        return mapCodeId;
    }
    
    private static Map<String, List<cve__BenefitClaimed__c>> createCodeBenefitMap(List<cve__BenefitClaimed__c> benefitClaimedList){ 
        Map<String, List<cve__BenefitClaimed__c>> mapOfCodeBenefitMap = new Map<String, List<cve__BenefitClaimed__c>>();
        for(cve__BenefitClaimed__c bc : benefitClaimedList){
            List<cve__BenefitClaimed__c> bcList = new List<cve__BenefitClaimed__c>();
            if(mapOfCodeBenefitMap.containsKey(bc.cve__Benefit__r.Benefit_Code__c)){
                bcList = mapOfCodeBenefitMap.get(bc.cve__Benefit__r.Benefit_Code__c);
            }
            bcList.add(bc);
            mapOfCodeBenefitMap.put(bc.cve__Benefit__r.Benefit_Code__c, bcList);
        }
        return mapOfCodeBenefitMap;
    }
    
    public static void afterUpdate(List<cve__BenefitClaimed__c> benefitClaimedList , Map<Id, cve__BenefitClaimed__c> benefitClaimedMap){
        Set<String> benefitClaimedCoverageAmountId = new Set<String>();
        Set<String> benefitClaimedStatusId = new Set<String>();
        for(cve__BenefitClaimed__c benefitClaimed : benefitClaimedList)
        {
            if(benefitClaimed.cve__CoverageAmount__c != benefitClaimedMap.get(benefitClaimed.Id).cve__CoverageAmount__c)  
            {   
                benefitClaimedCoverageAmountId.add(benefitClaimed.Id);
            } 
             	if(!benefitClaimed.BCClaimClosed__c && benefitClaimed.cve__Status__c != benefitClaimedMap.get(benefitClaimed.Id).cve__Status__c)
            	{
               		benefitClaimedStatusId.add(benefitClaimed.Id);
            	}
        } 
        if(!benefitClaimedCoverageAmountId.isEmpty()){   
            callOuntInitialBenefitClaimedProvision(benefitClaimedCoverageAmountId);
        }
        if(!benefitClaimedStatusId.isEmpty()){
            callOutBCClaimClosed(benefitClaimedStatusId);
        }   
    }
    
    private static void  callOutBCClaimClosed(Set<String> benefitClaimedStatusId){
        List<Mainwrapper.ClaimContext> contextList = new List<Mainwrapper.ClaimContext>();
        List<Mainwrapper.Benefits> benefitList = new List<Mainwrapper.Benefits>();
        List<Mainwrapper.PolicyContext> policyList = new List<Mainwrapper.PolicyContext>();
        List<cve__BenefitClaimed__c> bcList = new  List<cve__BenefitClaimed__c>();
        for(cve__BenefitClaimed__c bcClaim: [Select cve__ClaimantInsuredAccount__c, cve__ClaimantInsuredAccount__r.Name,
                                                    cve__ClaimantInsuredAccount__r.cve_Sanlam_Member_ID__c,cve__CoverageAmount__c, 
                                                    cve__ClaimantInsuredAccount__r.recordTypeId, cve__ClaimantInsuredAccount__r.recordType.Name, 
                                             		Id, cve__Benefit__c, Name , cve__Policy__c, cve__Policy__r.Name , BCClaimClosed__c 
                                             		From cve__BenefitClaimed__c Where Id IN : benefitClaimedStatusId AND (cve__Status__c = 'Denied' OR cve__Status__c = 'Closed')])
        {
            Mainwrapper.ClaimContext context = new Mainwrapper.ClaimContext();
            context.accountId = bcClaim.cve__ClaimantInsuredAccount__c;
            context.accountName = bcClaim.cve__ClaimantInsuredAccount__r.Name;
            context.sanlamMemberNumber = bcClaim.cve__ClaimantInsuredAccount__r.cve_Sanlam_Member_ID__c;
            context.recordTypeId = bcClaim.cve__ClaimantInsuredAccount__r.recordTypeId;
            context.recordTypeName = 'personRecord'; //bcClaim.cve__ClaimantInsuredAccount__r.recordType.Name;
            //context.effectiveDate =  '2022-03-01T01:00:00.1234567+02:00';
            contextList.add(context);
            
            Mainwrapper.Benefits benefit = new Mainwrapper.Benefits();
            benefit.benefitId = bcClaim.cve__Benefit__c;
            benefit.benefitClaimedId = bcClaim.Id;
            benefit.benefitClaimedNumber = bcClaim.Name; 
            benefitList.add(benefit);
            
            Mainwrapper.PolicyContext policy  = new Mainwrapper.PolicyContext();
            policy.policyId = bcClaim.cve__Policy__c;
            policy.policyName = bcClaim.cve__Policy__r.Name;
            policy.Benefits = benefitList;
            policyList.add(policy);
            
            cve__BenefitClaimed__c  BenefitClaimedObj = new cve__BenefitClaimed__c();
            BenefitClaimedObj.Id = bcClaim.Id; 
            BenefitClaimedObj.BCClaimClosed__c = True ;
            bcList.add(BenefitClaimedObj); 
            
        }
       if(!bcList.isEmpty())
        try{
        	update bcList;
        }catch(Exception ex){
            
        }
            
        Mainwrapper.EventContext event = new Mainwrapper.EventContext();
        Claim_Event_Log__c obj = claimEventLog();
        event.eventId =  obj.Id;
        event.userId = userinfo.getuserid();                                                 
        event.userName = userinfo.getName();
        
        Mainwrapper.ClaimMangement claim = new Mainwrapper.ClaimMangement();
        claim.eventContext = event;
        claim.claimContext = contextList;
        claim.policyContext = policyList;
        claim.claimEventType = 'createBCClaimClosed';
        bcClosedEvent(JSON.serialize(claim));  
    }
    
    private static void callOuntInitialBenefitClaimedProvision(Set<String> benefitClaimedCoverageAmountId){
        List<Mainwrapper.ClaimContext> contextList = new List<Mainwrapper.ClaimContext>();
        List<Mainwrapper.BenefitsCoverage> benefitList = new List<Mainwrapper.BenefitsCoverage>();
        List<Mainwrapper.PolicyContextCoverage> policyList =  new List<Mainwrapper.PolicyContextCoverage> ();
        for(cve__BenefitClaimed__c bcClaim: [Select cve__ClaimantInsuredAccount__c, cve__ClaimantInsuredAccount__r.Name, 
                                                     cve__ClaimantInsuredAccount__r.cve_Sanlam_Member_ID__c,cve__CoverageAmount__c, 
                                                     cve__ClaimantInsuredAccount__r.recordTypeId, cve__ClaimantInsuredAccount__r.recordType.Name, 
                                                     Id, cve__Benefit__c, Name , cve__Policy__c, cve__Policy__r.Name 
                                                     From cve__BenefitClaimed__c Where Id IN : benefitClaimedCoverageAmountId AND  cve__Claim__r.cve__Status__c = 'Open'])
        {
            Mainwrapper.ClaimContext context = new Mainwrapper.ClaimContext();
            context.accountId = bcClaim.cve__ClaimantInsuredAccount__c;
            context.accountName = bcClaim.cve__ClaimantInsuredAccount__r.Name;
            context.sanlamMemberNumber = bcClaim.cve__ClaimantInsuredAccount__r.cve_Sanlam_Member_ID__c;
            context.recordTypeId = bcClaim.cve__ClaimantInsuredAccount__r.recordTypeId;
            context.recordTypeName = 'personRecord'; //bcClaim.cve__ClaimantInsuredAccount__r.recordType.Name;
            //context.effectiveDate =  '2022-03-01T01:00:00.1234567+02:00';
            contextList.add(context);
            
            Mainwrapper.BenefitsCoverage benefit = new Mainwrapper.BenefitsCoverage();
            benefit.benefitId = bcClaim.cve__Benefit__c;
            benefit.benefitClaimedId = bcClaim.Id;
            benefit.benefitClaimedNumber = bcClaim.Name; 
            benefit.coverageAmount = bcClaim.cve__CoverageAmount__c;
            benefitList.add(benefit);
            
            Mainwrapper.PolicyContextCoverage policy  = new Mainwrapper.PolicyContextCoverage();
            policy.policyId = bcClaim.cve__Policy__c;
            policy.policyName = bcClaim.cve__Policy__r.Name;
            policy.Benefits = benefitList;
            policyList.add(policy);
        }
        Mainwrapper.EventContext event = new Mainwrapper.EventContext();
        Claim_Event_Log__c obj = claimEventLog();
        event.eventId =  obj.Id;
        event.userId = userinfo.getuserid();                                                 
        event.userName = userinfo.getName();
        
        Mainwrapper.ClaimMangementCoverage claim = new Mainwrapper.ClaimMangementCoverage();
        claim.eventContext = event;
        claim.claimContext = contextList;
        claim.policyContext = policyList;
        claim.claimEventType = 'createinitialBenefitClaimedProvision';
        makeCreateClaimCallout(JSON.serialize(claim));
    }
    
    private static Claim_Event_Log__c claimEventLog()
    {
        Claim_Event_Log__c eve = new Claim_Event_Log__c();
        eve.EventType__c = '';
        eve.EventSubType__c = '';
        eve.Status__c = 'Not Yet Started';
        try
        {
            insert eve;
        } 
        catch(Exception ex)
        {
            
        }
        return eve;
    }
    
    @Future(callout=true)
    public static void makeCreateClaimCallout(String claim)
    {
        Mainwrapper.ClaimMangementCoverage ClaimMangementobj = ( Mainwrapper.ClaimMangementCoverage) JSON.deserialize(claim,  Mainwrapper.ClaimMangementCoverage.class); 
        ClaimEventType.initialBenefitClaimedProvision(ClaimMangementobj);
    }
    
    @Future(callout=true)
    public static void bcClosedEvent(String claim)
    {
        Mainwrapper.ClaimMangement ClaimMangementobj = (Mainwrapper.ClaimMangement) JSON.deserialize(claim, Mainwrapper.ClaimMangement.class); 
        ClaimEventType.bcClaimClosed(ClaimMangementobj);
    } 
}