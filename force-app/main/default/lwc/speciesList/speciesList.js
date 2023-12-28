import { LightningElement, wire } from "lwc";
import getFilteredSpecies from "@salesforce/apex/SpeciesService.getFilteredSpecies";
import {
  registerRefreshHandler,
  unregisterRefreshHandler
} from "lightning/refresh";
import { refreshApex } from "@salesforce/apex";

export default class SpeciesList extends LightningElement {
  // PROPERTIES, GETTERS & SETTERS
  searchText = "";

  refreshHandlerID;
  connectedCallback() {
    this.refreshHandlerID = registerRefreshHandler(this, this.refreshHandler);
  }
  disconnectedCallback() {
    unregisterRefreshHandler(this.refreshHandlerID);
  }

  // Se ejecuta cuando se reciba el evento de refresh
  refreshHandler() {
    return new Promise((resolve) => {
      // Traer nuevas species de Apex
      refreshApex(this.species);

      resolve(true);
    });
  }

  // WIRE
  @wire(getFilteredSpecies, { searchText: "$searchText" })
  species;

  // METHODS
  handleInputChange(event) {
    const searchText = event.target.value;
    if (searchText.length >= 3 || searchText === "") {
      this.searchText = searchText;
    }
  }
}
