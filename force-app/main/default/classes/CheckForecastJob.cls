public with sharing class CheckForecastJob implements Schedulable {
  	public void execute(SchedulableContext sc) {
		System.debug('CheckForecastJob execute Start');

		ForecastService.postNotifications();

		System.debug('CheckForecastJob execute End');
	}	
}
