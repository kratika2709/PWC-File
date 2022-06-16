@isTest
private class InternalSearchLidControllerTest {
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
    
    private static testMethod void personLidController()
    {
        String jsonData = '{"searchType":"Policy","registration_type":"RSA / Namibian ID number","PolicyNumber":"1235678910"}';
        String radiobutton = 'Person';
        //List<Contact> demoContactData =[Select LastName from Contact Where LastName ='Test' Limit 1];
        List<cve__Policy__c> demoPolicyData = [Select Name from cve__Policy__c Where Name ='Name' Limit 1];
        List<Account> demoAccountData = [Select Name from Account Where Name ='Jordan' Limit 1];
        Test.StartTest();
        InternalSearchLidController.lidController(jsonData,'Account',radiobutton);
        Test.StopTest();
    }
    
    private static testMethod void policyLidController()
    {
        String jsonData = '{"searchType":"Policy","registration_type":"RSA / Namibian ID number","PolicyNumber":"1235678910"}';
        String radiobutton = 'Policy';
        //List<Contact> demoContactData =[Select LastName from Contact Where LastName ='Test' Limit 1];
        List<cve__Policy__c> demoPolicyData = [Select Name from cve__Policy__c Where Name ='Name' Limit 1];
        List<Account> demoAccountData = [Select Name from Account Where Name ='Jordan' Limit 1];
        Test.StartTest();
        InternalSearchLidController.lidController(jsonData,'cve__Policy__c',radiobutton);
        Test.StopTest();
    }
    
     private static testMethod void legalEntityLidController()
    {
        String jsonData = '{"searchType":"Policy","registration_type":"RSA / Namibian ID number","PolicyNumber":"1235678910"}';
        String radiobutton = 'LegalEntity';
        //List<Contact> demoContactData =[Select LastName from Contact Where LastName ='Test' Limit 1];
        List<cve__Policy__c> demoPolicyData = [Select Name from cve__Policy__c Where Name ='Name' Limit 1];
        List<Account> demoAccountData = [Select Name from Account Where Name ='Jordan' Limit 1];
        Test.StartTest();
        InternalSearchLidController.lidController(jsonData,'Account',radiobutton);
        Test.StopTest();
    }
    
}