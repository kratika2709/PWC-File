@isTest
public class SearchLidControllermock implements HttpCalloutMock {
    
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        List<SearchLidController.ClientIdentifications> ClientIdentifications = new List<SearchLidController.ClientIdentifications>();
        
        SearchLidController.PostalAddress pAdd = new SearchLidController.PostalAddress();
        pAdd.addressLine1 = 'Posbus 7266';
        
        SearchLidController.PersonName pName = new SearchLidController.PersonName();
        pName.surname = 'De Kock';
        pName.preferredName = 'Tertia';
        
        SearchLidController.ClientIdentifications clientId = new SearchLidController.ClientIdentifications();
        clientId.personName = pName;
        clientId.clientNumber = 'AA6VT166';
        clientId.rsaIdNumber='206130150086';
        clientId.passportNumber='test';
        clientId.citizenshipDescription='South Africa';
        clientId.birthDate='1962-06-13';
        clientId.genderDescription='Female';
        clientId.jockeyCode='00169854';
        clientId.postalAddress =pAdd;
        ClientIdentifications.add(clientId);
        
        SearchLidController.ResponseWrapper responseFake = new SearchLidController.ResponseWrapper();
        responseFake.ClientIdentifications = ClientIdentifications;
        
        HttpController.ResponseTokenWrapper responseToken = new HttpController.ResponseTokenWrapper();
        responseToken.access_token='6c11a20b-5d73-4a2f-b420-c1d3ac4c90e7';
        responseToken.token_type='Bearer';
        responseToken.expires_in='3600';
        responseToken.refresh_token='b1887082-9f04-4d37-8959-47a482c49956';
        
        // Create a fake response
        if (req.getEndpoint() == 'https://api-tst.sanlam.co.za/spf/claimmanagement/clients/search') {
            res.setBody(JSON.serialize(responseFake));
            return res;
        } else if(req.getEndpoint() == 'https://api-tst.sanlam.co.za/auth/oauth/v2/token'){
            res.setBody(JSON.serialize(responseToken));
            return res;
        } else if(req.getEndpoint() == 'https://api-tst.sanlam.co.za/spf/claimmanagement/clients?planNumber=0406345785'){
            String responsePolicy = '{"planDetails":[{"planNumber":"0406345785","partyRoleDetailsList":{"partyRoleDetails":[{"role":{"roleType":null,"roleCode":"M006","roleDescriptionEnglish":"Millennium Beneficiary        "},"partyIdentificationDetails":{"partyNumber":"AF8FR278","partyType":"1","partySurname":"De Kock","partyFirstName":"Martha","partyInitials":"ME    ","organisationName":"","preferredLanguage":"Afr  ","birthDate":"1973-10-03"}}]}}]}';
        	res.setBody(responsePolicy);
            return res;
        }else if(req.getEndpoint() == 'https://api-tst.sanlam.co.za/spf/claimmanagement/informationRequest'){
             res.setBody(JSON.serialize(responseToken));    //(------);
             return res;
            
        } else {
            return null;
        }
    }
}