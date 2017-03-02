global with sharing class laSessionTranscriptSchedule implements Schedulable {
    global void execute(SchedulableContext sc){
    	system.debug('Execute: start');
        try {
	        laSessionTranscriptsBatch myBatch = new laSessionTranscriptsBatch();
	        // Have to have a batch size of 1 as Date Range selection is not 'bulkifiable'
	        Id BatchProcessId = Database.ExecuteBatch(myBatch, 1);   	        	
        } catch (Exception e) {
        	system.debug(e);
        }
     	system.debug('Execute: end');
    }     
}