public with sharing class PlantTriggerHandler extends TriggerHandler {

	private List<Plant__c> 		oldPlants;
	private List<Plant__c> 		newPlants;
	private Map<Id, Plant__c> 	oldPLantMap;
	private Map<Id, Plant__c> 	newPlantMap;

	public PlantTriggerHandler() {
		this.oldPlants		= Trigger.old;
		this.newPlants		= Trigger.new;
		this.oldPLantMap	= (Map<Id,Plant__c>) Trigger.oldMap;
		this.newPlantMap	= (Map<Id,Plant__c>) Trigger.newMap;
	}

	public override void beforeInsert() {
		System.debug('PlantTriggerHandler beforeInsert Start');
		
		PlantService.populateNextWateringDate(newPlants, null);
		PlantService.populateNextFertilizationDate(newPlants, null);
		
		System.debug('PlantTriggerHandler beforeInsert End');
	}

	public override void beforeUpdate() {
		System.debug('PlantTriggerHandler beforeUpdate Start');
		
		PlantService.populateNextWateringDate(newPlants, oldPlantMap);
		PlantService.populateNextFertilizationDate(newPlants, oldPlantMap);
		
		System.debug('PlantTriggerHandler beforeUpdate End');
	}
}
