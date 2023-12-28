public with sharing class DateService {
	
	public Integer getCurrentMonth() {
		System.debug('DataService getCurrentMonth Start');
		System.debug('DataService getCurrentMonth End');
    	return System.today().month();
	}
}
