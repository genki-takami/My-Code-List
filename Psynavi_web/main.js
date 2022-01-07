import Vue from 'vue'
import App from './App.vue';
import router from './router';
import store from './store';
import UUID from 'vue-uuid';
import KTabs from '@kevindesousa/vue-k-tabs';
import * as VueGoogleMaps from 'vue2-google-maps';
import VModal from 'vue-js-modal';
import DropdownMenu from '@innologica/vue-dropdown-menu';

Vue.use(VueGoogleMaps, {
  load: {
    key: process.env.VUE_APP_MAP_API_KEY,
    libraries: 'places',
    region: 'JP',
    language: 'ja'
  }
});

Vue.use(UUID);
Vue.use(KTabs);
Vue.use(VModal);
Vue.use(DropdownMenu);

Vue.config.productionTip = false

store.dispatch('autoLogin').then(() => {
  new Vue({
    router,
    store,
    render: h => h(App),
  }).$mount('#app');
});
