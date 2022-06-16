public with sharing class claimEvent {
    @AuraEnabled
    public static string requestClaimEvent( String recordData , Boolean isTaskTrue , String eventType , Boolean isAccountTrue){
        /* Here in recordData Parameter JSON is needs to pass in this format, 
        recordData = {"firstname"":"Jhon","lastname":Kat","membernumber":"AP20XHY"}';
        */
        List<String> EventTypeNames = new List<String>();
        if(String.isBlank(eventType)){
            EventTypeNames = System.Label.EventTypes.split(',');
        }else{
            EventTypeNames.add( eventType );
        }
        Map<String, Object> accDataMap = (Map<String, Object>)JSON.deserializeUntyped(recordData);
        List<Account> existingAcc = [SELECT Id, Name, cve_Sanlam_Member_ID__c, RecordType.Id, RecordType.Name 
                                     FROM Account 
                                     WHERE cve_Sanlam_Member_ID__c =: String.valueOf(accDataMap.get('membernumber')) LIMIT 1];
        system.debug('existingAcc==='+existingAcc);
        String Taskid = null;
        String eventId1;
        if(existingAcc.size()>0){
            List<Task> taklst = [SELECT Id, whatid FROM Task WHERE whatid =: existingAcc[0].id LIMIT 1];
            Account exiacc = existingAcc[0];
            if (taklst.size()>0){
                Taskid = taklst[0].id;
            }
            else{
                if(exiacc!= null && isTaskTrue == true){
                    Taskid = createTask( exiacc );
                }
            }
            List <Claim_Event_Log__c> existingClaimlog = [Select Id, EventType__c, User__c,Status__c FROM 
                                                          Claim_Event_Log__c 
                                                          WHERE User__c=:existingAcc[0].Id 
                                                          AND EventType__c IN:EventTypeNames Order BY CreatedDate DESC LIMIT 1];
            system.debug('existingClaimlog=='+existingClaimlog);
            if(existingClaimlog.size()>0 && ((existingClaimlog[0].Status__c == 'Accepted') || (existingClaimlog[0].Status__c == 'Not Yet Started'))){
                return 'Show Toast';
            }
            else if(exiacc != null){
                eventId1 = createClaimEvent( exiacc.id ,Taskid ); 
            }
            
            callClaimEventType(JSON.serialize(exiacc), Taskid, eventId1, UserInfo.getUserId(), UserInfo.getUserName()); 
            return 'Already Exists';
        }
        else{
            if (isAccountTrue == true){
            createAccount(recordData , isTaskTrue);
            }
            return 'Success';
        }
    }
    
    // Here the passing parameter is account id accepted by first method.
    public static String createTask( Account Parent ){
        
        if(String.isNotBlank(Parent.Id)){
            Task tsk = new Task();
            tsk.Status = 'Not Started';
            tsk.Subject = 'Ready to register claim';
            tsk.WhatId = Parent.Id;
            tsk.CurrencyIsoCode = '';
            tsk.Priority = 'Normal';
            tsk.Integration_Status__c = 'In Progress';
            insert tsk;
            system.debug('tsk==='+tsk);
            return tsk.id;
        }else{
            return null;
        }
        
    }
    
    public static string createClaimEvent( String accid,String taskid ){
        Claim_Event_Log__c eve = new Claim_Event_Log__c();
        eve.Status__c = 'Not Yet Started';
        eve.User__c = accid;
        insert eve;
        
        if(String.isNotBlank(taskid)){
            Task updateTask = new Task();
            updateTask.Id = taskid;
            updateTask.Event_Id__c = eve.Id;
            update updateTask;
        }
        system.debug('eve==='+eve);
        return eve.id;
    }
    @future(callout=true)
    public static void callClaimEventType(String acc, String taskId, String eventId, String userid, String username)
    {   
        if (acc != null && acc != ''){
            Account acc1 = (Account)JSON.deserialize(acc,Account.class);
            ClaimEventType.createMemberPortfolio( acc1, taskId, eventId, UserInfo.getUserId(), UserInfo.getName());
        }
    }
    public static void createAccount(String recordData , Boolean isTaskTrue){
        Map<String,Object> accDataMap = (Map<String,Object>)JSON.deserializeUntyped(recordData);
        String taskId = '';
        String eventId = '';
        RecordType AccountRecordTyep = [SELECT Id, Name FROM RecordType WHERE RecordType.DeveloperName = 'PersonAccount' LIMIT 1];
        Account acc = new Account();
        acc.RecordTypeId = AccountRecordTyep.Id;
        acc.Salutation = String.valueOf((accDataMap.containsKey('salutation') ? accDataMap.get('salutation') : ''));
        acc.FirstName = String.valueOf((accDataMap.containsKey('firstname') ? accDataMap.get('firstname') : ''));
        acc.LastName = String.valueOf((accDataMap.containsKey('lastname') ? accDataMap.get('lastname') : ''));
        acc.cve_Sanlam_Member_ID__c = String.valueOf((accDataMap.containsKey('membernumber') ? accDataMap.get('membernumber') : ''));
        try{
            if(acc.cve_Sanlam_Member_ID__c != null && acc.cve_Sanlam_Member_ID__c != ''){
                insert acc;
                system.debug('acc===='+acc);
                if( acc != null && isTaskTrue == true){
                    taskId = createTask( acc );
                }
            }if(acc != null){
                eventId = createClaimEvent( acc.id ,taskId);
            }
            List<Account> newAccount = [SELECT Id, Name, cve_Sanlam_Member_ID__c, RecordType.Id, RecordType.Name FROM Account WHERE Id=:acc.Id LIMIT 1]; 
            callClaimEventType(JSON.serialize(newAccount[0]), taskId, eventId, UserInfo.getUserId(), UserInfo.getName());
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
            
        }
    }
    
}