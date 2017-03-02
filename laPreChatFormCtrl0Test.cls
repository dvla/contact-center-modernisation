/**
 * @description Tests for associated class.
 *
 * @author      Artur Gusjko
 */
@IsTest
private class laPreChatFormCtrl0Test
{
	static PageReference curPage = Page.laPreChatForm;
	static LiveChatDeployment anyDeployment = [SELECT Id, WindowTitle FROM LiveChatDeployment LIMIT 1];
    static LiveChatButton anyButton = [SELECT Id, Language, MasterLabel FROM LiveChatButton LIMIT 1];

    static private void setup()
    {
    	curPage.getParameters().put('endpoint', 'https://dev-dvladev.cs82.force.com/generic/apex/laCustomChat?language=#deployment_id=' + anyDeployment.Id + '&org_id=' + UserInfo.getOrganizationId() + '&button_id=' + anyButton.Id + '&session_id=' + Utils.getRandomUUIDv4());
    	Test.setCurrentPage(curPage);
        //TestData.setup();
    }

    @IsTest(SeeAllData=false) static void testLiveAgentButtonLabel()
    {
    	setup();
    
    	Test.startTest();
    	
    		laPreChatFormCtrl ctrl = new laPreChatFormCtrl();
    		System.assertEquals(anyButton.MasterLabel, ctrl.windowTitle);
            System.assertEquals(anyButton.Language, ctrl.language);

    	Test.stopTest();
    }
}