/**
 * @description Controls the post-chat form by initialising the survey and saving the data as the user progresses through the questions.
 *
 * @author      Arturs Gusjko
 *
 * Edit     Date        Who         Comment
 *  001     28/09/16    NTJ         Make it work for Cases also
 */
public with sharing class laPostChatFormCtrl
{
    private Boolean transcriptMode {get; set;}
	private String  chatKey {get; set;}
        
    /** Chat text data */
    public String transcript { get; private set; }
    /** Link to the transcript download source */
    public PageReference getTranscriptDownload() {
        PageReference pr = Page.laTranscriptDownload;
        pr.getParameters().put('data', transcript);
        pr.setRedirect(true);
        system.debug(pr);
        system.debug(transcript);
        return pr;
    }

    /** Reference to the standard Survey__c controller */
    public ApexPages.StandardController stdCtrl { get; private set; }
    /** Reference to the Survey__c object created by standard controller */
    public Survey__c theSurvey
    {
        get {
            return (Survey__c)stdCtrl.getRecord();
        }
    }
    /** Total number of questions to loop through */
    public Integer totalQuestions
    {
        get {
            return questionFields.size();
        }
    }
    /** Current question number */
    public Integer curQuestionNo { get; private set; }
    /** Reference to button */
    public LiveChatButton liveAgentButton { get; private set; }
    /** DeveloperName of the button that initialised the chat */
    public String liveAgentButtonName
    { 
        get {
            if (transcriptMode) {
                return liveAgentButton.DeveloperName;
                
            } else {
                return 'Web_To_Case';
            }
         }
    } 
    /** Label of the button that initialised the chat */
    public String windowTitle { get; private set; }
    /** A list of answer fields used for the current view */
    private List<Schema.FieldSetMember> questionFields
    { 
        get {
            return Schema.SObjectType.Survey__c.fieldSets.getMap().get('B_'+liveAgentButtonName).getFields();
        }
    }

    // Case associated with this survey
    private Case theCase {get; set;}

    /**
     * @description Initialises the controller, adds query fields to 
     *              standard controller, sets the chat key field and
     *              initialises questions/answers.      
     * @author  Arturs Gusjko <arturs.gusjko@bettercloudsolutions.co.uk>
     * @param stdCtrl is a reference to the standard controller.
     */
    public laPostChatFormCtrl(ApexPages.StandardController stdCtrl)
    {
        this.stdCtrl = stdCtrl;
        processParameters();
        transcript = ApexPages.currentPage().getParameters().get('transcript');
        if(!Test.isRunningTest()) {
            stdCtrl.addFields(getQuestionFieldNames());
        }
        curQuestionNo = isAlreadyAnswered() ? totalQuestions : 0;
    }

    /**
     * @description Determines the fields that are used for answers.
     * @author  Arturs Gusjko <arturs.gusjko@bettercloudsolutions.co.uk>
     * @return a list of Survey__c answer fields.
     */
    @TestVisible
    private List<String> getQuestionFieldNames()
    {
        List<String> fieldNames = new List<String>();
        for(Schema.FieldSetMember fsm : questionFields)
        {
            fieldNames.add('A_'+fsm.getFieldPath().substring(2));
        }
        return fieldNames;
    }

    /**
     * @description Determines whether the survey was previously answered.
     * @author  Arturs Gusjko <arturs.gusjko@bettercloudsolutions.co.uk>
     * @return true if the survey is already answered, false otherwise.
     */
    public Boolean isAlreadyAnswered()
    {
    	system.debug('isAlreadyAnswered: '+theSurvey);
    	Integer sameSurveyCount;
    	if (transcriptMode) {
    		if (string.isNotBlank(theSurvey.Chat_Key__c)) {
	    		sameSurveyCount = [SELECT Count() FROM Survey__c WHERE Chat_Key__c = :theSurvey.Chat_Key__c LIMIT 1];    			
    		} else {
				sameSurveyCount = 0;    			
    		}
    	} else {
    		sameSurveyCount = 0;
    	}
        return sameSurveyCount > 0;
    }

    /**
     * @description Navigates user to the next question.
     * @author  Arturs Gusjko <arturs.gusjko@bettercloudsolutions.co.uk>
     */
    public void next()
    {
        if ((!transcriptMode)) {
			theSurvey.RecordTypeId = Utils.getRecordTypeId('Case_Survey');
         	theSurvey.Case_Token__c = theCase.User_Token__c;
        } else {
			theSurvey.RecordTypeId = Utils.getRecordTypeId('Web_Chat_Survey');
	        theSurvey.Chat_Key__c = chatKey;        	
        }
        system.debug('Next:');
        stdCtrl.save();
        curQuestionNo += 1;
    }

    /**
     * @description populates button object.
     * @author  Arturs Gusjko <arturs.gusjko@bettercloudsolutions.co.uk>
     */
    private void populateLiveagentButton(String buttonId)
    {
        liveAgentButton = [SELECT Id, DeveloperName, MasterLabel, Language FROM LiveChatButton WHERE Id = :buttonId LIMIT 1];
        if (liveAgentButton != null) {
            windowTitle = liveAgentButton.MasterLabel;
            chatKey = ApexPages.currentPage().getParameters().get('chatKey');  
        }
    }

    /*
     * @description gets the case associated with the token
     * @author  Neil Jones 
     */
    private void populateCase(String token) {
    	system.debug('populateCase: '+token);
        theCase = [SELECT Id, Subject, CaseNumber, User_Token__c FROM Case WHERE User_Token__c =:token LIMIT 1];
        if (theCase != null) {
            windowTitle = theCase.subject;
           transcriptMode = false;
        }
     }

    /*
     * @description gets the case
     * @author  Neil Jones 
     */
    private void processParameters() {
        transcriptMode = true;
    
       // get the parameters, only one should be supplied
       String buttonId = ApexPages.currentPage().getParameters().get('buttonId');
       String token = ApexPages.currentPage().getParameters().get('token');
       
       if (String.isNotBlank(buttonId)) {
           populateLiveagentButton(buttonId);
       } else if (String.isNotBlank(token)) {
           populateCase(token);
       }        
    }
}