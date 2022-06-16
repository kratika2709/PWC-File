public class InternalSearchLidController {
    
    public static Map<String, String> staticMappingMap = new Map<String, String>{'name' => 'FirstName', 
        'surname'=> 'LastName',
        'Name'=> 'Name',
        'birth_date'=> 'PersonBirthdate',
        'email_address'=> 'PersonEmail',
        'phone_details'=> 'Phone',
        'PolicyNumber'=>'Name',
        'organisation_name'=>'Name',
        'registration_number'=> 'Registration_Number__c',
        'member_number'=>'Member_Number__pc',
        'IntermediaryNumber'=>'Intermediary_Code__pc'}; 
            
            @AuraEnabled
            public static List<Sobject> lidController(string jsonString, String obejctApiName, String radioval){
                System.debug('radiooooo-->'+radioval);
                System.debug('jsonString---->'+jsonString);
                Map<String, String> obj = (Map<String, String>) JSON.deserialize(jsonString, Map<String, String>.class);
                system.debug(obj);
                String queryConditionString = ' WHERE ';
                for(String mapKey : staticMappingMap.keySet()){
                    system.debug('Map Value--->'+obj.get(mapKey)+'-------->'+mapKey);
                    if(staticMappingMap.containsKey(mapKey) && !string.isEmpty(obj.get(mapKey))){
                        if(mapKey == 'name' || mapKey == 'surname' || mapKey == 'email_address' || mapKey == 'phone_details' || mapKey == 'PolicyNumber' || mapKey == 'organisation_name' || mapKey =='registration_number' || mapKey =='member_number' || mapKey =='IntermediaryNumber'){
                            queryConditionString += staticMappingMap.get(mapKey) + ' = \''+obj.get(mapKey)+'\'' + ' AND ';
                            system.debug(queryConditionString);
                        } else {
                            queryConditionString += staticMappingMap.get(mapKey) + ' = ' +obj.get(mapKey) + ' AND ';
                            system.debug(queryConditionString);
                        }
                        
                    }
                }
                String fieldName = '';
                if( (radioval == 'Person' || radioval == 'LegalEntity' || radioval =='Intermediary') && obejctApiName == 'Account'){
                    fieldName = 'Name, PersonBirthdate, Registration_Number__c, Member_Number__pc, cve_Sanlam_Intermediary_Code__c, Phone, Region_Name__pc, PersonEmail, Tax_Number__c ';
                }else if(  radioval=='Policy' && obejctApiName == 'cve__Policy__c'){
                    fieldName = ' Name , cve__ProductName__c , cve__Version__c , cve__LineOfBusiness__c , cve__Status__c , Plan_State__c ';
                }
                String queryString  = ' Select ';
                queryString += fieldName + ' from '+obejctApiName;
                System.debug('---1---'+queryString);
                System.debug('---2---'+fieldName);
                if(queryConditionString != ' WHERE '){
                    queryString += queryConditionString;
                    if(queryString.endsWith(' AND ')){
                        queryString = queryString.removeEnd(' AND ');
                    }
                    String personRecordType = 'Person Account';
                    String businessRecordType = 'Business Record Type';
                    if(radioval == 'Person' || radioval == 'Intermediary'){
                        queryString += ' AND recordtype.name =: personRecordType';
                    } else if(radioval == 'LegalEntity'){
                        queryString += ' AND recordtype.name =: businessRecordType';
                    }
                    system.debug(queryString);
                    List<Sobject> objects = Database.query(queryString);
                    System.debug(objects);
                    return objects ;
                } else {
                    return null;
                }
            }
    
    
}