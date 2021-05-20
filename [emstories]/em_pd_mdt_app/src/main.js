import Vue from 'vue';
import { Plugin } from 'vue-fragment';
import { library } from '@fortawesome/fontawesome-svg-core';
import { faUser, faIdBadge, faStar, faArrowUp, faMoon, faTimes, faPencilAlt, faSearch, faCar, faBuilding} from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon} from '@fortawesome/vue-fontawesome';
import App from './App.vue';


library.add(faUser, faIdBadge,faStar,faArrowUp,faMoon,faTimes,faPencilAlt, faSearch, faCar, faBuilding);
Vue.use(Plugin);
Vue.config.productionTip = true;
Vue.config.devtools = true;
Vue.component('font-awesome-icon', FontAwesomeIcon);
new Vue({
    render: h => h(App),
}).$mount('#app');
