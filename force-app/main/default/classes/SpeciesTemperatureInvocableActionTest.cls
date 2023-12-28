@isTest
private with sharing class SpeciesTemperatureInvocableActionTest {
	@isTest
	static void getTemperatureWarningLowTemperatureCorrectWarningReturned() {
		System.debug('SpeciesTemperatureInvocableActionTest getTemperatureWarningLowTemperatureCorrectWarningReturned Start');
		// GIVEN
		TestDataFactory factory = new TestDataFactory();
		factory.minTemperature = -5;
		Id speciesId = factory.createSpecies();

		HttpMockFactory mock = new HttpMockFactory(
			200,
			'OK',
			'{"temperaturas":{"max":5,"min":-10}}',
			new Map<String, String>()
		);
		Test.setMock(HttpCalloutMock.class, mock);

		// WHEN
		Test.startTest();
		List<String> messages = SpeciesTemperatureInvocableAction.getTemperatureWarning(
			new List<Id>{ speciesId }
		);
		Test.stopTest();

		// THEN
		Assert.isFalse(messages.isEmpty(), 'Expected a message');
		Assert.areEqual(
			messages[0],
			'Cuidado, hace mucho frío para las plantas de esta especie!'
		);
		System.debug('SpeciesTemperatureInvocableActionTest getTemperatureWarningLowTemperatureCorrectWarningReturned End');
	}

	@isTest
	static void getTemperatureWarningHighTemperatureCorrectWarningReturned() {
		System.debug('SpeciesTemperatureInvocableActionTest getTemperatureWarningHighTemperatureCorrectWarningReturned Start');
		// GIVEN
		TestDataFactory factory = new TestDataFactory();
		factory.maxTemperature 	= 30;
		Id speciesId 			= factory.createSpecies();

		HttpMockFactory mock = new HttpMockFactory(
			200,
			'OK',
			'{"temperaturas":{"max":40,"min":20}}',
			new Map<String, String>()
		);
		Test.setMock(HttpCalloutMock.class, mock);

		// WHEN
		Test.startTest();
		List<String> messages = SpeciesTemperatureInvocableAction.getTemperatureWarning(
			new List<Id>{ speciesId }
		);
		Test.stopTest();

		// THEN
		Assert.isFalse(messages.isEmpty(), 'Expected a message');
		Assert.areEqual(messages[0], 'Cuidado, hace mucho calor para las plantas de esta especie!');
		
		System.debug('SpeciesTemperatureInvocableActionTest getTemperatureWarningHighTemperatureCorrectWarningReturned End');
	}
	
	@isTest
	static void getTemperatureWarningGoodTemperatureCorrectWarningReturned() {
		System.debug('SpeciesTemperatureInvocableActionTest getTemperatureWarningGoodTemperatureCorrectWarningReturned Start');
		// GIVEN
		TestDataFactory factory = new TestDataFactory();
		factory.maxTemperature 	= 35;
		factory.minTemperature 	= -5;
		Id speciesId 			= factory.createSpecies();

		HttpMockFactory mock = new HttpMockFactory(
			200,
			'OK',
			'{"temperaturas":{"max":25,"min":10}}',
			new Map<String, String>()
		);
		Test.setMock(HttpCalloutMock.class, mock);

		// WHEN
		Test.startTest();
		List<String> messages = SpeciesTemperatureInvocableAction.getTemperatureWarning(
			new List<Id>{ speciesId }
		);
		Test.stopTest();

		// THEN
		Assert.isFalse(messages.isEmpty(), 'Expected a message');
		Assert.areEqual(messages[0], 'Enhorabuena! Hace una temperatura óptima para tu nueva especie');

		System.debug('SpeciesTemperatureInvocableActionTest getTemperatureWarningGoodTemperatureCorrectWarningReturned End');
	}
}
