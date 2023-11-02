public class SESUtil {
    public SESUtil() {

    }

    public static void sendEmail(List<String> recipients, String sender) {
        // create email body:
        EmailBody emailToSend = new EmailBody();

        // Create Content object
        emailToSend.Content = new EmailBody.Content();
        emailToSend.Content.Simple = new EmailBody.Simple();
        emailToSend.Content.Simple.Body = new EmailBody.Body();
        emailToSend.Content.Simple.Subject = new EmailBody.Html();
        
        // Assign values
        emailToSend.Content.Simple.Body.Text = new EmailBody.Html();
        emailToSend.Content.Simple.Body.Text.Data = 'helloooo';
        emailToSend.Content.Simple.Subject.Data = 'from ses';
        
        // Create Destination object
        emailToSend.Destination = new EmailBody.Destination();
        emailToSend.Destination.ToAddresses = new List<String>();
        
        // Add recipients to the ToAddresses list
        emailToSend.Destination.ToAddresses.addAll(recipients);
        
        // Set the sender email address
        emailToSend.FromEmailAddress = sender;


        // http call to aws to send the email:
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SES_PROPERTIES/v2/email/outbound-emails');
        req.setMethod('POST');
        req.setHeader('Content-type', 'application/json');
        req.setBody(JSON.serialize(emailToSend));

        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
    }
}