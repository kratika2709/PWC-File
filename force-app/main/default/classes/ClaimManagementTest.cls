@isTest
private class ClaimManagementTest {
    
    @testsetup static void insertRecord(){
        Account accRecord = new Account();
        accRecord = TestDatafactory.Accountrecord();
        insert accRecord;
    }    
    
    private static testMethod void ClaimManagementDetails(){  
        
        List<Account> accList = [Select Id, Name, Member_Number__pc, RecordType.Id, RecordType.Name from Account where Name ='Jordan'];
        String taskId = '0030C00000AdefzQAB';
        String EventId = '0030C00000AxyuzQAB';
        String UserId =  '0030C00000Pn7uzPAL';
        String UserName = 'sanlam03082021';
        
        Test.setMock(HttpCalloutMock.class, new SearchLidControllermock());
        Test.StartTest();
        ClaimManagement.claimManagementDetails(accList, taskId, EventId, UserId, UserName);
        Test.StopTest();
    }
}