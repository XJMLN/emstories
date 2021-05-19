
<template>
  <fragment>
    <div class="container-fluid">
      <div class="row">
        <div class="col-lg-3">
          <div class="content">
            <h1 class="content-title">Sprawdź Pojazd</h1>
            <form class="w-400 mw-full">
              <div class="form-group">
                <label for="full-name">Numer Rejestracyjny</label>
                <input
                  type="text"
                  class="form-control"
                  id="full-name"
                  placeholder="Numer Rejestracyjny"
                  required="required"
                  v-model="inputDataVehicle.plate"
                />
              </div>
              <a class="btn btn-primary" role="button" @click="searchVehicle"
                ><i class="fa fa-search" aria-hidden="true"></i> Sprawdź
                pojazd</a
              >
            </form>
          </div>
        </div>
        <div class="col-xl" v-if="!showSpinnerLoad && !loadedVehicleData">
          <div class="card" style="margin-top: 10%">
            <h2 class="card-title">Brak informacji o pojeździe</h2>
            <p>Wprowadź dane aby wyszukać pojazd</p>
          </div>
        </div>
        <div class="col-xl" v-if="showSpinnerLoad">
            
          <div
            class="lds-dual-ring"
            style="left: 40%; position: absolute; top: 100%"
          ></div>
        </div>
        <div class="col-lg-9" v-if="loadedVehicleData">
                <div class="content">
                    <h1 class="content-title">Informacje o pojeździe</h1>
                    <div class="container-fluid">
                      <div class="row">
                        <div class="col-xl-6">
                          <h3 class="font-size-14">Model pojazdu</h3>
                        </div>
                        <div class="col-xl-6">
                          <h3 class="font-size-14">{{ searchVehicleData.modelName }}</h3>
                        </div>
                      </div>
                      <div class="row">
                        <div class="col-xl-6">
                          <h3 class="font-size-14">Numer Rejestracyjny</h3>
                        </div>
                        <div class="col-xl-6">
                          <h3 class="font-size-14">{{ searchVehicleData.plate }}</h3>
                        </div>
                      </div>
                      <div class="row">
                        <div class="col-xl-6">
                          <h3 class="font-size-14">Kolor</h3>
                        </div>
                        <div class="col-xl-6">
                          <span class="badge" :style="{ 'background-color': `rgb(${searchVehicleData.color[0]}, ${searchVehicleData.color[1]}, ${searchVehicleData.color[2]})`}">Kolor pojazdu</span>
                        </div>
                      </div>
                      <div class="row">
                        <div class="col-xl-6">
                          <h3 class="font-size-14">Przegląd pojazdu</h3>
                        </div>
                        <div class="col-xl-6">
                          <h3 class="font-size-14 text-success" v-if="searchVehicleData.check">Ważny do {{ searchVehicleData.dateOfCheck }}</h3>
                          <h3 class="font-size-14 text-danger" v-else>Ważny do {{ searchVehicleData.dateOfCheck }}</h3>
                        </div>
                      </div>
                      <div class="row">
                        <div class="col-xl-6">
                          <h3 class="font-size-14">Data rejestracji</h3>
                        </div>
                        <div class="col-xl-6">
                          <h3 class="font-size-14">{{ searchVehicleData.dateOfRegistry }}</h3>
                        </div>
                      </div>
                      <div class="row">
                        <div class="col-xl-6">
                          <h3 class="font-size-14">Właściciel pojazdu</h3>
                        </div>
                        <div class="col-xl-6">
                          <h3 class="font-size-14">{{ searchVehicleData.fName}} {{ searchVehicleData.lName }}</h3>
                        </div>
                      </div>
                      <div class="row">
                        <div class="col-xl-6">
                          <h3 class="font-size-14">Zgłoszenie kradzieży</h3>
                        </div>
                        <div class="col-xl-6">
                          <h3 class="font-size-14 text-danger" v-if="searchVehicleData.isStolen">Pojazd został skradziony</h3>
                          <h3 class="font-size-14 text-success" v-else>Brak zgłoszeń</h3>
                        </div>
                      </div>
                    </div>
                </div>
            </div>
      </div>
    </div>
  </fragment>
</template>
<script>
export default {
props: {
    inputDataVehicle: {
      type: Object,
    },
    sendNUICallback: {
      type: Function,
    },
    searchVehicleData: {
      type: Object,
    },
    loadedVehicleData: {
        type: Boolean,
    },
    showSpinnerLoad: {
      type: Boolean,
      default: false,
    },
  },
  methods: {
    searchVehicle: function () {
      this.sendNUICallback("MDT_VehicleSearch", this.inputDataVehicle,2);
    },
  },
};
</script>