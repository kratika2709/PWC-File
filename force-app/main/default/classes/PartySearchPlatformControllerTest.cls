@isTest
public class PartySearchPlatformControllerTest {
    
    private static testMethod void testPerson(){
        PE_Sanlam_Retrieve_Person__e insertPerson = TestDatafactory.retrievePerson(true);
        Test.StartTest();
        Database.SaveResult sr = EventBus.publish(insertPerson);
        Test.StopTest();
    }
    
    private static testMethod void testIntermediary(){
        PE_Sanlam_Retrieve_Intermediary__e insertPerson = TestDatafactory.retrieveIntermediary(true);
        Test.StartTest();
        Database.SaveResult sr = EventBus.publish(insertPerson);
        Test.StopTest();
    }
    
    private static testMethod void testLegalEntity(){
        PE_Sanlam_Retrieve_Legal_Entity__e insertPerson = TestDatafactory.retrieveLegalEntity(true);
        Test.StartTest();
        Database.SaveResult sr = EventBus.publish(insertPerson);
        Test.StopTest();
    }
    
    private static testMethod void testPolicy(){
        PE_Sanlam_Retrieve_Policy__e insertPerson = TestDatafactory.retrievePolicy(true);
        Test.StartTest();
        Database.SaveResult sr = EventBus.publish(insertPerson);
        Test.StopTest();
    }
    
    private static testMethod void testPersonFail(){
        PE_Sanlam_Retrieve_Person__e insertPerson = TestDatafactory.retrievePerson(false);
        Test.StartTest();
        Database.SaveResult sr = EventBus.publish(insertPerson);
        Test.StopTest();
    }
    
    private static testMethod void testIntermediaryFail(){
        PE_Sanlam_Retrieve_Intermediary__e insertPerson = TestDatafactory.retrieveIntermediary(false);
        Test.StartTest();
        Database.SaveResult sr = EventBus.publish(insertPerson);
        Test.StopTest();
    }
    
    private static testMethod void testLegalEntityFail(){
        PE_Sanlam_Retrieve_Legal_Entity__e insertPerson = TestDatafactory.retrieveLegalEntity(false);
        Test.StartTest();
        Database.SaveResult sr = EventBus.publish(insertPerson);
        Test.StopTest();
    }
    
    private static testMethod void testPolicyFail(){
        PE_Sanlam_Retrieve_Policy__e insertPerson = TestDatafactory.retrievePolicy(false);
        Test.StartTest();
        Database.SaveResult sr = EventBus.publish(insertPerson);
        Test.StopTest();
    }

}