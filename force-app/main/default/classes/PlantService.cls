public with sharing class PlantService {

    public static Map<Id, Species__c> preloadRelatedSpecies(List<Plant__c> newPlants, Map<Id, Plant__c> oldPlantMap) {
		System.debug('PlantService preloadRelatedSpecies Start');
        // Precargar información necesaria de objetos relacionados
        Set<Id> specieIds = new Set<Id>();
        for (Plant__c newPlant : newPlants) {
            if(oldPlantMap != null){
                // Cuando se crea o actualiza una planta (cambiando su fecha riego) --> calcular sig fecha riego
		        // Precargar información necesaria de objetos relacionados
                Plant__c oldPlant = oldPlantMap.get(newPlant.Id);
                if (oldPlant.Last_Watered__c != newPlant.Last_Watered__c) {
                    specieIds.add(newPlant.Species__c);
                }
            }
            else {
                    specieIds.add(newPlant.Species__c);
            }
        }

        // Query precarga objetos relacionados
		List<Species__c> species = [SELECT 	Summer_Watering_Frequency__c, Winter_Watering_Frequency__c
									FROM 	Species__c
									WHERE 	Id IN :specieIds
									WITH 	USER_MODE];
									
		System.debug('PlantService preloadRelatedSpecies End');
		return new Map<Id, Species__c>(species);
	}
    
	public static void populateNextWateringDate(List<Plant__c> newPlants, Map<Id,Plant__c> oldPlantMap) {
		System.debug('PlantService populateNextWateringDate Start');
        
        Map<Id, Species__c> speciesById = preloadRelatedSpecies(newPlants, oldPlantMap);

        // Prepopulate Next Watering Date
        for (Plant__c newPlant : newPlants) {
            // Calcular sig fecha de riego
            // Ver de qué especie es mi planta
            Id specieId             = newPlant.Species__c;
            // Traer objeto especie
            // MAL --> Species__c specie = [SELECT Summer_Watering_Frequency__c FROM Species__c WHERE Id = :specieId];
            Species__c specie       = speciesById.get(specieId); // BIEN!!!
            // Pedir freq de riego para esa especie
            Integer daysToAdd       = FrequencyService.getWateringDays(specie, new DateService());
            // sig fecha riego = ultima fecha riego + dias devueltos
            if(oldPlantMap != null) {
                // Si está cambiando la fecha de riego
                // Trigger.old / Trigger.new / Trigger.oldMap / Trigger.newMap
                // Obtener valor nuevo fecha riego de Trigger.new
                // Obtener valor antiguo fecha riego de Trigger.oldMap
                Plant__c oldPlant = oldPlantMap.get(newPlant.Id);
                if (oldPlant.Last_Watered__c != newPlant.Last_Watered__c) {
                    newPlant.Next_Water__c  = newPlant.Last_Watered__c.addDays(daysToAdd);
                }
            }
            else {
                newPlant.Next_Water__c  = newPlant.Last_Watered__c.addDays(daysToAdd);
            }
        }  
		
        System.debug('PlantService populateNextWateringDate End');
	}
}