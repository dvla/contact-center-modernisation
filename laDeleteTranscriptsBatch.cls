//
// Class to batch delete transcripts
//
global class laDeleteTranscriptsBatch implements Database.Batchable<sObject> {
    private static Boolean actualDelete = false;

    global static final Integer DAY_LIMIT = 90;
    global final String Query = 'SELECT Id FROM LiveChatTranscript WHERE createdDate < LAST_N_DAYS:90 AND delete__c = false';

    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('start');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC,List<LiveChatTranscript> scope){
        
        system.debug('execute');
        getCustomSettings();
        // If we are simply marking then just mark
        if (!actualDelete) {
            for (LiveChatTranscript lct:scope) {
                lct.delete__c = true;
            }
            try {
                update scope;
            } catch (Exception e1) {
                system.debug('failed to update LiveChatTranscript delete flag: '+e1);
            }           
        } else {
            // else do the real delete
            // Note this deletes the child LiveChatTranscriptEvent records (master/detail) but not the Survey__c records (lookup) 
            
            system.debug('FIRED');
            for (LiveChatTranscript lct:scope) {
                lct.delete__c = true;
                lct.Body = 'Transcript deleted';
                lct.Browser = null;
                lct.BrowserLanguage = null;
                lct.Location = null;
                lct.ScreenResolution = null;
                lct.SupervisorTranscriptBody = null;
                lct.IpAddress = null;
                lct.Keeper_Postcode__c = null;
                lct.New_VRM__c = null;
                lct.V5_Document_Reference__c = null;
                lct.VRM__c = null;
                
                lct.First_Name__c = null;
                lct.Last_Name__c = null;
                lct.Title__c = null;
                lct.Email__c = null;
                lct.Contact_Email__c = null;
                lct.Contact_Name__c = null;
                
                /*
                lct.Account = null;
                lct.Contact = null;
                */
            }   
            try {
                //delete scope;
                update scope;
            } catch (Exception e2) {
                system.debug('failed to delete LiveChatTranscript delete flag: '+e2);                   
            }           
        }
    }

    global void finish(Database.BatchableContext BC){}
    
    private void getCustomSettings() {
        actualDelete = false;
        try {
            Housekeeping__c hk = Housekeeping__c.getInstance('Default');
            system.debug('hk: '+hk);
            if (hk != null) {
                actualDelete = hk.Transcript_Delete__c; 
            }           
        } catch (Exception e) {
            system.debug('failed to get custom setting Housekeeping__c: '+e);
        }
    }
}