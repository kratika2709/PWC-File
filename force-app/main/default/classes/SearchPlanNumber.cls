public class SearchPlanNumber {
    @AuraEnabled
    public static String serchPolicyByPlanNumber(String planNumber){
        Mainwrapper.PlanNumberWrapper planNumberResponse = new  Mainwrapper.PlanNumberWrapper();
        System.debug('Plan num --->'+planNumber);
        List<Mainwrapper.PlanNumberForScreen> planNumberList = new List<Mainwrapper.PlanNumberForScreen>();
        List<Party_Search__mdt> partySearch = [Select Id, Enpoint__c, Header__c, Method__c,Bearer__c From Party_Search__mdt Where MasterLabel = 'Policy search'];
        HttpController.ResponseTokenWrapper responseWrapper = Mainwrapper.getToken();
        system.debug('responsewrapper------>'+responseWrapper);
        String headerWithToken = partySearch[0].Bearer__c+' '+responseWrapper.access_token;
        system.debug('res---->'+partySearch[0].Enpoint__c+planNumber);
        HttpResponse response = HttpController.createCallout('', partySearch[0].Enpoint__c+planNumber, partySearch[0].Method__c, '', '', headerWithToken, partySearch[0].Header__c,true);
        system.debug('response'+response);
        if(response.getStatusCode() == 200 || response.getStatusCode() == 202){
            planNumberResponse = (Mainwrapper.PlanNumberWrapper)JSON.deserialize(response.getBody(), Mainwrapper.PlanNumberWrapper.class);  
        }
        System.debug(planNumberResponse);
        if(planNumberResponse != NULL && !planNumberResponse.planDetails.isEmpty()){
            for(Mainwrapper.PlanDetails  planDetail : planNumberResponse.planDetails){
                Mainwrapper.PlanNumberForScreen planNumberObj = new Mainwrapper.PlanNumberForScreen();
                planNumberObj.policyNumber = planDetail.planNumber;
                planNumberObj.policyDescription = planDetail.partyRoleDetailsList.partyRoleDetails[0].role.roleDescriptionEnglish;	
                planNumberObj.fullName = planDetail.partyRoleDetailsList.partyRoleDetails[0].partyIdentificationDetails.partyFirstName+' '+planDetail.partyRoleDetailsList.partyRoleDetails[0].partyIdentificationDetails.partySurname;
                planNumberObj.memberId = planDetail.partyRoleDetailsList.partyRoleDetails[0].partyIdentificationDetails.partyNumber;	
                planNumberObj.idNumber = planDetail.partyRoleDetailsList.partyRoleDetails[0].role.roleCode;
                planNumberObj.countryOfIssue = planDetail.partyRoleDetailsList.partyRoleDetails[0].partyIdentificationDetails.preferredLanguage;
                planNumberObj.birthdate = planDetail.partyRoleDetailsList.partyRoleDetails[0].partyIdentificationDetails.birthDate;
                planNumberList.add(planNumberObj);
            }
        }
        Mainwrapper.updateCustomSetting(responseWrapper);
        return JSON.serialize(planNumberList);
        
    }
    
}