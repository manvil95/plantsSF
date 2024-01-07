/***************************************************************************************************
@author		    : Alba Rivas
@created        : 2021
@modifiedBy 	: Manu Villen
@version        : 2.0
@description	: ___Clase test para testear la clase SpeciesService___
***************************************************************************************************/
@isTest
private with sharing class SpeciesServiceTest {

	/***************************************************************************************************
	@author		    : Alba Rivas
	@created        : 2021
	@modifiedBy 	: Manu Villen
	@version        : 2.0
	@description	: ___Método test para el método getFilteredSpecies con un parámetro de entrada vacío___
	***************************************************************************************************/
	@isTest
	static void getFilteredSpeciesSearchTextIsAnEmptyString() {
		System.debug('SpeciesServiceTest getFilteredSpeciesSearchTextIsAnEmptyString Start');
		// GIVEN
		Integer speciesCount = 6;
		List<Species__c> speciesToInsert = new List<Species__c>();
		for (Integer i = 0; i < speciesCount; i++) {
			Species__c species = new Species__c(Name = 'Species ' + i);
			speciesToInsert.add(species);
		}

		insert speciesToInsert;

		// WHEN
		Test.startTest();
		List<Species__c> returnedSpecies = SpeciesService.getFilteredSpecies('');
		Test.stopTest();

		// THEN
		System.assertEquals(speciesCount, returnedSpecies.size(), 'The expected size is 6');
		System.debug('SpeciesServiceTest getFilteredSpeciesSearchTextIsAnEmptyString End');
	}

	@isTest
	static void getSpeciesWithPlantsReturnsPlantsAndSpeciesCorrectly() {
		System.debug('SpeciesServiceTest getSpeciesWithPlantsReturnsPlantsAndSpeciesCorrectly Start');
		// GIVEN
		new TestDataFactory().createSpecies();

		// WHEN
		Test.startTest();
		List<Species__c> returnedSpecies = SpeciesService.getSpeciesWithPlants();
		Test.stopTest();

		// THEN
		Assert.areEqual(1, returnedSpecies.size(), 'El size esperado de returnedSpecies es 1');
		Assert.areEqual(2, returnedSpecies[0].Plants__r.size(), 'El size esperado de Plant__r es 2');
		System.debug('SpeciesServiceTest getSpeciesWithPlantsReturnsPlantsAndSpeciesCorrectly End');

	}

	@isTest
	static void createSpeciesWithPlantCreatesSpeciesAndPlantCorrectly() {
		System.debug('SpeciesServiceTest createSpeciesWithPlantCreatesSpeciesAndPlantCorrectly Start');
		// GIVEN
		String speciesName = 'Species1';
		Date plantAcquisitionDate = System.today();

		// WHEN
		Test.startTest();
		SpeciesService.createSpeciesWithPlant(speciesName, plantAcquisitionDate);
		Test.stopTest();
		// THEN
		List<Species__c> returnedSpecies = [SELECT Name FROM Species__c];
		List<Plant__c> returnedPlants = [SELECT Acquisition_Date__c FROM Plant__c];

		Assert.areEqual(1, returnedSpecies.size(), 'El size esperado de returnedSpecies es 1');
		Assert.areEqual(speciesName, returnedSpecies[0].Name, 'Se espera el mismo nombre de Specie');
		Assert.areEqual(1, returnedPlants.size(), 'El size esperado de returnedPlants es 1');
		Assert.areEqual(plantAcquisitionDate, returnedPlants[0].Acquisition_Date__c, 'La fecha de adquisición esperada es ' + plantAcquisitionDate);
		
		System.debug('SpeciesServiceTest createSpeciesWithPlantCreatesSpeciesAndPlantCorrectly End');
	}
}
