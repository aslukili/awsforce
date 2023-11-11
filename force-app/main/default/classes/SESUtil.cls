public class SESUtil {
    public SESUtil() {

    }

    public static void sendEmail(List<String> recipients, String sender) {
        // create email body:

        Map<String, Object> emailVariables = new Map<String, Object>{
            'message'=>'helliiiii',
            'subject'=>'sujjddjjd',
            'toAddresses'=>new List<String>{'abdeslamhq@gmail.com'}
        };
        DataWeave.Script dwscript = new DataWeaveScriptResource.sesSingleEmailRequestBuilder();
        DataWeave.Result dwresult = dwscript.execute(new Map<String, Object>{'payload' => JSON.serialize(emailVariables)});


        // http call to aws to send the email:
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SES_PROPERTIES/v2/email/outbound-emails');
        req.setMethod('POST');
        req.setHeader('Content-type', 'application/json');
        req.setBody(dwresult.getValueAsString());

        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
    }
}