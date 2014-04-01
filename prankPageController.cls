/* April Fool's Joke
 *
 * This controller sends an email to selected
 * victims containing a customizable, alarming message 
 * along with a hyperlink to a Gotcha! page
 *
 * Scott Covert
 * Tython
 * 4/1/14
 */

public class prankPageController {

    //String of email(s) to send prank message
    public String victims{get;set;}
    
    public prankPageController() {
        //Empty constructor method
    }
    
    public void sendPrankEmail() {
        //Query for prank email body
        list<Document> d = [SELECT Id, Description, Body, DeveloperName FROM Document WHERE DeveloperName = 'prankEmail' LIMIT 1];
        if (d.isEmpty()){
            //Error - No HTML Document exists for prank email
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No HTML Document exists for prank email!'));
        }        
        else if (victims!=null && victims!='') {
            //Define email settings
            Messaging.SingleEmailMessage prankMail = new Messaging.SingleEmailMessage();
            prankMail.setToAddresses(new String[] {victims});
            Document doc = d[0];
            prankMail.setSubject(d[0].Description);
            prankMail.setHtmlBody(d[0].Body.toString());
            prankMail.setReplyTo('noreply@salesforce.com');
            //Send email
            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {prankMail});
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Prank sent!'));
            }
            catch(System.Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }
        else {
            //Error - No victims specified
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No victims specified!'));
        }
    }

}