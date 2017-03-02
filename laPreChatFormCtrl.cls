/**
 * @description Controls the pre-chat form.
 *
 * @author		Arturs Gusjko
 */
public with sharing class laPreChatFormCtrl
{
    /** Pre-chat window title */
	public String windowTitle { get; private set; }
    /** Page Language */
    public String language { get; private set; }
    /** Person Account Record Type Id */
    public Id accRtId { get; private set; }

	/**
	 * @description Initialises the constructor. Searches for the correct deployment information.
	 * @author      Arturs Gusjko
	 */
    public laPreChatFormCtrl()
    {
    	String endpoint = ApexPages.currentPage().getParameters().get('endpoint');
    	LiveChatButton button =
            [   SELECT  Id
                        , Language
                        , MasterLabel
                FROM LiveChatButton
                WHERE Id = :(endpoint.substringAfter('button_id=').substringBefore('&'))
                LIMIT 1
            ];
        windowTitle = button.MasterLabel;
        language = button.Language;

        accRtId = [SELECT Id FROM RecordType WHERE IsPersonType = true AND SObjectType = 'Account' LIMIT 1].Id;
    }
}