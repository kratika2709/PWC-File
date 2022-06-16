@isTest
global class ClaimEventMockClass implements HttpCalloutMock{
    global HttpResponse respond(HTTPRequest req){
        system.assertEquals('https://virtserver.swaggerhub.com/Private596/ClaimAdministrationAPI/1.0.1/event/v1.0/single', req.getEndPoint());
        system.assertEquals('POST', req.getMethod());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('{"example":"test"}');
        return res;
    }
}