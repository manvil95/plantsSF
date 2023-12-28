@RestResource(urlMapping='/checkForecast')
global with sharing class ForecastRestAPI {
	
	@HttpGet
	global static void doGet() {
		System.debug('ForecastRestAPI doGet Start');
		// RestRequest req = RestContext.request;
		// RestResponse res = RestContext.response;
		ForecastService.postNotifications();

		System.debug('ForecastRestAPI doGet End');
	}
}
