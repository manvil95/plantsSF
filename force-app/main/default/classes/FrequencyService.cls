/***************************************************************************************************
@author			: Alba Rivas
@created     	: 2021
@modifiedBy 	 
@version     	: 1.0
@description	: ___Clase para gestionar la frecuencia de regado y fertilización de las plantas___
***************************************************************************************************/
public inherited sharing class FrequencyService {
	static Map<String, Integer> daysByFrequency = new Map<String, Integer>();

	static {
		daysByFrequency.put('Daily', 1);
		daysByFrequency.put('Twice per week', 3);
		daysByFrequency.put('Weekly', 7);
		daysByFrequency.put('Every other week', 15);
		daysByFrequency.put('Monthly', 30);
		daysByFrequency.put('Every three months', 90);
		daysByFrequency.put('Not needed', 999);
	}

	static Set<Integer> summerMonths = new Set<Integer>{ 5, 6, 7, 8, 9 };

	/***************************************************************************************************
	@author			: Alba Rivas
	@created     	: 2021
	@modifiedBy 	 
	@version     	: 1.0
	@description	: ___Método que devuelve la frecuencia en días de regadío___
	***************************************************************************************************/
	public static Integer getWateringDays(Species__c specie, DateService dateServiceInstance) {
		System.debug('FrequencyService getWatering Days Start');
		Integer month = dateServiceInstance.getCurrentMonth();
		System.debug('FrequencyService getWatering Days End');
		
		if (summerMonths.contains(month)) {
			return daysByFrequency.get(specie.Summer_Watering_Frequency__c);
		} else {
			return daysByFrequency.get(specie.Winter_Watering_Frequency__c);
		}
	}
	/***************************************************************************************************
	@author			: Manu Villen
	@created     	: 30/12/2023
	@modifiedBy 	 
	@version     	: 1.0
	@description	: ___Método que devuelve la frecuencia en días de fertilización___
	***************************************************************************************************/
	public static Integer getFertilizationDays(Species__c specie, DateService dateServiceInstance) {
		System.debug('FrequencyService getFertilizationDays Start');
		Integer month = dateServiceInstance.getCurrentMonth();
		System.debug('FrequencyService getFertilizationDays End');
		
		if (summerMonths.contains(month)) {
			return daysByFrequency.get(specie.Summer_Fertilization_Frequency__c);
		} else {
			if(specie.Winter_Fertilization_Frequency__c == 'Not needed' && specie.Summer_Fertilization_Frequency__c != 'Not needed'){
				return Date.newInstance(Date.today().year(), 6, 21).daysBetween(Date.today());
			}
			else{
				return daysByFrequency.get(specie.Winter_Fertilization_Frequency__c);
			}
		}
	}
}
