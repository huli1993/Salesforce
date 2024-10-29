
global class CustomerManagerMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        
        
        res.setStatusCode(200);
        
        
        String mockResponse = '{"customer_id": "12345","first_name": "John","last_name": "Doe","email": "johndoe@example.com","phone_number": "+1234567890","address": {"street": "123 Main St","city": "New York","state": "NY","postal_code": "10001","country": "USA"},"date_of_birth": "1985-06-15","registration_date": "2024-10-13","customer_status": "active","preferred_language": "English"}';

        
        res.setBody(mockResponse);

        return res;
    }


}

