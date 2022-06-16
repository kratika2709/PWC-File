@IsTest
public with sharing class CommunicationHistoryTest {
    @testSetup static void communicationHistory()
    {
        Account contactRecord = new Account();
         contactRecord.LastName = 'Test';
         Insert contactRecord;
    }
    testMethod static void testCommunicationHistory()
    {
    List<Account> listAccountRecord = [SELECT Id FROM Account WHERE LastName = 'TEST' LIMIT 1];    
    test.startTest();
    CommunicationHistory.fetchCommunicationHistory(listAccountRecord[0].Id);
    system.assertEquals(listAccountRecord!=null,True );
    test.stopTest();    
    }
}