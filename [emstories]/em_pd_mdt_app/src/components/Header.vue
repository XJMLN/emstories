<template>
  <fragment>
    <div class="sticky-alerts"></div>
    <nav class="navbar">
      <div class="navbar-content"></div>
      <a href="#" class="navbar-brand"> {{ playerData.departmentName }} </a>
      <div class="navbar-content ml-100">
        <span class="ml-50">
          <font-awesome-icon icon="user"></font-awesome-icon>
        </span>
        <span class="ml-5">{{ playerData.name }}</span>
      </div>
      <div class="navbar-content ml-110">
        <span class="ml-50">
          <font-awesome-icon icon="id-badge"></font-awesome-icon>
        </span>
        <span class="ml-5">{{ playerData.callsign }}</span>
      </div>
      <div class="navbar-content ml-110">
        <span class="ml-50">
          <font-awesome-icon icon="star"></font-awesome-icon>
        </span>
        <span class="ml-5">{{ playerData.rank }}</span>
      </div>
      <div class="navbar-content ml-auto">
        <div class="progress-group">
          <div class="progress w-300 h-25">
            <div
              class="progress-bar bg-success progress-bar-animated"
              role="progressbar"
              style="min-width: 0%;"
              v-bind:style="{width: (playerData.xp/2500)*100 + '%'}"
              aria-value="test"
              aria-valuenow="50"
              aria-valuemin="0"
              aria-valuemax="100"
            ></div>
          </div>
          <span class="progress-group-label">
            <font-awesome-icon
              icon="arrow-up"
              class="text-success font-size-16"
            ></font-awesome-icon>
            {{ playerData.xp }}/2500 XP
          </span>
        </div>
      </div>
      <div class="navbar-content">
        <button
          class="btn btn-action mr-5"
          type="button"
          @click="darkMode"
          aria-label="Włącz dark mode"
        >
          <font-awesome-icon icon="moon"></font-awesome-icon>
        </button>
      </div>
      <div class="navbar-content">
        <button
          class="btn btn-action mr-5"
          type="button"
          @click="closeApp"
          aria-label="Zamknij komputer"
        >
          <font-awesome-icon icon="times" style="color: red;"></font-awesome-icon>
        </button>
      </div>
    </nav>
  </fragment>
</template>

<script>
export default {
  props: {
    darkMode: {
      type: Function,
    },
    closeApp: {
      type: Function,
    },
    playerData: {
        type: Object,
    }
  },
};
</script>