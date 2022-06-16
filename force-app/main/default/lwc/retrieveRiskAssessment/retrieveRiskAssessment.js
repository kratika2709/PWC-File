import { LightningElement, api,wire} from 'lwc';
import { getRecord, getFieldValue  } from 'lightning/uiRecordApi';
import getPersonMember from '@salesforce/apex/RetrieveRiskAssessment.getPersonMember';
import callClaimEvent from '@salesforce/apex/RetrieveRiskAssessment.callClaimEvent';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class RetrieveRiskAssessment extends LightningElement {
    @api recordId;
    @api personAccountId;
    personAccountRecord;
    PersonMemberRecord;
    error;
    dataResponse;

    @wire(getPersonMember, { recId : '$recordId'})
    personAccountRecord( { error, data }) {
        if( data ){
        this.dataResponse = data;
        let recordData = {"membernumber":data}
        this.callClaimHandler(JSON.stringify(recordData) , true , 'retrieveRiskAssessment',false);
        
        }else if(!data){
            this.dispatchEvent(new CloseActionScreenEvent());
            this.handleSuccess( 'Warning', 'Member number not available for risk assessment and must be excecuted manually','warning' );
        }
        else if( error ){
            this.handleSuccess( 'Error', error.body.message , 'error');
        }
     
    }
    handleSuccess(title, message, variant) {
        const showSuccess = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'sticky'
        });
        this.dispatchEvent(showSuccess);
    }

    callClaimHandler(JSONData,checkTask,eventTypeName,checkAccount){
        callClaimEvent({accountData:JSONData ,isTask:checkTask, eventType:eventTypeName, isAccount:checkAccount})
            .then((result) => {
                this.dispatchEvent(new CloseActionScreenEvent());
                this.handleSuccess( 'Success', 'Task is created successfully.','success' );
            })
            .catch((error) => {
                this.error = error;
            });
    }

}