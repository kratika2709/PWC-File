import { LightningElement, track, api } from 'lwc';
import fetchCommunicationHistory from '@salesforce/apex/CommunicationHistory.fetchCommunicationHistory';
import NAME_FIELD from '@salesforce/schema/Sanlam_Communication_History__c.Name';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


const columns = [

   // {label: 'Contact History Description', fieldName: 'Name'},
    {label: 'Contact History Description', fieldName: 'NameURL', type: 'url',
    typeAttributes: {
        label: {
            fieldName: 'Name'
        },
        tooltip: { fieldName: 'Name' }
    }},
    { label: 'Message/Contact Details', fieldName: 'Message_Contact_Details__c', type: 'button', 
    typeAttributes: {
        label: 'More', fieldName: 'Message_Contact_Details__c'},
    },
    {label: 'Created Date', fieldName: 'CreatedDate', type: 'date'},
    {label: 'Activity Type', fieldName: 'Activity_Type__c'},
    {label: 'Contact Category', fieldName: 'Contact_Category__c'}, 

    {label:'Contact History Link', fieldName: 'Communication_Link__c', type:'url', typeAttributes: { label: {fieldName:'Communication_ID__c'}, value: {fieldName:'Communication_ID__c'}  }  },


];

export default class ClaimRelatedList extends LightningElement {
    @api recordId;
    @track isModalOpen = false;
    ranger;
    columns = columns;
    communicationRecord;
    error;
    size;
    personName;
    comName;
    activity;
    contact;
    description;
    communicationId;
    content;
    message;
    claimNumber;
    policyNumber;
    benefitClaim;
    memberName;
    openModal = false;
    
    connectedCallback(){
        fetchCommunicationHistory({recordId : this.recordId})
        .then(result =>{
            console.log('2345',result);
            this.communicationRecord = result;
            if(this.communicationRecord){
                this.communicationRecord.forEach(item => item['NameURL'] = '/lightning/r/Sanlam_Communication_History__c/' +item['Id'] +'/view');
                
            }
            this.size = result.length;
           console.log('sdfgh',this.communicationRecord);
        })
        .catch(error =>{
            this.error = error;
        })  
    }
    
    nameChangedHandler(event){
        this.comName= event.target.value;
    }

    activityChangedHandler(event){
        this.activity= event.target.value;
    }

    ccChangedHandler(event){
        this.contact = event.target.value;
    }

    descChangedHandler(event){
        this.description = event.target.value;
    }
    commChangedHandler(event){
        this.communicationId = event.target.value;
    }
    cmChangedHandler(event){
        this.content = event.target.value;
    }
    msgChangedHandler(event){
        this.message = event.target.value;
    }
    claimChangedHandler(event){
        this.claimNumber= event.target.value;
    }
    policyChangedHandler(event){
        this.policyNumber = event.target.value;
    }
    benefitChangedHandler(event){
        this.benefitClaim = event.target.value;
    }
    memberChangedHandler(event){
        this.memberName =  event.target.value;
    }
    personChangedHandler(event){
        console.log('person',event.target.value);
        this.personName = event.target.value;
    }

    createCommunicationHistory(){
       // alert('Good');
       if( !this.comName ){
        this.showToast( 'Error', 'Conatct History Description is required.' );
            return;
       }
        // Creating mapping of fields of Account with values
        var fields = {'Name' : this.comName, 'Activity_Type__c' : this.activity, 'Contact_Category__c' :  this.contact, 
                     'Description__c':this.description, 'Communication_ID__c':this.communicationId, 'Content_Manager_Id__c':this.content,
                    'Message_Contact_Details__c':this.message, 'Claim_Number__c':this.claimNumber,'Policy_Number__c':this.policyNumber,
                    'Benefit_Claimed_Relationship__c':this.benefitClaim, 'Member_Name__c': this.memberName, 'Person__c':  this.personName};
        // Record details to pass to create method with api name of Object.
        var objRecordInput = {'apiName' : 'Sanlam_Communication_History__c', fields};
        // LDS method to create record.
        createRecord(objRecordInput).then(response => {
            //alert('Communication history created with Id: ' +response.id);
            this.showToast( 'Success', 'Record is created successfully!' );
            this.closeRecordModal();
        }).catch(error => {
            this.showToast( 'Error', JSON.stringify(error) );
        });
    }
 
    showToast( msgType, message ) {
        const event = new ShowToastEvent({
            title: msgType,
            message: message,
        });
        this.dispatchEvent(event);
    }
    

    viewRecord(event){

        this.ranger = event.detail.row.Message_Contact_Details__c;
        this.isModalOpen = true;
        console.log(event.detail.row.Message_Contact_Details__c);
    }

    openRecordModal() {
        this.openModal = true;
    }

    closeRecordModal() {
        this.openModal = false;
    }

    closeModal() {
         this.isModalOpen = false;
         }
    submitDetails() {
            this.isModalOpen = false;
        }

    

}