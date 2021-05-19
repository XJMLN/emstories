<template>
  <fragment>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="content">
                    <h1 class="content-title">Dodawanie wykroczenia</h1>
                    <div class="container-fluid">
                        <form class="w-400 mw-full">
 
  <div class="form-group">
    <label for="fName" class="required">Imię</label>
    <input type="text" class="form-control" id="fName" placeholder="Imię" required="required" v-model="inputCitationForm.fName">
  </div>
    <div class="form-group">
    <label for="lName" class="required">Nazwisko</label>
    <input type="text" class="form-control" id="lName" placeholder="Nazwisko" required="required" v-model="inputCitationForm.lName">
  </div>
  <div class="form-group">
    <label for="citations" class="required">Wykroczenia</label>
    <select class="form-control" id="citations" multiple="multiple" required="required" size="5" v-model="inputCitationForm.citations">
        <option v-for="(citation, i) in citationsData" :value="i" :key="i"> {{ citation.citation_desc }}</option>
    </select>
     <div class="form-text">
      Możesz wybrać kilka wykroczeń przytrzymując lewy <kbd>CTRL</kbd>
    </div>
  </div>

  <div class="form-group">
    <div class="custom-checkbox">
      <input type="checkbox" id="agree" v-model="inputCitationForm.agree">
      <label for="agree">Potwierdzam nałożenie mandatu.</label>
    </div>
  </div>
  <div class="form-group">
    <div class="alert alert-danger" role="alert" v-if="addCitationError!=''">
      <h4 class="alert-heading"></h4>
      {{ addCitationError }}
    </div>
  </div>
  <div class="alert alert-success" role="alert" v-if="addCitationSuccess && addCitationError==''">
    <h4 class="alert-heading"></h4>
    Wykroczenie zostało zapisane w systemie.
  </div>
  <br>
  <a class="btn btn-primary" role="button" @click="addCitation">Dodaj wykroczenie</a>
</form>
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
    citationsData: {
      type: Object,
    },
    inputCitationForm: {
        type: Object
    },
    sendNUICallback: {
        type: Function
    },
    addCitationError: {
      type: String
    },
    addCitationSuccess: {
      type: Boolean
    }
  },
  methods: {
      addCitation: function() {
          this.inputCitationForm.citations = JSON.stringify(this.inputCitationForm.citations)
          this.sendNUICallback("MDT_addCitation",this.inputCitationForm);
      }
  },
};
</script>