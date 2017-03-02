public with sharing class laEVLCtrl {
    
	public static final String ENCODED_TRANSCATION_ID = 'transId';
	
    public String transId { get; private set; }
    public String outputString { get; private set; }
    public String EVLURL = 'http://evl.dvla.local:89/Activities/Transactions.aspx?TransactionId=';
    
    
    
    // Constructor
    public laEVLCtrl() {
    	transId = ApexPages.currentPage().getParameters().get(ENCODED_TRANSCATION_ID);
    	outputString = EVLURL+transId;
    }
    
}