@isTest
private with sharing class SpeciesServiceTest {
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
		Assert.areEqual(1, returnedSpecies.size());
		Assert.areEqual(2, returnedSpecies[0].Plants__r.size());
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

		Assert.areEqual(1, returnedSpecies.size());
		Assert.areEqual(speciesName, returnedSpecies[0].Name, 'Its');
		Assert.areEqual(1, returnedPlants.size());
		Assert.areEqual(plantAcquisitionDate, returnedPlants[0].Acquisition_Date__c);
		
		System.debug('SpeciesServiceTest createSpeciesWithPlantCreatesSpeciesAndPlantCorrectly End');
	}
}
