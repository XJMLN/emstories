<template>
  <fragment>
    <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12">
          <div class="content">
            <h1 class="content-title">Lista policjantów na służbie</h1>
            <div class="container-fluid">
              <table class="table">
                <thead>
                  <tr>
                    <th>Nick gracza</th>
                    <th>Ranga</th>
                    <th>Numer odznaki</th>
                  </tr>
                </thead>
                <tbody>
                  <tr class="table-primary" v-for="(user, i) in departmentData" :key="i">
                    <th>{{ user.name }}</th>
                    <td>{{ user.rankName }}</td>
                    <td>{{ user.callsign }}</td>
                  </tr>
                </tbody>
              </table>
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
    departmentData: {
      type: Object,
    },
  },
  methods: {},
};
</script>