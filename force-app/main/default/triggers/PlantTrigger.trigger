trigger PlantTrigger on Plant__c(before insert, before update) {
  System.debug('trigger PlantTrigger run Start');
  new PlantTriggerHandler().run();
  System.debug('trigger PlantTrigger run End');
  // handler.handleBeforeEvents(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);

  //   /* Before Insert */
  // 	if (Trigger.isInsert && Trigger.isBefore) {
  // 		handler.handleBeforeInsert(Trigger.new);
  // 	} else if (Trigger.isUpdate && Trigger.isBefore) {
  // 		/* Before Update */
  // 		handler.handleBeforeUpdate(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap
  // 		);
  // 	}
}
