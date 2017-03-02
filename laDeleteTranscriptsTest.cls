//
@isTest
private class laDeleteTranscriptsTest {
	
	private static final Integer DATE_ON = laDeleteTranscriptsBatch.DAY_LIMIT;
	private static final Integer DATE_BEFORE = laDeleteTranscriptsBatch.DAY_LIMIT + 2;
	private static final Integer DATE_AFTER = laDeleteTranscriptsBatch.DAY_LIMIT - 2;
	
	private static String CRON_EXP = '0 0 0 15 3 ? 2022';

	private static LiveChatTranscript lctOn;
	private static LiveChatTranscript lctBefore; 
	private static LiveChatTranscript lctAfter;

    static testMethod void testScheduable() {
    	createTranscripts();

	    Test.startTest();    	

        // Schedule the test job
        String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new laDeleteTranscriptsSchedule());
         
       	// Get the information from the CronTrigger API object
       	CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00', String.valueOf(ct.NextFireTime));

        // Verify the scheduled job hasn't run yet.
        List<LiveChatTranscript> lcts = [SELECT Id, createddate, delete__c FROM LiveChatTranscript ];
        System.assertEquals(3, lcts.size());
        system.debug(lcts);
      
        Test.stopTest();

	}
	
	private static testMethod void testBatchableMark() {
    	createTranscripts();
		createCustomSettings(false);

	    Test.startTest();
	    
	    testBatchable();
	        	
		Test.stopTest();

        // Now that the batchable job has executed after Test.stopTest(),
		// test the correct records got deleted
        Map<Id, LiveChatTranscript> lctMap = new Map<Id, LiveChatTranscript>([SELECT Id, delete__c, createddate FROM LiveChatTranscript]);
		
        System.assertEquals(3, lctMap.size());
        system.debug(lctMap);
        system.assertEquals(false, lctMap.get(lctOn.Id).delete__c);
        system.assertEquals(true, lctMap.get(lctBefore.Id).delete__c);
        system.assertEquals(false, lctMap.get(lctAfter.Id).delete__c);        				
	}
	
	private static testMethod void testBatchableDelete() {
    	createTranscripts();
		createCustomSettings(true);

	    Test.startTest();
	    
	    testBatchable();
	        	
		Test.stopTest();

        // Now that the batchable job has executed after Test.stopTest(),
		// test the correct records got deleted
        Map<Id, LiveChatTranscript> lctMap = new Map<Id, LiveChatTranscript>([SELECT Id, delete__c, createddate,
                Body, Browser,BrowserLanguage, Location, ScreenResolution, SupervisorTranscriptBody, IpAddress, Keeper_Postcode__c,
				New_VRM__c, V5_Document_Reference__c, VRM__c, First_Name__c, Last_Name__c, Title__c, Email__c, Contact_Email__c, 
				Contact_Name__c FROM LiveChatTranscript]);
		
		// we no longer delete anything so check we got all three transcripts after the batch has run
        System.assertEquals(3, lctMap.size());
        system.debug(lctMap);
        
        LiveChatTranscript lctBefore2 = lctMap.get(lctBefore.Id);
        LiveChatTranscript lctOn2 = lctMap.get(lctOn.Id);
        LiveChatTranscript lctAfter2 = lctMap.get(lctAfter.Id);
        
        system.assertNotEquals(null, lctBefore2);
        system.assertNotEquals(null, lctOn2);
        system.assertNotEquals(null, lctAfter2);        				
        
        // before should have been blanked
		checkFieldsOnTranscript(lctBefore2, true);
        
        // on and after should not have been blanked
		checkFieldsOnTranscript(lctOn2, false);
		checkFieldsOnTranscript(lctAfter2, false);
	}


	private static void testBatchable() {
		/*
    	createTranscripts();

	    Test.startTest();    	
	    */
	    laDeleteTranscriptsBatch batch = new laDeleteTranscriptsBatch();
	    Database.executeBatch(batch);
	    
/*		Test.stopTest();		

        // Now that the batchable job has executed after Test.stopTest(),
		// test the correct records got deleted
        Map<Id, LiveChatTranscript> lctMap = new Map<Id, LiveChatTranscript>([SELECT Id, delete__c, createddate FROM LiveChatTranscript]);

        // one should have been deleted
        //System.assertEquals(2, lctMap.size());
        System.assertEquals(3, lctMap.size());
        system.debug(lctMap);
        system.assertEquals(false, lctMap.get(lctOn.Id).delete__c);
        system.assertEquals(true, lctMap.get(lctBefore.Id).delete__c);
        system.assertEquals(false, lctMap.get(lctAfter.Id).delete__c);        
*/
	}

	private static testmethod void testController() {
    	createTranscripts();

	    Test.startTest();    	
	    
		DVLAHouseKeepingCtrl ctrl = new DVLAHouseKeepingCtrl();
		system.assertEquals(DVLAHouseKeepingCtrl.TRANSCRIPT_NOTRUNNING, ctrl.transcriptDeleteRunningText);
		system.assertEquals(false, ctrl.transcriptDeleteRunning);
		
		// simulate pressing the start button
		ctrl.startTranscriptDelete();
		
		// check it is scheduled.
		Id jobId = ctrl.getRunningJob(DVLAHouseKeepingCtrl.TRANSCRIPT_DELETE+'Test');
		system.assertNotEquals(null, jobId);
		
		// stop it
		ctrl.stopTranscriptDelete();
		
		// check it is not scheduled.
		jobId = ctrl.getRunningJob(DVLAHouseKeepingCtrl.TRANSCRIPT_DELETE+'Test');
		system.assertEquals(null, jobId);

		Test.stopTest();		
		
	}

	private static final String INIT_BODY = 'rhubarb rhubarb rabbit rabbit chatter chatter blah blah';
	private static final String INIT_BROWSER = 'chrome';
	private static final String INIT_LANG = 'en_gb';
	private static final String INIT_TOWN = 'Swansea';
	private static final String INIT_RES = '1024x640';
	private static final String INIT_IP = '192.168.0.1';
	private static final String INIT_POST_CODE = 'L42QH';
	private static final String INIT_VRM = 'H567HTF';
	private static final String INIT_v5C = '111111111111';
	private static final String INIT_FIRST = 'Roger';
	private static final String INIT_LAST= 'Rabbit';
	private static final String INIT_TITLE= 'Mr.';
	private static final String INIT_EMAIL= 'roger.rabbit@warren.edu';
	private static final String INIT_NAME= 'Roger Rabbit';

	static void setFieldsOnTranscript(LiveChatTranscript lct) {
        lct.Body = INIT_BODY;
        lct.Browser = INIT_BROWSER;
        lct.BrowserLanguage = INIT_LANG;
        lct.Location = INIT_TOWN;
        lct.ScreenResolution = INIT_RES;
        lct.SupervisorTranscriptBody = INIT_BODY;
        lct.IpAddress = INIT_IP;
        lct.Keeper_Postcode__c = INIT_POST_CODE;
        lct.New_VRM__c = INIT_VRM;
        lct.V5_Document_Reference__c = INIT_v5C;
        lct.VRM__c = INIT_VRM;
        
        lct.First_Name__c = INIT_FIRST;
        lct.Last_Name__c = INIT_LAST;
        lct.Title__c = INIT_TITLE;
        lct.Email__c = INIT_EMAIL;
        lct.Contact_Email__c = INIT_EMAIL;
        lct.Contact_Name__c = INIT_NAME;		
	}

	static void checkFieldsOnTranscript(LiveChatTranscript lct, Boolean blankExpected) {
		system.assertEquals(blankExpected, lct.Body != INIT_BODY);
		system.assertEquals(blankExpected, lct.Browser != INIT_BROWSER);
		system.assertEquals(blankExpected, lct.BrowserLanguage != INIT_LANG);
		system.assertEquals(blankExpected, lct.Location != INIT_TOWN);
		system.assertEquals(blankExpected, lct.ScreenResolution != INIT_RES);
		system.assertEquals(blankExpected, lct.SupervisorTranscriptBody != INIT_BODY);
		system.assertEquals(blankExpected, lct.IpAddress != INIT_IP);
		system.assertEquals(blankExpected, lct.Keeper_Postcode__c != INIT_POST_CODE);
		system.assertEquals(blankExpected, lct.New_VRM__c != INIT_VRM);
		system.assertEquals(blankExpected, lct.V5_Document_Reference__c != INIT_v5C);
		system.assertEquals(blankExpected, lct.VRM__c != INIT_VRM);
		system.assertEquals(blankExpected, lct.First_Name__c != INIT_FIRST);
		system.assertEquals(blankExpected, lct.Last_Name__c != INIT_LAST);
		system.assertEquals(blankExpected, lct.Title__c != INIT_TITLE);
		system.assertEquals(blankExpected, lct.Email__c != INIT_EMAIL);
		system.assertEquals(blankExpected, lct.Contact_Email__c != INIT_EMAIL);
		system.assertEquals(blankExpected, lct.Contact_Name__c != INIT_NAME);
	}
	
	static void createTranscripts() {
		LiveChatVisitor lcv1 = new LiveChatVisitor();
		insert lcv1;
		
		// one on the date
		lctOn = new LiveChatTranscript(LiveChatVisitorId=lcv1.Id);
		setFieldsOnTranscript(lctOn);
		insert lctOn;		
		Test.setCreatedDate(lctOn.Id, system.today() - DATE_ON);

		// one before
		lctBefore = new LiveChatTranscript(LiveChatVisitorId=lcv1.Id);
		setFieldsOnTranscript(lctBefore);
		insert lctBefore;		
		Test.setCreatedDate(lctBefore.Id, system.today() - DATE_BEFORE);

		// one after
		lctAfter = new LiveChatTranscript(LiveChatVisitorId=lcv1.Id);
		setFieldsOnTranscript(lctAfter);
		insert lctAfter;
		Test.setCreatedDate(lctAfter.Id, system.today() - DATE_AFTER);		
	}
	
	static void createCustomSettings(Boolean deleteFlag) {
		Housekeeping__c hk = new Housekeeping__c(name='Default', transcript_delete__c = deleteFlag);
		insert hk;
		
	}
}