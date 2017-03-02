global class laDeleteTranscriptsSchedule implements Schedulable {
    global void execute(SchedulableContext sc){
    	system.debug('Execute: start');
        try {
	        laDeleteTranscriptsBatch delBatch = new laDeleteTranscriptsBatch();
	        Id BatchProcessId = Database.ExecuteBatch(delBatch);   	        	
        } catch (Exception e) {
        	system.debug(e);
        }
     	system.debug('Execute: end');
    }    
}