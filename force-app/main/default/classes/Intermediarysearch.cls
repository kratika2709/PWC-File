public with sharing class Intermediarysearch {

    @AuraEnabled public static  String intermediarytable() {

        List<Mainwrapper.Intermediaryidentificationdetails> intermediaryListAll = new List<Mainwrapper.Intermediaryidentificationdetails>(); 

        Mainwrapper.PersonName personNameObj = new Mainwrapper.PersonName();
        personNameObj.firstName ='Gert';
        personNameObj.surname ='De Kock';

        Mainwrapper.Intermediaryidentificationdetails  intermediaryObj = new  Mainwrapper.Intermediaryidentificationdetails();
        intermediaryObj.intermediaryCode ='00007218';
        intermediaryObj.regionName='VERTW:KORP';
        intermediaryObj.emailAddress='gjstone@intercom.co.za';
        //intermediaryObj.intermediaryCode ='00007218';
        intermediaryObj.personName = personNameObj;
        intermediaryListAll.add(intermediaryObj);
        system.debug('check---->'+intermediaryListAll);

        Mainwrapper.Intermediaryidentificationlist intermediary = new  Mainwrapper.Intermediaryidentificationlist();
        intermediary.intermediaryList = intermediaryListAll;
        system.debug('intermediaryList---->'+ intermediary.intermediaryList);
 
        return JSON.serialize(intermediary);
    }

  /*@AuraEnabled public static list<Mainwrapper.Intermediaryidentificationdetails> internalIntermediarySearch() {
   List<Mainwrapper.Intermediaryidentificationdetails> interList = new  List<Mainwrapper.Intermediaryidentificationdetails> ();

   List<Account> accList = [Select Intermediary_Code__pc, Region_Name__pc, PersonEmail,(Select 	cve__FirstNameCopy__c, cve__LastNameCopy__c  from contacts) from Account];
   system.debug('acclist---'+acclist);
   if(!accList.isEmpty()){
   for(Account acc : accList){
      for(contact con : acc.Contacts  ){
       system.debug('account----'+acc);
    Mainwrapper.Intermediaryidentificationdetails intermediaryObj = new Mainwrapper.Intermediaryidentificationdetails();
    intermediaryObj.intermediaryCode = acc.Intermediary_Code__pc;
    intermediaryObj.regionName = acc.Region_Name__pc;
    intermediaryObj.emailAddress = acc.PersonEmail;
    intermediaryObj.personName.firstName = con.cve__FirstNameCopy__c;
    intermediaryObj.personName.surname = con.cve__LastNameCopy__c;
    interList.add(intermediaryObj);
   }
}
}
   system.debug('inter---'+interList);
   return interList;
  }*/


}