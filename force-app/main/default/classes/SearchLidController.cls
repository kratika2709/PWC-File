public with sharing class SearchLidController {
    public static Map<String, String> staticMappingMap = new Map<String, String>{'name' => 'FirstName', 
                                                                                'surname'=> 'LastName',
                                                                                'Name'=> 'Name',
                                                                                'birth_date'=> 'Birthdate',
                                                                                'email_address'=> 'Email',
                                                                                'phone_details'=> 'Phone',
                                                                                'PolicyNumber'=>'Name',
                                                                                'organisation_name'=>'Name',
                                                                                'registration_number'=> 'Registration_Number__c',
                                                                                'member_number'=>'Member_Number__pc'}; 
            
    @AuraEnabled
    public static List<Sobject> lidController(string jsonString, String obejctApiName){
        System.debug('jsonString---->'+jsonString);
        Map<String, String> obj = (Map<String, String>) JSON.deserialize(jsonString, Map<String, String>.class);
        system.debug(obj);
        String queryConditionString = ' WHERE ';
        for(String mapKey : staticMappingMap.keySet()){
            system.debug('Map Value--->'+obj.get(mapKey)+'-------->'+mapKey);
            if(staticMappingMap.containsKey(mapKey) && !string.isEmpty(obj.get(mapKey))){
                if(mapKey == 'name' || mapKey == 'surname' || mapKey == 'email_address' || mapKey == 'phone_details' || mapKey == 'PolicyNumber' || mapKey == 'organisation_name' || mapKey =='registration_number' || mapKey =='member_number'){
                    queryConditionString += staticMappingMap.get(mapKey) + ' = \''+obj.get(mapKey)+'\'' + ' AND ';
                    system.debug(queryConditionString);
                } else {
                    queryConditionString += staticMappingMap.get(mapKey) + ' = ' +obj.get(mapKey) + ' AND ';
                     system.debug(queryConditionString);
                }
                
            }
        }
        String fieldName = '';
        if(obejctApiName == 'Contact'){
            fieldName = ' FirstName , LastName , Name , Birthdate , Email , Tax_Number__c , Member_Number__c , Intermediary_Code__c , Phone';
        } else if(obejctApiName == 'cve__Policy__c'){
            fieldName = ' Name , cve__ProductName__c , cve__Version__c , cve__LineOfBusiness__c , cve__Status__c , Plan_State__c ';
        } else if(obejctApiName =='Account'){
            fieldName =   'Name, PersonBirthdate, Registration_Number__c, Member_Number__pc, cve_Sanlam_Intermediary_Code__c ';
        }
        String queryString  = ' Select ';
        queryString += fieldName + ' from '+obejctApiName;
        if(queryConditionString != ' WHERE '){
            queryString += queryConditionString;
            if(queryString.endsWith(' AND ')){
                queryString = queryString.removeEnd(' AND ');
            }
            system.debug(queryString);
            List<Sobject> objects = Database.query(queryString);
            System.debug(objects);
            return objects ;
        } else {
            return null;
        }
    }

    @AuraEnabled
    public static String serchPartyByRegistrationNumber(string jsonString, string radioVal){
        String responseString;
        String body;
        system.debug('LID object json---'+jsonString);
        LidWrapper lidObj = (LidWrapper) JSON.deserialize(jsonString, LidWrapper.class);
        system.debug('LID object---'+lidObj);
       if(radioVal == 'Person'){
        body = '{"searchType":"Person",';
       } else if(radioVal == 'LegalEntity'){
        body = '{"searchType":"Organisation",';
       }
        
        String bodyFields = '';
        bodyFields += !String.isEmpty(lidObj.name) ? '"name":"'+lidObj.name+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.surname) ? '"surname":"'+lidObj.surname+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.birth_date) ? '"birthDate":"'+lidObj.birth_date+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.phone_details) ? '"phoneDetails":"'+lidObj.phone_details+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.email_address) ? '"emailAddress":"'+lidObj.email_address+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.registration_type) && !String.isEmpty(lidObj.registration_number) ? '"registrationType":"'+lidObj.registration_type+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.client_number) ? '"clientNumber":"'+lidObj.client_number+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.plan_number) ? '"planNumber":"'+lidObj.plan_number+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.registration_type) && !String.isEmpty(lidObj.registration_number) ? '"registrationNumber":"'+lidObj.registration_number+'"'+',': '';
        bodyFields += !String.isEmpty(lidObj.member_number) ?'"organisationNumber":"'+lidObj.member_number+'"'+',' : '';
        bodyFields += !String.isEmpty(lidObj.organisation_name) ?'"organisationName":"'+lidObj.organisation_name+'"'+',' : '';

        if(bodyFields.endsWith(',')){
            bodyFields = bodyFields.removeEnd(',');
        }
        bodyFields += '}';
        String reqBody = body+bodyFields;
        system.debug(reqBody);
        HttpController.ResponseTokenWrapper responseWrapper = getToken();
         List<Party_Search__mdt> partySearch = [Select Id, Content_Type__c, Enpoint__c, Header__c, Method__c, Application__c,Bearer__c 
                                                 From Party_Search__mdt Where MasterLabel = 'Person Search'];
        system.debug(partySearch);
         String headerWithToken = partySearch[0].Bearer__c+' '+responseWrapper.access_token;
         String response = HttpController.createCallout(reqBody, partySearch[0].Enpoint__c, partySearch[0].Method__c, partySearch[0].Content_Type__c, partySearch[0].Application__c, headerWithToken, partySearch[0].Header__c,true);
        
        if(radioVal == 'Person'){
            ResponseWrapper obj = (ResponseWrapper) JSON.deserialize(response, ResponseWrapper.class);  
            responseString = JSON.serialize(obj);
        } else if(radioVal == 'LegalEntity'){
            LegalEntityWrapper Entityobj = (LegalEntityWrapper) JSON.deserialize(response, LegalEntityWrapper.class); 
            system.debug('Response---->'+Entityobj);
            responseString = JSON.serialize(Entityobj);
        }
        System.debug(responseString);
        updateCustomSetting(responseWrapper);
        return responseString;//JSON.serialize(obj);
    }

    @AuraEnabled
    public static String serchPolicyByPlanNumber(String planNumber){
        System.debug('Plan num --->'+planNumber);
        List<PlanNumberForScreen> planNumberList = new List<PlanNumberForScreen>();
        List<Party_Search__mdt> partySearch = [Select Id, Enpoint__c, Header__c, Method__c,Bearer__c From Party_Search__mdt Where MasterLabel = 'Policy search'];
        HttpController.ResponseTokenWrapper responseWrapper = getToken();
        String headerWithToken = partySearch[0].Bearer__c+' '+responseWrapper.access_token;
        String response = HttpController.createCallout('', partySearch[0].Enpoint__c+planNumber, partySearch[0].Method__c, '', '', headerWithToken, partySearch[0].Header__c,true);
        PlanNumberWrapper planNumberResponse = (PlanNumberWrapper)JSON.deserialize(response, PlanNumberWrapper.class);  
        System.debug(planNumberResponse);
        for(SearchLidController.PlanDetails  planDetail : planNumberResponse.planDetails){
            PlanNumberForScreen planNumberObj = new PlanNumberForScreen();
            planNumberObj.policyNumber = planDetail.planNumber;
            planNumberObj.policyDescription = planDetail.partyRoleDetailsList.partyRoleDetails[0].role.roleDescriptionEnglish;	
            planNumberObj.fullName = planDetail.partyRoleDetailsList.partyRoleDetails[0].partyIdentificationDetails.partyFirstName+' '+planDetail.partyRoleDetailsList.partyRoleDetails[0].partyIdentificationDetails.partySurname;
            planNumberObj.memberId = planDetail.partyRoleDetailsList.partyRoleDetails[0].partyIdentificationDetails.partyNumber;	
            planNumberObj.idNumber = planDetail.partyRoleDetailsList.partyRoleDetails[0].role.roleCode;
            planNumberObj.countryOfIssue = planDetail.partyRoleDetailsList.partyRoleDetails[0].partyIdentificationDetails.preferredLanguage;
            planNumberObj.birthdate = planDetail.partyRoleDetailsList.partyRoleDetails[0].partyIdentificationDetails.birthDate;
            planNumberList.add(planNumberObj);
        }
        updateCustomSetting(responseWrapper);
        return JSON.serialize(planNumberList);
    
    }

    @AuraEnabled
    public static void tableController(string clientNumber){
        system.debug('clientNumber'+clientNumber);
        /*
         *  HttpController.ResponseTokenWrapper getToken = HttpController.authorizationCallForPartySearch();//OrchestrationFrameworkHelperFlow2.authorizationCall();
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api-tst.sanlam.co.za/spf/claimmanagement/informationRequest');
            request.setMethod('POST');
            request.setHeader('Authorization', ' Bearer '+getToken.access_token);
            request.setHeader('Content-Type','application/json;charset=UTF-8');
            request.setBody('{"correlationId":"6f5a3e15-171c-4918-9dbe-6646df32ce04", "claimUserID":"00526000007zsm0AAA","businessContext":"Client Details", "clientNumber":"AP6K0379","partyTypeID":"01226000001ZauYAAS","partyType":"Person"}');
            request.setTimeout(120000);
            HttpResponse response = http.send(request);
            System.debug(response.getStatusCode()+'------------'+response.getStatus());*/        
        
    }

    public static HttpController.ResponseTokenWrapper getToken(){
        HttpController.ResponseTokenWrapper response = new HttpController.ResponseTokenWrapper();
        String token;
        Auth_Lid_Callout__c authLidCallout = Auth_Lid_Callout__c.getOrgDefaults();
        if(datetime.now() < authLidCallout.Token_expiration__c){
            response.access_token = authLidCallout.Token__c;
        } else {
            response = HttpController.authorizationCallForPartySearch();
        }
        return response;
    }

    /**
    * @author Manish Kaushik 
    * @date 09/24/2021
    * @description Method use to update custome Setting with new token and other values.
    * @return void 
    */
    public static void updateCustomSetting(HttpController.ResponseTokenWrapper responseWraper){
        Auth_Lid_Callout__c authLidCallout = Auth_Lid_Callout__c.getOrgDefaults();
        Integer hourToAdd = !String.Isempty(responseWraper.expires_in) ? Integer.valueOf(DateTime.valueOf(Integer.valueOf(responseWraper.expires_in)*1000).formatGMT('HH')) : null;
        authLidCallout.Token__c = responseWraper.access_token;
        if(!String.Isempty(responseWraper.refresh_token)){
            authLidCallout.Refresh_Token__c = responseWraper.refresh_token;
            authLidCallout.Refresh_Token_Expiration__c = date.today().addDays(1);
        }
        if(hourToAdd != null){
            authLidCallout.Token_expiration__c = DateTime.now().addHours(hourToAdd);
        }
        update authLidCallout;
    }

    public class PlanNumberForScreen{
        @AuraEnabled public String policyNumber;
        @AuraEnabled public String policyDescription;	
        @AuraEnabled public String fullName;
        @AuraEnabled public String memberId;	
        @AuraEnabled public String idNumber;
        @AuraEnabled public String countryOfIssue;
        @AuraEnabled public String birthdate;
    }
    
    public class LidWrapper{
        @AuraEnabled public String searchType;
        @AuraEnabled public String name;
        @AuraEnabled public String surname;	
        @AuraEnabled public String birth_date;
        @AuraEnabled public String phone_details;	
        @AuraEnabled public String email_address;
        @AuraEnabled public String registration_type;
        // @AuraEnabled public String RSANamibianID;	
        // @AuraEnabled public String ForelgnPassport;	
        // @AuraEnabled public String TaxNumber;	
        @AuraEnabled public String client_number;	
        @AuraEnabled public String plan_number;	
        @AuraEnabled public String IntermediaryNumber;	
        @AuraEnabled public String PolicyNumber;
        @AuraEnabled public String registration_number;
        @AuraEnabled public String organisation_name;
        @AuraEnabled public String member_number;

    }
    
    public class ResponseWrapper{
        public List<ClientIdentifications> ClientIdentifications;
    }
    
    public class ClientIdentifications {
        public PersonName personName;
        public String clientNumber;	//AA6VT166
        public String rsaIdNumber;	//6206130150086
        public String passportNumber;	//
        public String citizenshipDescription;	//South Africa
        public String birthDate;	//1962-06-13
        public String genderDescription;	//Female
        public String jockeyCode;	//00169854
        public PostalAddress postalAddress;
    }
    
    public class PersonName {
        public String surname;	//De Kock
        public String preferredName;	//Tertia
    }
    
    public class PostalAddress {
        public String addressLine1;	//Posbus 7266
    }
    
    public class ClientNumberWrapper{
        public List<intermediaryList> intermediaryList;
        public String clientNumber;	//AP6KO379
        public String jockeyCode;	//00895832
        public partyDetails partyDetails;
    }
    
    public class intermediaryList {
    }
    
    public class partyDetails {
        public String rsaIdNumber;	//6011095116084
        public String passportNumber;	//
        public String countryOfIssueDescription;	//South Africa
        public String birthDate;	//1960-11-09
        public String genderDescription;	//Male
        public postalAddress postalAddress;
        public personName personName;
    }
    
    public class ClientpostalAddress {
        public String addressLine1;	//Bela-Bela 33g130
        public String addressLine4;	//Warmbaths
        public String postalCode;	//0480
        public String dateAddressLastUpdated;	//2022-01-25
        public boolean noPrintFlag;
        public String sourceChange;	//00
        public String sourceChangeDescription;	//Unknown
        public boolean foreignAddressIndicator;
        public boolean unknownAddressIndicator;
    }
    
    public class ClientpersonName {
        public String surname;	//De Kock
        public String initials;	//BB
        public String fullNames;	//Barend,Bartolomias
        public String preferredName;	//Bennie
        public String firstName;
    }  
    
    public class PlanNumberWrapper{
        public List<PlanDetails> planDetails;
    }
    
    public class PlanDetails {
        public String planNumber;	//0406345785
        public PartyRoleDetailsList partyRoleDetailsList;
    }

    public class PartyRoleDetailsList {
        public List<PartyRoleDetails> partyRoleDetails;
    }

    public class PartyRoleDetails {
        public Role role;
        public PartyIdentificationDetails partyIdentificationDetails;
    }

    public class Role {
        public String roleType;
        public String roleCode;	//M006
        public String roleDescriptionEnglish;	//Millennium Beneficiary        
    }

    public class PartyIdentificationDetails {
        public String partyNumber;	//AF8FR278
        public String partyType;	//1
        public String partySurname;	//De Kock
        public String partyFirstName;	//Martha
        public String partyInitials;	//ME    
        public String organisationName;	//
        public String preferredLanguage;	//Afr  
        public String birthDate;	//1973-10-03
    }

    public class LegalEntityWrapper {
        public LegalEntityList OrganisationIdentificationList;
        public OrganisationIdentificationSearchPagination OrganisationIdentificationSearchPagination;
    }

    public class LegalEntityList {
        public List<LegalEntityResponse> OrganisationIdentificationDetails;
    }
        
    public class LegalEntityResponse {
        public String organisationNumber;	//AA8W2408
        public String organisationName;	//Nedbank
        public String contactPerson;	//The Manager
        public String organisationType;	//01
        public String organisationTypeDescription;	//Listed company
        public String correspondanceLanguageCode;	//01
        public String correspondanceLanguageDescription;	//English
        public String citizenshipCode;	//
        public String citizenshipDescription;	//
        public String securityIndicator;	//false
        public String organisationStatus;	//Active
        public String registrationNumber;	//1951/000009/06
        public String taxMonth;	//
        public String jockeyCode;	//
        public String workPhone;
        public String workFax;
        public String preferredEmail;
        public String postalAddress;
    }

    public class OrganisationIdentificationSearchPagination {
		public Integer pageSize;	//10
		public Integer pageNumber;	//1
		public Integer totalRecords;	//-1
	}
        
}