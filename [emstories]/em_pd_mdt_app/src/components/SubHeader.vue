<template>
  <fragment>
<div class="sidebar">
        <div class="sidebar-menu">
          <a href="#" class="sidebar-brand">
            <img :src="require(`@/assets/images/department-${playerData.departmentID}.png`)" style="height: 150px;
            margin-left: 25%;" alt="...">
            
          </a>
          <div class="sidebar-content">
          </div>
          <h5 class="sidebar-title">Baza danych</h5>
          <div class="sidebar-divider"></div>
          <a href="#" class="sidebar-link" :class="{ 'active' : siteNumber === 1}" @click="changeSite(1)"><font-awesome-icon icon="user"></font-awesome-icon> Sprawdź osobę</a>
          <a href="#" class="sidebar-link" :class="{ 'active' : siteNumber === 2}" @click="changeSite(2)"><font-awesome-icon icon="car"></font-awesome-icon> Sprawdź pojazd</a>
          <br />
          <h5 class="sidebar-title"></h5>
          <div class="sidebar-divider"></div>
           <a href="#" class="sidebar-link" :class="{ 'active' : siteNumber === 3}" @click="changeSite(3)"><font-awesome-icon icon="pencil-alt"></font-awesome-icon> Dodaj Wykroczenie</a>
          <a href="#" class="sidebar-link">Wezwania</a>
          <a href="#" class="sidebar-link">Departament</a>
        </div>
      </div>
  </fragment>
</template>
<script>
export default {
  props: {
    playerData: {
        type: Object,
    },
    switchPage: {
        type: Function
    },
    siteNumber: {
      type: Number
    }
  },
  methods: {
      changeSite: function(siteID) {
          this.switchPage(siteID);
      }
  }
};
</script>