@isTest
private class SearchLidControllerTest {
    @testSetup static void insertAccountContactRecord()
    {
        Contact insertContact = TestDatafactory.Contactrecord();
        insert insertContact;
        cve__Product__c insertProduct = TestDatafactory.Productrecord();
        insert insertProduct;
        cve__Policy__c insertPolicy = TestDatafactory.Policyrecord(insertProduct.id );
        insert insertPolicy;
        Account insertAccount = TestDatafactory.Accountrecord();
        insert insertAccount;
    } 
    
   	private static testMethod void checkRecord()
    {
        String jsonData = '{"searchType":"Policy","registration_type":"RSA / Namibian ID number","PolicyNumber":"1235678910"}';
        List<Contact> demoContactData =[Select LastName from Contact Where LastName ='Test' Limit 1];
        List<cve__Policy__c> demoPolicyData = [Select Name from cve__Policy__c Where Name ='Name' Limit 1];
        List<Account> demoAccountData = [Select Name from Account Where Name ='Jordan' Limit 1];
        Test.StartTest();
        SearchLidController.lidController(jsonData,'Contact');
        Test.StopTest();
    }
    
    private static testMethod void registration(){
        String Jsoninfo ='{"searchType":"LegalEntity","registration_type":"RSA / Namibian ID number","organisation_name":"NedBank","registration_number":"","member_number":""}';
        String rvalue ='LegalEntity';
        
        Auth_Lid_Callout__c setting = new Auth_Lid_Callout__c();
        setting.Name = 'Auth_Lid_Callout__c';
        setting.Application__c = 'Whatever';
        setting.Client_Id__c = '&client_id=l7abfce95939b3476390bc58de3d62d59f';
        setting.Client_Secret__c = '&client_secret=ce98d2042b974a7b89d205adb4b52d94';
        setting.Content_Type__c = 'Content-Type';
        setting.Method__c = 'POST';
        setting.Endpoint__c = 'https://api-tst.sanlam.co.za/auth/oauth/v2/token';
        setting.Grant_Type__c = 'grant_type=password';  
        setting.Password__c = '&password=ClaimVant@g3-tst';
        setting.Refresh_Token__c = '6c11a20b-5d73-4a2f-b420-c1d3ac4c90e7';
        setting.Refresh_Token_Expiration__c = date.newInstance(2022, 02, 24);
        setting.Token_expiration__c = date.today();
        setting.User_Name__c = '&username=svcTstSpfClmVantage';
        insert setting;

        Test.setMock(HttpCalloutMock.class, new SearchLidControllermock());
        Test.StartTest();
        SearchLidController.serchPartyByRegistrationNumber(Jsoninfo, rvalue);
        Test.StopTest();
    }
    
    private static testMethod void Controller(){
        
    }
    
    private static testMethod void Policyplan(){
        string planNum ='0406345785';
        
        Auth_Lid_Callout__c setting = new Auth_Lid_Callout__c();
        setting.Name = 'Auth_Lid_Callout__c';
        setting.Application__c = 'Whatever';
        setting.Client_Id__c = '&client_id=l7abfce95939b3476390bc58de3d62d59f';
        setting.Client_Secret__c = '&client_secret=ce98d2042b974a7b89d205adb4b52d94';
        setting.Content_Type__c = 'Content-Type';
        setting.Method__c = 'POST';
        setting.Endpoint__c = 'https://api-tst.sanlam.co.za/auth/oauth/v2/token';
        setting.Grant_Type__c = 'grant_type=password';  
        setting.Password__c = '&password=ClaimVant@g3-tst';
        setting.Refresh_Token__c = '6c11a20b-5d73-4a2f-b420-c1d3ac4c90e7';
        setting.Refresh_Token_Expiration__c = date.newInstance(2022, 02, 24);
        setting.Token_expiration__c = date.today();
        setting.User_Name__c = '&username=svcTstSpfClmVantage';
        insert setting;
        
        Test.setMock(HttpCalloutMock.class, new SearchLidControllermock());
        Test.StartTest();
        SearchLidController.serchPolicyByPlanNumber(planNum);
        Test.StopTest();
    }
}