/***************************************************************************************************
@author			: Manu Villen
@created     	: 30/12/2023
@modifiedBy 	 
@version     	: 1.0
@description	: Clase Test para FrequencyService
***************************************************************************************************/
@isTest
private with sharing class FrequencyServiceTest {
	/***************************************************************************************************
	@author			: Alba Rivas
	@created     	: 2021
	@modifiedBy 	 
	@version     	: 1.0
	@description	: ___Método para testear la frecuencia diaria de regado en invierno___
	***************************************************************************************************/
	@isTest
	static void getWateringDaysWateringFreqDailyAndWinterOneDay() {
		System.debug('FrequencyServiceTest getWateringDaysWateringFreqDailyAndWinterOneDay Start');
		// Mock System.today() - emular en el test en qué mes del año estoy
		DateServiceMock mock	= new DateServiceMock();
		mock.monthToReturn 		= 1;

		DateService mockDateService = (DateService) Test.createStub(DateService.class, mock);

		// GIVEN - Creación de datos, escenario...
		Species__c specie 					= new Species__c();
		specie.Winter_Watering_Frequency__c = 'Daily';
		specie.Summer_Watering_Frequency__c = 'Weekly';

		// WHEN - llamamos al método
		Integer days = FrequencyService.getWateringDays(specie, mockDateService);

		// THEN - Chequear el resultado esperado
		Integer expectedDays = 1;
		System.assertEquals(expectedDays, days, 'Expected 1 day returned');
		System.debug('FrequencyServiceTest getWateringDaysWateringFreqDailyAndWinterOneDay End');
	}

	@isTest
	static void getWateringDaysWateringFreqDailyAndSummerOneDay() {
		System.debug('FrequencyServiceTest getWateringDaysWateringFreqDailyAndSummerOneDay Start');
		// Mock System.today() - emular en el test en qué mes del año estoy
		DateServiceMock mock	= new DateServiceMock();
		mock.monthToReturn 		= 8;

		DateService mockDateService = (DateService) Test.createStub(DateService.class, mock);

		// GIVEN - Creación de datos, escenario...
		Species__c specie 					= new Species__c();
		specie.Winter_Watering_Frequency__c = 'Weekly';
		specie.Summer_Watering_Frequency__c = 'Daily';

		// WHEN - llamamos al método
		Integer days = FrequencyService.getWateringDays(specie, mockDateService);

		// THEN - Chequear el resultado esperado
		Integer expectedDays = 1;
		System.assertEquals(expectedDays, days, 'Expected 1 day returned');
		System.debug('FrequencyServiceTest getWateringDaysWateringFreqDailyAndSummerOneDay End');
	}

	@isTest
	static void getWateringDaysWateringFreqTwicePerWeekAndWinterThreeDays() {
		System.debug('FrequencyServiceTest getWateringDaysWateringFreqTwicePerWeekAndWinterThreeDays Start');
		// Mock System.today() - emular en el test en qué mes del año estoy
		DateServiceMock mock 	= new DateServiceMock();
		mock.monthToReturn 		= 1;

		DateService mockDateService = (DateService) Test.createStub(DateService.class, mock);

		// GIVEN - Creación de datos, escenario...
		Species__c specie 					= new Species__c();
		specie.Winter_Watering_Frequency__c = 'Twice per week';
		specie.Summer_Watering_Frequency__c = 'Daily';

		// WHEN - llamamos al método
		Integer days = FrequencyService.getWateringDays(specie, mockDateService);

		// THEN - Chequear el resultado esperado
		Integer expectedDays = 3;
		System.assertEquals(expectedDays, days, 'Expected 3 days returned');
		System.debug('FrequencyServiceTest getWateringDaysWateringFreqTwicePerWeekAndWinterThreeDays End');
	}

	public class DateServiceMock implements System.StubProvider {
		public Integer monthToReturn;

		public Object handleMethodCall(
				Object stubbedObject,
				String stubbedMethodName,
				Type returnType,
				List<Type> listOfParamTypes,
				List<String> listOfParamNames,
				List<Object> listOfArgs
		) {
			System.debug('FrequencyServiceTest DateServiceMock handleMethodCall Start');
			// The following debug statements show an example of logging
			// the invocation of a mocked method.

			// You can use the method name and return type to determine which method was called.
			System.debug('Name of stubbed method: ' + stubbedMethodName);
			System.debug('Return type of stubbed method: ' + returnType.getName());

			// You can also use the parameter names and types to determine which method
			// was called.
			for (integer i = 0; i < listOfParamNames.size(); i++) {
				System.debug('parameter name: ' + listOfParamNames.get(i));
				System.debug('  parameter type: ' + listOfParamTypes.get(i).getName());
			}

			// This shows the actual parameter values passed into the stubbed method at runtime.
			System.debug(
				'number of parameters passed into the mocked call: ' + listOfArgs.size()
			);
			System.debug('parameter(s) sent into the mocked call: ' + listOfArgs);

			// Emular lo que queremos que haga el metodo
			System.debug('FrequencyServiceTest DateServiceMock handleMethodCall End');
			return monthToReturn;
		}
	}
}
