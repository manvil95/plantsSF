@isTest
private with sharing class ForecastServiceTest {
	@isTest
	static void getTodaysTemperaturesExecutesHTTPCalloutAndReturnsTemperatures() {
		System.debug('ForecastServiceTest getTodaysTemperaturesExecutesHTTPCalloutAndReturnsTemperatures Start');
		// GIVEN
		HttpMockFactory mock = new HttpMockFactory(
			200,
			'OK',
			'{"temperaturas":{"max":25,"min":10}}',
			new Map<String, String>()
		);
		Test.setMock(HttpCalloutMock.class, mock);

		// WHEN
		Test.startTest();
		ForecastService.Forecast result = ForecastService.getTodaysTemperatures();
		Test.stopTest();

		// THEN
		Assert.areEqual(25, result.temperaturas.max, 'El resultado esperado es 25.');
		Assert.areEqual(10, result.temperaturas.min, 'El resultado esperado es 10.');

		System.debug('ForecastServiceTest getTodaysTemperaturesExecutesHTTPCalloutAndReturnsTemperatures End');
	}

	@isTest
	static void postNotificationsLowTemperatureCorrectPlatformEventPosted() {
		System.debug('ForecastServiceTest postNotificationsLowTemperatureCorrectPlatformEventPosted Start');
		// GIVEN
		TestDataFactory factory = new TestDataFactory();
		factory.minTemperature 	= -5;
		factory.createSpecies();

		HttpMockFactory mock = new HttpMockFactory(
			200,
			'OK',
			'{"temperaturas":{"max":5,"min":-10}}',
			new Map<String, String>()
		);
		Test.setMock(HttpCalloutMock.class, mock);

		// WHEN
		Test.startTest();
		ForecastService.postNotifications();
		Test.stopTest();

		// THEN
		Assert.areEqual(2, PlatformEventsService.platformEvents.size());
		Assert.areEqual(PlatformEventsService.platformEvents[0].Tipo_de_Alerta__c, 'frio');
		Assert.areEqual(PlatformEventsService.platformEvents[1].Tipo_de_Alerta__c, 'frio');

		System.debug('ForecastServiceTest postNotificationsLowTemperatureCorrectPlatformEventPosted End');
	}

	@isTest
	static void postNotificationsHighTemperatureCorrectPlatformEventPosted() {
		System.debug('ForecastServiceTest postNotificationsHighTemperatureCorrectPlatformEventPosted Start');
		// GIVEN
		TestDataFactory factory = new TestDataFactory();
		factory.maxTemperature 	= 35;
		factory.createSpecies();

		HttpMockFactory mock = new HttpMockFactory(
			200,
			'OK',
			'{"temperaturas":{"max":40,"min":20}}',
			new Map<String, String>()
		);
		Test.setMock(HttpCalloutMock.class, mock);

		// WHEN
		Test.startTest();
		ForecastService.postNotifications();
		Test.stopTest();

		// THEN
		Assert.areEqual(2, PlatformEventsService.platformEvents.size());
		Assert.areEqual(PlatformEventsService.platformEvents[0].Tipo_de_Alerta__c, 'calor');
		Assert.areEqual(PlatformEventsService.platformEvents[1].Tipo_de_Alerta__c, 'calor');

		System.debug('ForecastServiceTest postNotificationsHighTemperatureCorrectPlatformEventPosted End');
	}

	@isTest
	static void postNotificationsGoodTemperatureNoPlatformEventPosted() {
		// GIVEN
		TestDataFactory factory = new TestDataFactory();
		factory.maxTemperature 	= 35;
		factory.minTemperature 	= -5;
		factory.createSpecies();

		HttpMockFactory mock = new HttpMockFactory(
			200,
			'OK',
			'{"temperaturas":{"max":25,"min":20}}',
			new Map<String, String>()
		);
		Test.setMock(HttpCalloutMock.class, mock);

		// WHEN
		Test.startTest();
		ForecastService.postNotifications();
		Test.stopTest();

		// THEN
		Assert.areEqual(0, PlatformEventsService.platformEvents.size());
	}
}
