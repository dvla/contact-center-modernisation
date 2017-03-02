/**
 * @description Tests for associated class.
 *
 * @author      Artur Gusjko
 */
@IsTest
private class laCustomChatCtrl0Test
{
    static PageReference curPage = Page.laCustomChat;
    static LiveChatDeployment anyDeployment = [SELECT Id, WindowTitle FROM LiveChatDeployment LIMIT 1];
    static LiveChatButton anyButton = [SELECT Id, Language, MasterLabel FROM LiveChatButton LIMIT 1];

    static private void setup()
    {
        curPage.getParameters().put('liveagent.prechat.buttons', ''+anyButton.Id);
        Test.setCurrentPage(curPage);
        //TestData.setup();
    }

    @IsTest(SeeAllData=false) static void testLiveAgentButtonLabel()
    {
        setup();
    
        Test.startTest();
        
            laCustomChatCtrl ctrl = new laCustomChatCtrl();
            System.assertEquals(anyButton.MasterLabel, ctrl.windowTitle);
            System.assertEquals(anyButton.Language, ctrl.language);

        Test.stopTest();
    }
}