import Vue from 'vue'
import App from './App.vue';
import axios from 'axios';
import router from './router';
import store from './store';
import LightTimeline from 'vue-light-timeline';
import VueAgile from 'vue-agile';
import VModal from 'vue-js-modal';
import VueScrollTo from 'vue-scrollto';

Vue.config.productionTip = false

Vue.use(LightTimeline);
Vue.use(VueAgile);
Vue.use(VModal);
Vue.use(VueScrollTo);

axios.defaults.baseURL = process.env.VUE_APP_API_BASE_URL;

store.dispatch('autoLogin').then(() => {
  new Vue({
    router,
    store,
    render: h => h(App)
  }).$mount('#app');
});
