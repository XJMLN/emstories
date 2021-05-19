
<template>
  <fragment>
    <div class="container-fluid">
      <div class="row">
        <div class="col-lg-3">
          <div class="content">
            <h1 class="content-title">Sprawdź osobę</h1>
            <form class="w-400 mw-full">
              <div class="form-group">
                <label for="full-name">Imię</label>
                <input
                  type="text"
                  class="form-control"
                  id="full-name"
                  placeholder="Imię"
                  required="required"
                  v-model="inputDataPerson.fName"
                />
              </div>
              <div class="form-group">
                <label for="full-name">Nazwisko</label>
                <input
                  type="text"
                  class="form-control"
                  id="full-name"
                  placeholder="Nazwisko"
                  required="required"
                  v-model="inputDataPerson.lName"
                />
              </div>
              <a class="btn btn-primary" role="button" @click="searchPerson"
                ><font-awesome-icon icon="search"></font-awesome-icon> Sprawdź
                osobę</a
              >
            </form>
          </div>
        </div>
        <div
          class="col-xl"
          v-if="!showSpinnerLoad && !loadedPersonData && !personSearchError"
        >
          <div class="card" style="margin-top: 10%">
            <h2 class="card-title">Brak informacji o osobie</h2>
            <p>Wprowadź dane aby wyszukać osobę</p>
          </div>
        </div>
        <div
          class="col-xl"
          v-if="!showSpinnerLoad && !loadedPersonData && personSearchError"
        >
          <div class="card" style="margin-top: 10%">
            <h2 class="card-title">Nie znaleziono podanej osoby</h2>
            <p>Sprawdź poprawność wpisanych danych i spróbuj ponownie</p>
          </div>
        </div>
        <div class="col-xl" v-if="showSpinnerLoad">
          <div
            class="lds-dual-ring"
            style="left: 40%; position: absolute; top: 100%"
          ></div>
        </div>
        <div
          class="col-lg-3"
          v-if="loadedPersonData && searchPersonData && searchPersonData.fName"
        >
          <div class="content">
            <h1 class="content-title">Informacje o osobie</h1>
            <div class="container-fluid">
              <div class="row">
                <div class="col-xl-6">
                  <h3 class="font-size-14">Imię</h3>
                </div>
                <div class="col-xl-6">
                  <h3 class="font-size-14">{{ searchPersonData.fName }}</h3>
                </div>
              </div>
              <div class="row">
                <div class="col-xl-6">
                  <h3 class="font-size-14">Nazwisko</h3>
                </div>
                <div class="col-xl-6">
                  <h3 class="font-size-14">{{ searchPersonData.lName }}</h3>
                </div>
              </div>
              <div class="row">
                <div class="col-xl-6">
                  <h3 class="font-size-14">Data urodzenia</h3>
                </div>
                <div class="col-xl-6">
                  <h3 class="font-size-14">{{ searchPersonData.date }}</h3>
                </div>
              </div>
              <div class="row">
                <div class="col-xl-6">
                  <h3 class="font-size-14">Płeć</h3>
                </div>
                <div class="col-xl-6">
                  <h3
                    class="font-size-14"
                    v-if="searchPersonData.gender == 'male'"
                  >
                    Mężczyzna
                  </h3>
                  <h3 class="font-size-14" v-else>Kobieta</h3>
                </div>
              </div>
              <div class="row" v-if="searchPersonData.suspect != ''">
                <div class="col-xl-6">
                  <h3 class="font-size-14">Poszukiwany listem gończym</h3>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div
          class="col-lg-6"
          v-if="
            loadedPersonData &&
            searchPersonData
          "
        >
          <div class="content">
            <h1 class="content-title">Wypis wykroczeń osoby</h1>
            <div class="container-fluid">
              <div class="table-responsive" v-if="searchPersonData.citations.length>0">
                <span class="badge-group mr-5" role="group" aria-label="Wykroczenie" v-for="(citation, i) in searchPersonData.citationCounter" :key="i">
                  <a role='button' class="badge badge-secondary badge-pill"> {{ citationConfig[i].citation_desc }}</a>
                  <a role='button' class="badge bg-dark badge-pill text-light">x{{ citation }}</a>
                </span>
              </div>
              <h4 v-else>Brak wykroczeń w bazie danych</h4>
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-lg-3" v-if="loadedPersonData && searchPersonData && searchPersonData.fName">
           <div class="content">
              <h1 class="content-title">Dostępne akcje w komputerze</h1>
              <div class="container-fluid">
               <a class="btn btn-primary" role="button" @click="changeSite(3)"
                  ><font-awesome-icon icon="pencil-alt"></font-awesome-icon> Dodaj
                  wykroczenie</a
                >
              </div>
            </div>
        </div>
        <div class="col-lg-6" v-if="loadedPersonData && searchPersonData && searchPersonData.fName">
           <div class="content">
              <h1 class="content-title">Znaczenie kolorów wykroczenia</h1>
              <div class="container-fluid">
                <a role='button' class="badge badge-success badge-pill mb-5 mr-5">Wykroczenie typu niskie</a>
                <a role='button' class="badge badge-secondary badge-pill mb-5 mr-5">Wykroczenie typu średnie</a>
                <a role='button' class='badge badge-danger badge-pill mb-5'>Wykroczenie typu wysokie</a>
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
    citationConfig: {
      type: Object
    },
    inputDataPerson: {
      type: Object,
      default: function () {
        return { fName: "", lName: "" };
      },
    },
    sendNUICallback: {
      type: Function,
    },
    searchPersonData: {
      type: Object,
    },
    personSearchError: {
      type: Boolean,
    },
    loadedPersonData: {
      type: Boolean,
    },
    showSpinnerLoad: {
      type: Boolean,
      default: false,
    },
	switchPage: {
        type: Function
    }
  },
  methods: {
    searchPerson: function () {
      this.sendNUICallback("MDT_PersonSearch", this.inputDataPerson, 1);
    },
	changeSite: function(siteID) {
          this.switchPage(siteID);
      }
  },
};
</script>