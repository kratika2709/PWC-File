/**
* Description : DTO utility class.
* Created Date : 07-04-2022
* Owner : PWC
* */

public class Mainwrapper {
    
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
        public String firstName; // Gert
        public String initials; //GJ
        public String fullNames; // Gert Johannes
    }
    
    public class PostalAddress {
        public String addressLine1;	//Posbus 7266
        public String addressLine2;
        public String addressLine3;
        public String addressLine4;
        public String postalCode;
    }
    
    public class PrefferedEmail{
        public String emailAddress; //gjstone@interkom.co.za
    }
    
    public class ClientNumberWrapper{
        public List<IntermediaryList> intermediaryList;
        public String clientNumber;	//AP6KO379
        public String jockeyCode;	//00895832
        public PartyDetails partyDetails; 
    }
    
    public class IntermediaryList {
    }
    
    public class PartyDetails {
        public String rsaIdNumber;	//6011095116084
        public String passportNumber;	//
        public String countryOfIssueDescription;	//South Africa
        public String birthDate;	//1960-11-09
        public String genderDescription;	//Male
        public postalAddress postalAddress;
        public personName personName;
        public PrefferedEmail prefferedEmail;
        public String title; // MISTER
        public String correspondanceLanguageDesription; //AFRIKAANS
        public WorkPhone workPhone;
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
    
    public class WorkPhone{
        public String internationalCode;
        public String areaCode;
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
    
    public class Searchintermediary{
        public PartyDetails partyDetails;
        public String intermediaryCode;    // 00007218
        public String regionName;          // VERTW:KORP
        public String genderDescription;   // Male
        public String regionCode;  //17519
        public String intermediaryStatusDescription; // OUT OF SERVICE
        public String  intermediaryConsultant;
        public boolean diamondLineAccessIndicator; // false
        public String preferredCommunicationMethodDescription; // Email
        
    }
    
    public class Intermediaryidentificationlist{
        public List<Intermediaryidentificationdetails>  intermediaryList;
    }
    
    public class Intermediaryidentificationdetails{
        public PersonName personName;
        public String intermediaryCode;
        public String regionName;
        public String emailAddress;
    }
    
    public class ClaimMangement{
        public String eventType; //recordMemberPortfolio
        public ClaimContext claimContext;
        public EventContext eventContext;
        public String systemDate;
    }
    
    public class ClaimMangementCoverage{
        public String eventType = 'benefitClaimApproved'; //recordMemberPortfolio
        public String claimEventType; //recordMemberPortfolio
        public ClaimContext claimContext;
        public EventContext eventContext;
        //public  list<PolicyContextCoverage> policyContext;    
    }
    
    
    public class EventContext{
        public String eventId ;  //  0030C00000AxyuzQAB
        public String taskId;    //  0030C00000AdefzQAB
        public String userId;    //  0030C00000Pn7uzPAL
        public String userName;  //  sanlam03082021
    }
    
    public class ClaimContext {
        public String claimNumber;	//C-2022-000086
        public String claimId;	//C-2022-000086
        public String accountId;	//0000A00000Ab8abABC
        public String accountName;	//Jane Doe
        public String sanlamMemberNumber;	//AB123456
        public String recordTypeId;	//0030C00000Pn8asdAB
        public String recordTypeName;	//personRecord
        public String claimEffectiveDate;
        public String claimDocumentId;	//1Q0C000000w55JUAQ
        public String claimDocumentName;	//CD-2022-000049
        public List<PaymentRelease> paymentsRelease;
        public List<BenefitClaimed> benefitClaimed;
    }
    
    public class BenefitClaimed {
        public String policyId;	//a1W3M000000IPFdUAO
        public String policyName;	//040734173X4
        public String benefitId;	//a0M0C000000gTunUAE
        public String benefitClaimedId;	//a0H0C000003szIoUAI
        public String benefitClaimedName;	//BC-2022-000012
        public String benefitCode;	//DS
        public String effectiveDate; // date.today
        public List<Reinsurance> reinsurance;
        public List<CommunicationBenefit> communicationBenefit;
        public List<PaymentSpecification> paymentSpecification;
        public List<Taxdirective> taxDirective;
    }
    
    
    public class ClaimEventResponse{
        public String eventId ;  //  0030C00000AxyuzQAB
        public String eventStatus;    //  0030C00000AdefzQAB
    }    
    
    public class Reinsurance {
        public String reinsuranceId;	//a1m0C000000x8mFQAQ
        public String reinsuranceName;	//R-2022-00029
    }
    
    public class CommunicationBenefit {
        public String claimDocumentId;	//1Q0C000000w55JUAQ
        public String claimDocumentName;	//CD-2022-000049
    }
    
    public class PaymentSpecification {
        public String paymentSpecificationId;	//1Q0C000000w55JUAQ
        public String paymentSpecificationName;	//PS-2022-000053
        public List<Payments> payments;
        public List<Adjustment> paymentAdjustment;
    }
    
    public class PaymentRelease {
        public String paymentsReleaseId;	//string
        public String paymentsReleaseIdName;	//string
    }
    public class Payments{
        public String paymentId;
        public String paymentName;  
    }
    
    public class Taxdirective{
        public String taxDirectiveId;
        public String taxDirectiveName;// "TD-0001"
    }
    public class Adjustment{
        public String paymentAdjustmentId;
        public String paymentAdjustmentName;
    }
    /*public class PolicyContextCoverage {
public String policyId;	//a1W3M000000IPFdUAO
public String policyName;	//040734173X4
public List<BenefitsCoverage> Benefits;
}

public class BenefitsCoverage {
public String benefitId;	//a0M0C000000gTunUAE
public String benefitClaimedId;	//a0H0C000003szIoUAI
public String benefitClaimedNumber;	//BC-2022-000012
public Decimal coverageAmount; //2500.00
}*/
    
    
    @AuraEnabled
    public static void partySearchLog(String corelationID, String requestBodyStr, String clientResponse, String clientNumber){        
        Party_Search_Log__c partySearchObj = new Party_Search_Log__c();
        partySearchObj.Corelation__c = corelationID;
        System.debug('partySearchObj.Corelation__c'+partySearchObj.Corelation__c);
        partySearchObj.Request__c = requestBodyStr;
        System.debug('partySearchObj.Request__c'+ partySearchObj.Request__c);
        partySearchObj.Response__c = clientResponse;
        System.debug('partySearchObj.Response__c'+ partySearchObj.Response__c);
        partySearchObj.Member_Number__c = clientNumber;
        System.debug('partySearchObj.Member_Number__c'+partySearchObj.Member_Number__c);        
        try{
            insert partySearchObj; 
        } catch(Exception ex){
            system.debug('---ex---- '+ ex.getMessage());
        }        
    }   
    
    public static HttpController.ResponseTokenWrapper getToken(){
        HttpController.ResponseTokenWrapper response = new HttpController.ResponseTokenWrapper();
        String token;
        Auth_Lid_Callout__c authLidCallout = Auth_Lid_Callout__c.getOrgDefaults();
        if(DateTime.now() < authLidCallout.Token_expiration__c){
            response.access_token = authLidCallout.Token__c;
        } else {
            response = HttpController.authorizationCallForPartySearch();
        }
        return response;
    }
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
        
        try{
            update authLidCallout;
        } catch(Exception ex){
            system.debug('---ex---- '+ ex.getMessage());
        }         
    }
}