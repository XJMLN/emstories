<template>
    <main id="app" class="page-wrapper with-sidebar with-navbar" v-if="render" :key="render">
        <mdt-header :darkMode="darkMode" :playerData="playerData" :closeApp="closeApp"></mdt-header>
        <div class="sidebar-overlay"></div>
        <mdt-subheader :playerData="playerData" :switchPage="switchPage" :siteNumber="site"></mdt-subheader>
        <div class="content-wrapper">
            <div class="w-full h-full d-flex" v-if="site == 1" :key="site">
                <mdt-person :citationConfig="citationsData" :switchPage="switchPage" :personSearchError="personSearchError" :loadedPersonData="loadedPersonData" :inputDataPerson="inputDataPerson" :showSpinnerLoad="showSpinnerLoad" :searchPersonData="searchPersonData" :sendNUICallback="sendCallback"></mdt-person>
            </div>
            <div class="w-full h-full d-flex" v-if="site == 2" :key="site">
                <mdt-vehicle :sendNUICallback="sendCallback" :searchVehicleData="searchVehicleData" :showSpinnerLoad="showSpinnerLoad" :inputDataVehicle="inputDataVehicle" :loadedVehicleData="loadedVehicleData"></mdt-vehicle>
            </div>
            <div class="w-full h-full d-flex" v-if="site == 3" :key="site">
                <mdt-citation :addCitationSuccess="addCitationSuccess" :citationsData="citationsData" :inputCitationForm="inputCitationForm" :sendNUICallback="sendCallback" :addCitationError="addCitationError"></mdt-citation>
            </div>
        </div>
    </main>
</template>
<script>
import Header from './components/Header';
import SubHeader from './components/SubHeader';
import PersonPage from './components/PersonPage';
import VehiclePage from './components/VehiclePage';
import CitationPage from './components/CitationPage';
import Nui from './utils/Nui';
const halfmoon = require("halfmoon");
require("halfmoon/css/halfmoon-variables.min.css");
require("./assets/styles/fonts.min.css");
require("./assets/styles/style.min.css");
export default {
    name: "app",
    components:{
        'mdt-header':Header,
        'mdt-subheader':SubHeader,
        'mdt-person':PersonPage,
        'mdt-vehicle':VehiclePage,
        'mdt-citation':CitationPage
    },
    
    data() {
       return {
           render:false,
           site:1,
           darkModeState: "yes",
           personSearchError: false,
           vehicleSearchError: false,
           addCitationError: '',
           addCitationSuccess: false,
           inputDataVehicle: {
               plate:'',
           },
           inputCitationForm: {
               fName:'',
               lName:'',
               citations:{},
               agree:false,
           },
           inputDataPerson: {
               fName:'',
               lName:'',
           },
           citationsData: {},
           showSpinnerLoad: false,
           loadedVehicleData: false,
           loadedPersonData: false,
           searchPersonData: {
                searched:false,
                fName:'',
                lName:'',
                date:'',
                gender:'',
                driverLicenseExpiry:'',
                weaponLicense:'',
                citations:{},
                citationCounter: {}
           },
           searchVehicleData: {
               isStolen:false,
               fName:'',
               lName:'',
               dateOfRegistry:'',
               modelName:'',
               plate:'',
               color:{},
               check:false,
               dateOfCheck:'',
           },
           playerData: {
               rank: '',
               xp: 0,
               name: '',
               departmentID: 5,
               departmentName:'',
               callsign:'',
           }
       }
    },
    destroyed() {
        window.removeEventListener("message", this.listener);
    },
    mounted() {
        document.body.setAttribute('data-set-preferred-mode-onload','true');
        document.body.style.background = "none";
        halfmoon.onDOMContentLoaded();
        this.site = 1;
        this.listener = window.addEventListener(
          'message',
          event => {
              const element = event.data || event.detail;
              if (this[element.type]) {
                  this[element.type](element);
              }
          });
        
    },
    methods: {
        darkMode: function() {
            halfmoon.toggleDarkMode();
        },
        sendPlayerData: function(event) {
            this.playerData = event.data.playerData;
            this.citationsData = event.data.citations;
        },
        renderApp: function(state){
            if (state) {
                document.body.style.background = "";
            } else {
                document.body.style.background = "none";
            }
            this.render = state;
        },
        closeApp: function() {
            Nui.send("closedApp");
            document.body.style.background = "none";
            this.render = false;
        },
        createdCitation: function(data) {
            this.addCitationError = '';
            this.addCitationSuccess = false;
            var retVal = data.data;
            if (retVal == 'fillall') {
                this.addCitationError = "Wypełnij wszystkie obowiązkowe pola.";
            }
            if (retVal == 'notfoundperson') {
                this.addCitationError = "Nie znaleziono osoby o podanym imieniu oraz nazwisku.";
            }
            if (retVal == 'allgood') {
                this.addCitationError = '';
                this.addCitationSuccess = true;
            }
        },
        fetchPersonData: function(data) {
            this.showSpinnerLoad = false;
            this.personSearchError = false;
            var retVal = data.data;
            if (retVal && retVal.fName) {
                this.searchPersonData = retVal;
                this.loadedPersonData = true;
            } else {
                this.personSearchError = true;
            }
        },
        fetchVehicleData: function(data) {
            this.showSpinnerLoad = false;
            this.vehicleSearchError = false;
            var retVal = data.data;
            if (retVal && retVal.fName) {
                this.searchVehicleData = retVal;
                this.loadedVehicleData = true;
            } else {
                this.vehicleSearchError = true;
            }
        },
        sendCallback: function(event, data,type) {
            Nui.send(event,data);
            console.log({eventName: event,passedData: data})
            if (type == 1 || type == 2) {
                this.showSpinnerLoad = true;
            }
            if (type == 1) {
                this.loadedPersonData = false;
            }
            if (type == 2) {
                this.loadedVehicleData = false;
            }
        },
        switchPage: function(pageID) {
            this.site = pageID
        }
    }
}
</script>