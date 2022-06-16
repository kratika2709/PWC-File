@isTest
private class IntermediarysearchTest {
    @testSetup static void insertRecord(){
        Mainwrapper.PersonName personNameObj = new Mainwrapper.PersonName();
        personNameObj.firstName ='Gert';
        personNameObj.surname ='De Kock';
        //insert personNameObj;
        Mainwrapper.Intermediaryidentificationdetails  intermediaryObj = new  Mainwrapper.Intermediaryidentificationdetails();
        intermediaryObj.emailAddress = 'gjstone@intercom.co.za';
        intermediaryObj.intermediaryCode = '00007218';
        intermediaryObj.regionName = 'VERTW:KORP';
        
        intermediaryObj.personName = personNameObj;
        List<Mainwrapper.Intermediaryidentificationdetails> intermediaryListAll = new List<Mainwrapper.Intermediaryidentificationdetails>(); 
        intermediaryListAll.add(intermediaryObj);
        
        Mainwrapper.Intermediaryidentificationlist intermediary = new  Mainwrapper.Intermediaryidentificationlist();
        intermediary.intermediaryList = intermediaryListAll;
        
    }
    private static testMethod void intermediaryCheck(){
        Test.startTest();
        Intermediarysearch.intermediarytable();
        Test.stopTest();
    }
    
}