public with sharing class PartySearchPlatformController {
    public static Map<String, PE_Sanlam_Retrieve_Person__e> mapRetrieve = new Map<String,PE_Sanlam_Retrieve_Person__e>();
    
    public static void personSearch(List<PE_Sanlam_Retrieve_Person__e> newPersonList){
        for(PE_Sanlam_Retrieve_Person__e newPerson : newPersonList){
            system.debug('newPerson--->'+newPerson);
            String body;
            String title;
            if(String.isNotEmpty(newPerson.Correlation_Id__c)){
                mapRetrieve.put(newPerson.Correlation_Id__c, newPerson);
            }
            system.debug('mapRetrieve--->'+ mapRetrieve);
            if(newPerson.IsSuccessful__c == true){
                body = 'Record successfully created';
                title = 'Success !!';
            } else {
                body = newPerson.Error_Message__c;
                title = 'Failure';
            }
            sendCustomNotification(newPerson.Claim_User_Id__c, newPerson.Record_Id__c, body, title);
            //partySearch();
        }
    }
    
    public static void policySearch(List<PE_Sanlam_Retrieve_Policy__e> newPolicyList){
        for(PE_Sanlam_Retrieve_Policy__e newPerson : newPolicyList){
            String body;
            String title;
            if(newPerson.Is_Successful__c){
                body = 'Record successfully created';
                title = 'Success !!';
            } else {
                body = newPerson.Error_Message__c;
                title = 'Failure';
            }
            sendCustomNotification(newPerson.Claim_User_Id__c, newPerson.Record_Id__c, body, title);
            //partySearch();
        }
    }
    
    public static void organisationSearch(List<PE_Sanlam_Retrieve_Legal_Entity__e> newOrganisationList){
        for(PE_Sanlam_Retrieve_Legal_Entity__e newPerson : newOrganisationList){
            String body;
            String title;
            if(newPerson.Is_Successful__c){
                body = 'Record successfully created';
                title = 'Success !!';
            } else {
                body = newPerson.Error_Message__c;
                title = 'Failure';
            }
            sendCustomNotification(newPerson.Claim_User_Id__c, newPerson.Record_Id__c, body, title);
            //partySearch();
        }
    }
    
    public static void intermediarySearch(List<PE_Sanlam_Retrieve_Intermediary__e> newIntermediaryList){
        for(PE_Sanlam_Retrieve_Intermediary__e newPerson : newIntermediaryList){
            String body;
            String title;
            if(newPerson.Is_Successful__c){
                body = 'Record successfully created';
                title = 'Success !!';
            } else {
                body = newPerson.Error_Message__c;
                title = 'Failure';
            }
            sendCustomNotification(newPerson.Claim_User_Id__c, newPerson.Record_Id__c, body, title);
            //partySearch();
        }
    }
    
    public static void sendCustomNotification(String userId, String recordId, String body, String title){
        set<String> notifiedIds = new set<String>();
        List<User> user = [Select Id from User Where IsActive = true];
        for(User u : user){
            notifiedIds.add(u.Id);
        }
        String s ='{type: "standard__app",attributes: {appTarget: "standard__Sales"}}';
        Id typeId = [SELECT Id FROM CUstomNotificationType WHERE MasterLabel = 'Platform Event'].Id;
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setBody(body);//('This is body of the custom notification!');
        notification.setTitle(title);//('Hi this is first notification sent using apex!');
        notification.setSenderId(Userinfo.getUserId());
        notification.setNotificationTypeId(typeId);
        if(!String.isEmpty(recordId)){
            notification.setTargetId(recordId);//('0012600001E2BTTAA3'); // target object id
        } else {
            notification.setTargetPageRef(s);
        }
        if(!String.isEmpty(recordId)){
            notification.send(new Set<String>{userId});
        } else {
            notification.send(notifiedIds);
        }
    }
    /*public static void partySearch(){
system.debug('map-->'+mapRetrieve.keySet());
if(mapRetrieve.keySet() != NULL){
System.debug('---1---0');
List<Party_Search_Log__c> partySearchData =[SELECT 	Corelation__c, PE_Status__c, PlatformEventDetail__c, Error__c from Party_Search_Log__c where Corelation__c IN : mapRetrieve.keySet()];
System.Debug('partySearchData----->'+ partySearchData);
List<Party_Search_Log__c> partySearchList = new List<Party_Search_Log__c>();
for(Party_Search_Log__c searchLog : partySearchData){
system.debug('searchLog'+searchLog);
if(mapRetrieve.containsKey(searchLog.Corelation__c) && mapRetrieve.get(searchLog.Corelation__c).IsSuccessfull__c){
searchLog.PE_Status__c ='Successfull';
} else{
searchLog.PE_Status__c ='Failure';
}
searchLog.PlatformEventDetail__c = mapRetrieve.get(searchLog.Corelation__c).Id;
system.debug('searchLog.PlatformEventDetail__c-->'+searchLog.PlatformEventDetail__c);
searchLog.Error__c = mapRetrieve.get(searchLog.Corelation__c).Error_List__c;
system.debug('Error__c--->'+ searchLog.Error__c);
partySearchList.add(searchLog);
System.debug('searchLog'+searchLog);
}
if(!partySearchList.isEmpty()){
update(partySearchList);
}
}
}*/
    
}