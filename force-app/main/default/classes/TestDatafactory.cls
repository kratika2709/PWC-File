public class TestDatafactory {
    public static Contact Contactrecord(){
        Contact conData = new Contact();
        conData.FirstName='Test';
        conData.LastName='Test';
        // conData.Name='Harris';
        conData.Birthdate=Date.today()+30;
        conData.Email='xyz@gmail.com';
        conData.Tax_Number__c='36582554522';
        conData.Member_Number__c='Axx5225';
        conData.Intermediary_Code__c='js856';
        conData.Phone='621225522';
        return conData;
    }
    
    public static cve__Product__c Productrecord(){
        cve__Product__c item = new cve__Product__c();
        item.Name ='Furniture';
        item.cve__Status__c ='Active';
        item.cve_Sanlam_Product_ExternalID__c='4583222222';
        item.cve__Effective__c= Date.today()+30;
        return item;
    }
    
    public static cve__Policy__c Policyrecord(id Product2){
        cve__Policy__c policyData = new cve__Policy__c();
        //policyData.id = Product2.i
        policyData.Name='Insurance';
        policyData.cve__Product__c = Product2;
        //policyData.cve__ProductName__c='Speakers';              
        policyData.cve__Version__c='52';
        //policyData.cve__LineOfBusiness__c='xyz';
        policyData.cve__Status__c='Public';
        policyData.cve_Sanlam_ExternalPolicyNumber__c ='123456789';
        policyData.Plan_State__c= ' Await Issue';
        return policyData;
    }
    
    public static Account Accountrecord(){
        
        Account acccData = new Account();
        acccData.Name='Jordan';
        //acccData.PersonBirthdate= Date.today()+30;
        acccData.Registration_Number__c='52154548';
        //acccData.Member_Number__pc='5263322';
        acccData.cve_Sanlam_Intermediary_Code__c='9632255';
        
        return acccData;
    }
    
    public static Party_Search_Log__c partySearchlogRecord(){
        Party_Search_Log__c partySearch = new Party_Search_Log__c();
        partySearch.Name = 'Denmark';
        partySearch.Corelation__c = '005260000080Z3qAAE-2022-02-28 00:00:00';
        return partySearch;
    }
    
    public static PE_Sanlam_Retrieve_Person__e retrievePerson(Boolean isTrue){
        PE_Sanlam_Retrieve_Person__e retrivePer = new PE_Sanlam_Retrieve_Person__e();
        retrivePer.Claim_User_Id__c = UserInfo.getUserId();
        retrivePer.Correlation_Id__c = '005260000080Z3qAAE-2022-02-28 00:00:00';
        retrivePer.Error_List__c = 'NULL POINTER EXCEPTION';
        retrivePer.Error_Message__c = 'NULL POINTER EXCEPTION';
        retrivePer.IsSuccessful__c = isTrue;
        retrivePer.Record_Id__c = '' ;
        return retrivePer;
    }
    public static PE_Sanlam_Retrieve_Policy__e retrievePolicy(Boolean isTrue){
        PE_Sanlam_Retrieve_Policy__e retrivePolci = new PE_Sanlam_Retrieve_Policy__e();
        retrivePolci.Claim_User_Id__c = UserInfo.getUserId();
        retrivePolci.Correlation_Id__c = '005260000080Z3qAAE-2022-02-28 00:00:00';
        retrivePolci.Error_List__c = 'NULL POINTER EXCEPTION';
        retrivePolci.Error_Message__c = 'NULL POINTER EXCEPTION';
        retrivePolci.Is_Successful__c = isTrue;
        retrivePolci.Record_Id__c = '' ;
        return retrivePolci;
    }
    public static PE_Sanlam_Retrieve_Legal_Entity__e retrieveLegalEntity(Boolean isTrue){
        PE_Sanlam_Retrieve_Legal_Entity__e retriveLegalEntity = new PE_Sanlam_Retrieve_Legal_Entity__e();
        retriveLegalEntity.Claim_User_Id__c = UserInfo.getUserId();
        retriveLegalEntity.Correlation_Id__c = '005260000080Z3qAAE-2022-02-28 00:00:00';
        retriveLegalEntity.Error_List__c = 'NULL POINTER EXCEPTION';
        retriveLegalEntity.Error_Message__c = 'NULL POINTER EXCEPTION';
        retriveLegalEntity.Is_Successful__c = isTrue;
        retriveLegalEntity.Record_Id__c = '' ;
        return retriveLegalEntity;
    }
    public static PE_Sanlam_Retrieve_Intermediary__e retrieveIntermediary(Boolean isTrue){
        PE_Sanlam_Retrieve_Intermediary__e retrivePer = new PE_Sanlam_Retrieve_Intermediary__e();
        retrivePer.Claim_User_Id__c = UserInfo.getUserId();
        retrivePer.Correlation_Id__c = '005260000080Z3qAAE-2022-02-28 00:00:00';
        retrivePer.Error_List__c = 'NULL POINTER EXCEPTION';
        retrivePer.Error_Message__c = 'NULL POINTER EXCEPTION';
        retrivePer.Is_Successful__c = isTrue;
        retrivePer.Record_Id__c = '' ;
        return retrivePer;
    }
    public static Callback_Aggregate__e retrieveCallbackAggregate(){
        Callback_Aggregate__e retriveCallBack = new Callback_Aggregate__e();
        retriveCallBack.MUID__c = '0012600001E2BTTAA3';
        retriveCallBack.Record_Id__c = '' ;
        return retriveCallBack;
    }
    public static Callback_Individual__e retrieveCallbackIndividual(){
        Callback_Individual__e retriveCallBack = new Callback_Individual__e();
        retriveCallBack.MUID__c = '0012600001E2BTTAA3';
        return retriveCallBack;
    }
}