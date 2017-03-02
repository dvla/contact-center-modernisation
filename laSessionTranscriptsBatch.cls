global with sharing class laSessionTranscriptsBatch implements Database.Batchable<sObject> {
	private Boolean linkFlag = false;
    private final String Query = 'SELECT Id, AgentId, LoginTime, LogoutTime FROM LiveAgentSession WHERE Transcripts_Added__c = false LIMIT 3600';
    private final String Query0 = 'SELECT Id FROM LiveAgentSession WHERE Transcripts_Added__c = false LIMIT 0';

    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('start');
		// get custom setting to see if we should do this or not
		getCustomSettings();
        return Database.getQueryLocator(linkFlag ? query : query0); 
    }

    global void execute(Database.BatchableContext BC,List<LiveAgentSession> scope){
        system.debug('execute');
        // Can only handle one at a time
		getCustomSettings();
		if ((linkFlag == true) && (scope.size() == 1)) {
			LiveAgentSession las = scope[0];
			system.debug('las: '+las);
			DateTime xSecondsAfter = las.LogoutTime.addSeconds(60);
			
			List<LiveChatTranscript> lctUpdateList = new List<LiveChatTranscript>();
			for(LiveChatTranscript lct: [SELECT id, starttime, endtime, Live_Agent_Session__c FROM livechattranscript 
										 WHERE starttime >= :las.LoginTime 
										 AND endtime <= :xSecondsAfter 
										 AND ownerId = :las.AgentId]) {
				system.debug('lct: '+lct);
				// only update those that do not already have a session
				if (lct.Live_Agent_Session__c == null) {
					lct.Live_Agent_Session__c = las.Id;
					lctUpdateList.add(lct);
				}						 	
			}
			las.Transcripts_Added__c = true;
			try {
				update lctUpdateList;  
				update las;
			} catch (Exception ex) {
				system.debug('failed to update transcript: '+ex);
			}
		}
    }

    global void finish(Database.BatchableContext BC){}
    
    private void getCustomSettings() {
        linkFlag = false;
        try {
            Housekeeping__c hk = Housekeeping__c.getInstance('Default');
            system.debug('hk: '+hk);
            if (hk != null) {
                linkFlag = hk.Session_Transcript_Linking__c; 
            }           
        } catch (Exception e) {
            system.debug('failed to get custom setting Housekeeping__c: '+e);
        }
    }
}