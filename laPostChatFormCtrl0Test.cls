/**
 * @description Tests for associated class.
 *
 * @author      Artur Gusjko
 */
@IsTest
private class laPostChatFormCtrl0Test
{
    static private LiveChatTranscript tx;
    static private Survey__c survey;

    static private void setup()
    {
        TestData.setup();

        tx = TestData.createLiveChatTranscript();
        survey = TestData.createSurveyc();
        survey.Chat_Key__c = null;

        PageReference curPage = Page.laPostChatForm;
        LiveChatButton btn = [SELECT Id, DeveloperName FROM LiveChatButton WHERE DeveloperName = 'Personalised_Registrations' LIMIT 1];
        LiveChatDeployment deployment = [SELECT Id FROM LiveChatDeployment LIMIT 1];

        curPage.getParameters().put('deploymentId', deployment.Id);
        curPage.getParameters().put('buttonId', btn.Id);
        curPage.getParameters().put('chatKey', tx.ChatKey);
        curPage.getParameters().put('transcript', 'Hi, how are you?');
        Test.setCurrentPage(curPage);
    }

    @IsTest(SeeAllData=false) static void testControllerFlow()
    {
        setup();
    
        Test.startTest();
        
            laPostChatFormCtrl ctrl = new laPostChatFormCtrl(new ApexPages.StandardController(survey));
            System.assertEquals(false, ctrl.isAlreadyAnswered());
            System.assertNotEquals(null, ctrl.getQuestionFieldNames());
            System.assertNotEquals(null, ctrl.totalQuestions);
            System.assertNotEquals(null, ctrl.windowTitle);
            System.assertNotEquals(null, ctrl.getTranscriptDownload());
            PageReference downloadLink = ctrl.getTranscriptDownload();
            System.assertEquals('Hi, how are you?', downloadLink.getParameters().get('data'));
            
            ctrl.theSurvey.A_Overall_Satisfaction__c = 4;
            ctrl.next();
            System.assertEquals(tx.ChatKey, ctrl.theSurvey.Chat_Key__c);
            system.debug('Messages: '+ApexPages.getMessages());
            System.assertEquals(false, ApexPages.hasMessages(ApexPages.Severity.Error) || ApexPages.hasMessages(ApexPages.Severity.Fatal));

            System.assertNotEquals(null, ctrl.stdCtrl.getId());
            Survey__c rSurvey = (Survey__c)Utils.resetSObject(new Survey__c(Id=ctrl.stdCtrl.getId()));
            System.assertEquals(4, rSurvey.A_Overall_Satisfaction__c);

        Test.stopTest();
    }
 
 	private static User u;
 	private static Case c;
 
 	private static void caseSetup() {
 		// create an agent user
 		u = TestData.createAgent();
		insert u;
 		system.assertNotEquals(null, u.Id);
 		
        try {
            DisabledComponent__c comps = DisabledComponent__c.getInstance();
            comps.LA_Survey_to_Transcript_Linkage__c = false;
            comps.W2C_Survey_to_Case_Linkage__c = false;
            upsert comps;
        } catch(Exception ex){}

        survey = TestData.createSurveyc();

 		// create one case
 		List<Case> cases = TestData.insertCases(1);
		system.assertEquals(1, cases.size());
		c = cases[0];

		// now modify it so that the LastModifiedBy field gets changed
		c.ownerId = u.Id;
		update c;
		
		c = [SELECT Id, ownerId, user_token__c, survey__c FROM Case WHERE Id=:c.Id]; 		
		system.assertEquals(u.Id, c.ownerId);
		system.assertEquals(null, c.survey__c);
		system.assertNotEquals(null, c.user_token__c);

        PageReference curPage = Page.wfSurvey;
        curPage.getParameters().put('token', c.user_token__c);
        Test.setCurrentPage(curPage);
 	}
    
    private static testmethod void testCaseFlow() {
    	caseSetup();
    	
    	Test.startTest();
            laPostChatFormCtrl ctrl = new laPostChatFormCtrl(new ApexPages.StandardController(survey));
            System.assertEquals(false, ctrl.isAlreadyAnswered());
            System.assertNotEquals(null, ctrl.getQuestionFieldNames());
            System.assertNotEquals(null, ctrl.totalQuestions);
            System.assertNotEquals(null, ctrl.windowTitle);
             
            System.assertEquals(null, ctrl.theSurvey.Case_Token__c);

            ctrl.theSurvey.A_Overall_Satisfaction__c = null;
            ctrl.theSurvey.A_Overall_Case_Satisfaction__c = 4;
            ctrl.theSurvey.A_Information_Quality__c = 4;
            ctrl.theSurvey.A_Service_Speed__c = 4;
            ctrl.theSurvey.A_Comments__c = 'Lovely service';
            ctrl.next();
            system.debug('Messages: '+ApexPages.getMessages());
            System.assertEquals(false, ApexPages.hasMessages(ApexPages.Severity.Error) || ApexPages.hasMessages(ApexPages.Severity.Fatal));

            System.assertNotEquals(null, ctrl.stdCtrl.getId());
            Survey__c rSurvey = (Survey__c)Utils.resetSObject(new Survey__c(Id=ctrl.stdCtrl.getId()));
            System.assertEquals(4, rSurvey.A_Overall_Case_Satisfaction__c);
            System.assertEquals(4, rSurvey.A_Information_Quality__c);
            System.assertEquals(4, rSurvey.A_Service_Speed__c);
            System.assertEquals('Lovely service', rSurvey.A_Comments__c);
            System.assertEquals('Yes', rSurvey.All_Questions_Answered__c);
            System.assertEquals(null, rSurvey.A_Overall_Satisfaction__c);
            ctrl.next();

    	Test.stopTest();

		// Query the case and check the survey has been setup
		c = [SELECT Id, ownerId, user_token__c, survey__c FROM Case WHERE Id=:c.Id]; 
		system.assertEquals(ctrl.stdCtrl.getId(), c.survey__c);
				
    }
}