public with sharing class CalloutService {

    public static HttpResponse makeCallout (String endPoint, String httpMethod){

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod(httpMethod);
        HttpResponse response = http.send(request);
        return http.send(request);
    }
}