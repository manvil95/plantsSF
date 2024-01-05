/***************************************************************************************************
@author		    : Alba Rivas
@created        : 2021
@modifiedBy 	: Manu Villen
@version        : 2.0
@description	: ___Clase para gestionar todos los procesos pertenecientes al Custom Object Species__c___
***************************************************************************************************/
public with sharing class SpeciesService {

	@AuraEnabled(cacheable=true)
	public static List<Species__c> getFilteredSpecies(String searchText) {
		System.debug('SpeciesService getFilteredSpecies Start');
		String likeValue = '%' + searchText + '%';

		List<Species__c> species = [SELECT 	Id, 
											Name, 
											Description__c, 
											Image_URL__c, 
											Location__c, 
											Image_Name__c
									FROM 	Species__c
									WHERE 	Name LIKE :likeValue
									WITH 	USER_MODE
									ORDER BY Name
									];
		System.debug('SpeciesService getFilteredSpecies End');
		return species;
	}
	
	@AuraEnabled(cacheable=true)
	public static List<Species__c> getSpeciesWithPlants() {
		System.debug('SpeciesService getSpeciesWithPlants Start');
		System.debug('SpeciesService getSpeciesWithPlants End');
		return [SELECT 	Name, 
						(SELECT Name FROM Plants__r)
				FROM 	Species__c
				WITH 	USER_MODE
				ORDER BY Name];
	}

	@AuraEnabled
	public static void createSpeciesWithPlant(
		String 	speciesName,
		Date 	plantAcquisitionDate
	) {
		System.debug('SpeciesService createSpeciesWithPlant Start');
		// Validar que los parametros no son nulos...

		// Comprobar que la especie no existe ya - SOQL

		// Crear species rellenando sus campos obligatorios
		Species__c newSpecies = new Species__c(

			Name 						= speciesName,
			Summer_Watering_Frequency__c = 'Daily',
			Winter_Watering_Frequency__c = 'Weekly',
			// ! Chequear si puede influir en los flujos de creación y demás
			Summer_Fertilization_Frequency__c = 'Weekly',
			Winter_Fertilization_Frequency__c = 'Weekly'
		);

		try{
			System.Database.insert(newSpecies);
		} catch(Exception e) {
			System.debug(e.getMessage());
		}

		// Crear planta, asociada con esa especie
		Plant__c newPlant = new Plant__c(
			Acquisition_Date__c = plantAcquisitionDate,
			Species__c 			= newSpecies.Id,
			Last_Watered__c 	= System.today(),
			Last_Fertilized__c 	= System.today()
		);
		
		try{
			System.Database.insert(newPlant);
		} catch(Exception e) {
			System.debug(e.getMessage());
		}
		System.debug('SpeciesService createSpeciesWithPlant End');
	}
}
