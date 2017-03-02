/**
 * @description Controls the pre-chat form.
 *
 * @author      Arturs Gusjko
 */
public with sharing class laCustomChatCtrl
{
    /** Pre-chat window title */
    public String windowTitle { get; private set; }
    /** Page Language */
    public String language { get; private set; }

    /**
     * @description Initialises the constructor. Searches for the correct deployment information.
     * @author      Arturs Gusjko
     */
    public laCustomChatCtrl()
    {   
        system.debug(apexpages.currentpage().getParameters());

        String buttonId = ApexPages.currentPage().getParameters().get('liveagent.prechat.buttons');
        LiveChatButton button =
            [   SELECT  Id
                        , Language
                        , MasterLabel
                FROM LiveChatButton
                WHERE Id = :buttonId
                LIMIT 1
            ];
        windowTitle = button.MasterLabel;
        language = button.Language;
    }
}