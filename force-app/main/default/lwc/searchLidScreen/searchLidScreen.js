import { LightningElement, track, api } from 'lwc';

import lidController from '@salesforce/apex/InternalSearchLidController.lidController';
import serchPartyByRegistrationNumber from '@salesforce/apex/SearchByRegistrationNumber.serchPartyByRegistrationNumber';
import tableController from '@salesforce/apex/RetrievePartycontroller.tableController';
import serchPolicyByPlanNumber from '@salesforce/apex/SearchPlanNumber.serchPolicyByPlanNumber';
import intermediarytable from '@salesforce/apex/Intermediarysearch.intermediarytable';
import CreateMemberPortfolioMethod from '@salesforce/apex/claimEvent.requestClaimEvent';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import USER_ID from '@salesforce/user/Id';

const columnsPlan = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Product Name', fieldName: 'cve__ProductName__c'  },
    { label: 'Version', fieldName: 'cve__Version__c'},
    { label: 'Line Of buisness', fieldName: 'cve__LineOfBusiness__c'},
    { label: 'Status', fieldName: 'cve__Status__c' },
    { label: 'Plan Status', fieldName: 'Plan_State__c' },
];

const columnsOrg = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Birthdate', fieldName: 'PersonBirthdate'  },
    { label: 'Registration Number', fieldName: 'Registration_Number__c'},
    { label: 'Member Number', fieldName: 'cve_Sanlam_Member_ID__c'},
    { label: 'Jockey Code', fieldName: 'cve_Sanlam_Intermediary_Code__c' },
    { label: 'Tele Phone', fieldName: 'Phone' },
    { label: 'Email', fieldName: 'PersonEmail' },
    { label: 'Tax Number', fieldName: 'Tax_Number__c' },
];
    
export default class SearchLidScreen extends LightningElement {
    data = [];
    columns;
    isLoaded = false;
    obejctApiName;
    value = '';
    radioVal;
    showRequriedFirstName = false;
    showRequriedLastName = false;
    isIntermidiary = false;
    isLegalEntity = false;
    isPolicy = false;
    isIndividual = false;
    firstLast = false;
    showTable = false;
    regisType = 'RSA / Namibian ID number';
    showCustom = false;
    apiResult;
    firstName;
    LastName;
    regisNumber;
    selectedData = [];
    RegistrationNumbervalue;
    MemberNumbervalue ;
    clientNumber;
    pattern = true;
    registrationNumber;
    clientnumberValue;
    plannumberValue;
    clientResult;
    showPlantable = false;
    searchType;
    showLegalEntity = false;
    showIntermediary = false;
    showInternalIntermediaryTable = false;
    isLoaded = false;
    accData;
    isTaskCreated = true;
    claimEventType;
    isAccountCreated = true;


    get optionsPerson() {
        return [
            { label: 'Individual', value: 'Individual' },
        ];
    }

    get optionsPersonRecordOnly() {
        return [
            { label: 'Company/Trust', value: 'Company/Trust' },
        ];
    }

    get optionsSurname() {
        return [
            { label: 'Intermediary', value: 'Intermediary' },
        ];
    }

    get optionsCompany() {
        return [
            { label: 'Account & Policies', value: 'Account & Policies' },
        ];
    }

    handleTypeChange(event){
        this.regisType = event.target.value;
        console.log('Type---', this.regisType);
        if (this.regisType === 'RSA / Namibian ID number') {
            this.pattern = true;
        } else {
            this.pattern = false;
        }
    }

    handleChange(event) {
        this.isIndividual = false;
        this.isIntermidiary = false;
        this.isLegalEntity = false;
        this.isPolicy = false;
        this.firstLast = false;
        this.makeInputBlank();
        this.showCustom = false;
        this.showTable = false;
        this.showLegalEntity = false;
        this.showPlantable = false;
        this.showIntermediary = false;  //-------
        this.apiResult = undefined;
        this.radioVal = event.target.value;
        if (this.radioVal == 'Person') {
            this.isIndividual = true;
            this.firstLast = true;
            this.obejctApiName = 'Account';
            this.columns = columnsOrg;
        }
        if (this.radioVal == 'Intermediary') {
            this.isIntermidiary = true;
            this.firstLast = true;
            this.obejctApiName = 'Account';
            this.columns = columnsOrg;
        }
        if (this.radioVal == 'LegalEntity') {
            this.isLegalEntity = true;
            this.obejctApiName = 'Account';
            this.columns = columnsOrg;
        }
        if (this.radioVal == 'Policy') {
            this.isPolicy = true;
            this.obejctApiName = 'cve__Policy__c';
            this.columns = columnsPlan;
        }
        
        console.log(event.target.value);
    }

    makeInputBlank() {
        this.template.querySelectorAll('lightning-input').forEach(ele => {
            ele.value = null;
        });
    }

    get options() {
        return [
            { label: 'RSA/Namibian Id ', value: 'RSA / Namibian ID number' },
            { label: 'Foreign ID', value: 'Foreign ID' },
            { label: 'Passport Number', value: 'Passport Number' },
            { label: 'Tax Number', value: 'Tax Number' },
        
        ];
    }

    handleSearchtype(event) {
        this.searchType = event.target.checked;
        console.log('handleSearchtype---->',this.searchType);
    }

    handleChangepickList(event) {
        this.value = event.detail.value;
    }

    handleChangepickList(event) {
        this.value = event.detail.value;
    }

    handleClick() {
        console.log('Clicked');
        var last;
        var first
        if(this.radioVal === 'Person' || this.radioVal === 'Intermediary'){
            let firstNameCmp = this.template.querySelector(".firstNameCmp");
            let LastNameCmp = this.template.querySelector(".lastNameCmp");
            let firstNamevalue =  firstNameCmp.value;
            let LastNameValue = LastNameCmp.value;
            if (!firstNamevalue &&  LastNameValue) {
                firstNameCmp.setCustomValidity("firstName value is required");
    
            } else {
                firstNameCmp.setCustomValidity("");
    
            }
            if ( firstNameCmp.reportValidity() == false) {
                this.showRequriedFirstName = true;
            } else {
                this.showRequriedFirstName = false;
            }
            first = firstNameCmp.reportValidity();
    
            if (!LastNameValue && firstNamevalue) {
                LastNameCmp.setCustomValidity("LastName value is required");
            } else {
                LastNameCmp.setCustomValidity("");
            }
            if (LastNameCmp.reportValidity() == false) {
                this.showRequriedLastName = true;
            } else {
                this.showRequriedLastName = false;
            }
            last = LastNameCmp.reportValidity();
        }
        console.log('First' +last);
        console.log('Last' +first);
        var paramObject = new Object();
        if ((first && last ) || this.radioVal == 'Policy' || this.radioVal == 'LegalEntity'){
          
            paramObject['searchType'] = this.radioVal;
            paramObject['registration_type'] = '02';
            this.template.querySelectorAll('lightning-input').forEach(ele => {
                console.log('first name----', ele.dataset.name);
                if (ele.dataset.name) {
                    paramObject[ele.dataset.name] = ele.value;
                }
                if(ele.dataset.name === 'registration_number' && ele.value){
                    this.regisNumber = ele.value;
                }
                if(ele.dataset.name === 'name' && ele.value){
                    this.firstName = ele.value;
                }
                if(ele.dataset.name === 'surname' && ele.value){
                    this.lastName = ele.value;
                }
                
            });
            console.log('Object for Apex-----', paramObject);
            if (this.searchType) {
                console.log('111111');
                this.isLoaded = true;
                if (this.radioVal == 'Policy') {
                    var planNumber = paramObject.PolicyNumber;
                    this.handlePolicyNumber(planNumber);
                } else if (this.radioVal === 'Intermediary') { 
                    this.handleIntermediary();
                } else {
                    this.serchRegistrationNumber(JSON.stringify(paramObject));
                }
            } else {
                console.log('222222');
                this.handleLoad(JSON.stringify(paramObject),this.radioVal);
            }
        }
    }

    handlePolicyNumber(planNumber) {
        serchPolicyByPlanNumber({planNumber : planNumber})
        .then(result => {
            console.log('aaaaaa' + result);
            if (JSON.parse(result).length) {
                this.apiResult = JSON.parse(result);
                console.log('Plan Number Response---', this.apiResult);
                this.handleSuccess('Success', 'Search Externally', 'success');
                this.showPlantable = true;
                this.showTable = false;
                this.showLegalEntity = false;
                this.showCustom = false;
            } else {
                this.handleSuccess('', 'No result found Externally', 'warning');
                this.showPlantable = false;
                this.showTable = false;
                this.showLegalEntity = false;
                this.showCustom = false;
            }
            this.isLoaded = false;
        })
        .catch(error => {
            console.log(error);
            this.handleSuccess('error', error.body.message, 'error');
            this.isLoaded = false;
        });
    }



    handleIntermediary(){
            console.log('---2---');
        intermediarytable()
        .then(result => {
            console.log('IntermediaryList--->',result);
            if (JSON.parse(result).intermediaryList.length) {
                this.apiResult = JSON.parse(result);
                console.log('Plan Number Response---', this.apiResult);
                this.handleSuccess('Success', 'Search Externally', 'success');
                this.showPlantable = false;
                this.showTable = false;
                this.showLegalEntity = false;
                this.showCustom = false;
                this.showIntermediary = true;
            } 
            else {
                this.handleSuccess('', 'No result found Externally', 'warning');
                this.showPlantable = false;
                this.showTable = false;
                this.showLegalEntity = false;
                this.showCustom = false;
                this.isLoaded = false;
            }
            this.isLoaded = false;
        })
        .catch(error => {
            console.log(error);
            this.handleSuccess('error', error.body.message, 'error');
        
        });

    }

    valdationchange() {
        let RegistrationNumberCmp = this.template.querySelector(".RegistrationNumberCmp");
        let MemberNumberCmp = this.template.querySelector(".MemberNumberCmp");
        this.RegistrationNumbervalue = RegistrationNumberCmp.value;
        this.MemberNumberValue =  MemberNumberCmp.value;
         if(this.RegistrationNumbervalue.length > 0){
            MemberNumberCmp.disabled = true
         }else if(this.MemberNumberValue.length > 0){
            RegistrationNumberCmp.disabled = true
         }else{
            RegistrationNumberCmp.disabled = false
            MemberNumberCmp.disabled = false
         }
    }

    valdationchangecheck() {
        let registrationnumber = this.template.querySelector(".registrationnumberCmp");
        let clientnumberCmp = this.template.querySelector(".clientnumberCmp");
        let plannumberCmp = this.template.querySelector(".plannumberCmp");
        this.registrationNumber = registrationnumber.value;
        this.clientnumberValue = clientnumberCmp.value;
        this.plannumberValue = plannumberCmp.value;
        if(this.registrationNumber.length > 0){
            clientnumberCmp.disabled = true
            plannumberCmp.disabled = true
         }else if(this.clientnumberValue.length > 0){
            registrationnumber.disabled = true
            plannumberCmp.disabled = true
         }else if(this.plannumberValue.length > 0){
            registrationnumber.disabled = true
            clientnumberCmp.disabled = true
         }else{
            registrationnumber.disabled = false
            clientnumberCmp.disabled = false
            plannumberCmp.disabled = false
         } 
    }

    handleLoad(jsonString, radioval) {
        this.isLoaded = true;
        console.log('radioVal--->',radioval);
        lidController({ jsonString: jsonString, obejctApiName:this.obejctApiName, radioval:radioval})  
            .then(result => {
                console.log(result);
                if(result && result.length){
                    this.data = result;
                    this.showTable = true;
                    this.showCustom = false;
                    this.showPlantable = false;
                    this.showLegalEntity = false;
                    this.handleSuccess('Success', 'Search Internally', 'success');
                    this.isLoaded = false;
                } else if (this.radioVal === 'Policy') {
                    this.handleSuccess('', 'No result found Internally', 'warning');
                    var planNumber = JSON.parse(jsonString).PolicyNumber;
                    this.handlePolicyNumber(planNumber);
                } else if(this.radioval === 'Intermediary'){
                    this.handleSuccess('', 'No result found Internally', 'warning');
                    console.log('---1---');
                    this.handleIntermediary();
                 } else {
                    this.handleSuccess('', 'No result found Internally', 'warning');
                    this.serchRegistrationNumber(jsonString);
                }
            })
            .catch(error => {
                console.log(error);
                this.handleSuccess('error', error.body.message, 'error');
                this.isLoaded = false;
            });
    }

    handleSuccess(title, message, variant) {
        const showSuccess = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissible'
        });
        this.dispatchEvent(showSuccess);
    }
    
    serchRegistrationNumber(jsonString) {
        serchPartyByRegistrationNumber({jsonString : jsonString, radioVal : this.radioVal})
            .then(result => {
                console.log('aaaaaa' + result);
                if (result) {
                    this.apiResult = JSON.parse(result);

                    if (this.radioVal === 'Person' && this.apiResult && this.apiResult.ClientIdentifications && this.apiResult.ClientIdentifications.length) {
                        this.handleSuccess('Success', 'Search Externally', 'success');
                        this.showCustom = true;
                        this.showTable = false;
                        this.showPlantable = false;
                        this.showLegalEntity = false;
                    } else if (this.radioVal === 'LegalEntity' && this.apiResult && this.apiResult.OrganisationIdentificationList && this.apiResult.OrganisationIdentificationList.OrganisationIdentificationDetails.length) {
                        this.handleSuccess('Success', 'Search Externally', 'success');
                        this.showLegalEntity = true;
                        this.showCustom = false;
                        this.showTable = false;
                        this.showPlantable = false;
                    } else {
                        this.handleSuccess('', 'No result found Externally', 'warning');
                        this.showCustom = false;
                        this.showTable = false;
                        this.showPlantable = false;
                        this.showLegalEntity = false;
                    }
                } else {
                    this.handleSuccess('', 'No result found Externally', 'warning');
                }
                this.isLoaded = false;
           })
            .catch(error => {
                console.log(error);
                this.handleSuccess('error', error.body.message, 'error');
                this.isLoaded = false;
            });
    }
    
    tableControllerCheck(clientNumber, radioval) {
        tableController({clientNumber : clientNumber, radioval:radioval})
            .then(result => {
                if (result){
                    console.log('Result---', result);
                    //this.clientResult = JSON.parse(result); 
                    this.handleSuccess('Please Wait', result, 'success'); 
                    this.isLoaded = false;
                }  
            })
            .catch(error => {
                console.log(error);
                this.handleSuccess('error', error.body.message, 'error');
                this.isLoaded = false;
                
            });
    }

    handleChangerecord(event){ 
        var parObject = new Object();
        parObject['id'] = event.target.dataset.id;
        parObject['lastname'] =  event.target.dataset.lastname;
        parObject['firstname'] = event.target.dataset.firstname;
        parObject['birthDate'] = event.target.dataset.dob;
        parObject['rsaIdNumber'] = event.target.dataset.idnumber;
        parObject['countryofissue'] = event.target.dataset.countryofissue;
        parObject['clientNumber'] = event.target.dataset.membernumber;
        parObject['policynumber'] = event.target.dataset.policynumber;
        parObject['rowintermediarynumber'] = event.target.dataset.intermediarynumber;
        parObject['telephone'] = event.target.dataset.telephone;
        parObject['email'] = event.target.dataset.email;
        this.clientNumber = parObject.clientNumber;
        this.accData = JSON.stringify(event.target.dataset);
        console.log('objectid',JSON.stringify(event.target.dataset));
        console.log('11112222'+JSON.stringify(parObject));
    }

    handleLegalEntity(event){ 
        var parObject = new Object();
        parObject['lastname'] =  event.target.dataset.lastname;
        parObject['rsaIdNumber'] = event.target.dataset.idnumber;
        parObject['clientNumber'] = event.target.dataset.membernumber;
        parObject['rowintermediarynumber'] = event.target.dataset.intermediarynumber;
        this.clientNumber = parObject.clientNumber;
        console.log('11112222'+JSON.stringify(parObject));
    }

    handlePlanSelect(event){ 
        var parObject = new Object();
        parObject['lastname'] =  event.target.dataset.name;
        parObject['rsaIdNumber'] = event.target.dataset.idnumber;
        parObject['clientNumber'] = event.target.dataset.membernumber;
        parObject['policynumber'] = event.target.dataset.policynumber;
        parObject['countryofissue'] = event.target.dataset.countryofissue;
        this.clientNumber = parObject.clientNumber;
        console.log('11112222'+JSON.stringify(parObject));
    }

    selectedRowHandler(event){
        const selectedRows = event.detail.selectedRows; 
        this.selectedData = selectedRows;
        console.log("You selected: " +JSON.stringify(this.selectedData));
    }
    handle() {
        console.log("You selected: " + JSON.stringify(this.selectedData));
        console.log("You selected: " + JSON.stringify(this.selectedData.length));
        console.log("You selected: " + JSON.stringify(this.clientNumber));
        if (this.radioVal === 'Intermediary') {
            this.clientNumber = 'AV7EC315';
        }
        if (this.clientNumber || this.selectedData.length) {
            this.isLoaded = true;
            this.tableControllerCheck(this.clientNumber, this.radioVal);
        } else {
            this.handleSuccess('Warning','Please pick a Client', 'warning');
        }
    }
    createAccount(){
        this.isLoaded = true;
        this.createAccountMethod();
    }

    createAccountMethod(){
        CreateMemberPortfolioMethod({recordData : this.accData, isTaskTrue: this.isTaskCreated , eventType : this.claimEventType, isAccountTrue:this.isAccountCreated})
            .then(result => {
                if(result== 'Show Toast' ){
                this.handleSuccess( 'Success', 'There is already an Event underway for this member, Please wait','success' );
                }else if(result== 'Already Exists' ){
                this.handleSuccess( 'Success', 'Account is already exist.','success' );
                }else {
                this.handleSuccess( 'Success', 'Record is created successfully!','success' );
                }
                this.isLoaded = false;
            })
            .catch(error => {
                this.handleSuccess( 'Error', error.body.message , 'error');
                this.isLoaded = false;
            });
    }
}