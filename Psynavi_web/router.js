import Vue from 'vue';
import Router from 'vue-router';
import Vuex from './store';
import Top from './components/top.vue';
import Login from './components/login.vue';
import Editor from './components/editor.vue';
import UserPolicy from './components/user_policy.vue';
import PrivacyPolicy from './components/privacy_policy.vue';

Vue.use(Router);

export default new Router({
  mode: 'history',
  scrollBehavior (to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { x: 0, y: 0 }
    }
  },
  routes: [
    {
      path:'/',
      component:Top
    },
    {
      path:'/login',
      component:Login,
      beforeEnter(to, from, next){
        if (Vuex.getters.idToken) {
          next('/editor');
        }else {
          next();
        }
      }
    },
    {
      path:'/editor',
      component:Editor,
      beforeEnter(to, from, next){
        if (Vuex.getters.idToken) {
          next();
        }else {
          next('/login');
        }
      }
    },
    {
      path:'/user_policy',
      component:UserPolicy
    },
    {
      path:'/privacy_policy',
      component:PrivacyPolicy
    },
    {
      path:'*',
      redirect:'/'
    }
  ]
});
