import Vue from 'vue';
import Router from 'vue-router';
import Top from './components/top.vue';
import Introduce from './components/introduce.vue';
import Members from './components/members.vue';
import Coach_trainer from './components/coach_trainer.vue';
import Evaluation from './components/evaluation.vue';
import Schedule from './components/schedule.vue';
import Access from './components/access.vue';
import Console from './components/console.vue';
import Edit from './components/edit.vue';
import Judo_history from './components/judo_history.vue';
import Judo_place_photo_seikei from './components/judo_place_photo_seikei.vue';
import Judo_place_photo_budokan from './components/judo_place_photo_budokan.vue';
import Login from './components/login.vue';
import Not_ready from './components/not_ready.vue';
import store from './store';
import Match_index from './components/match_index';
import Tokyo_student_group from './components/tokyo_student_group';
import Four_fresh from './components/four_fresh';
import Tokyo_student_personal from './components/tokyo_student_personal';
import Four_main from './components/four_main';
import Suginami from './components/suginami';
import Tokyo_second from './components/tokyo_second';
import Tokyo_open from './components/tokyo_open';
import Rikou_match from './components/rikou_match';
import Coach_interview from './components/coach_interview';
import Archive2019 from './components/archive_2019.vue';
import Archive2020 from './components/archive_2020.vue';
import Analytics_by_member from './components/analytics_by_member.vue';
import Archive_others from './components/archive_others.vue';

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
      path:'/introduce',
      component:Introduce
    },
    {
      path:'/members',
      component:Members
    },
    {
      path:'/coach_trainer',
      component:Coach_trainer
    },
    {
      path:'/evaluation',
      component:Evaluation,
      children:[
        {path:'index',component:Match_index},
        {path:'tokyo_student_group',component:Tokyo_student_group},
        {path:'four_fresh',component:Four_fresh},
        {path:'tokyo_student_personal',component:Tokyo_student_personal},
        {path:'four_main',component:Four_main},
        {path:'suginami',component:Suginami},
        {path:'tokyo_second',component:Tokyo_second},
        {path:'tokyo_open',component:Tokyo_open},
        {path:'rikou_match',component:Rikou_match}
      ]
    },
    {
      path:'/schedule',
      component:Schedule
    },
    {
      path:'/access',
      component:Access
    },
    {
      path:'/not_ready',
      component:Not_ready
    },
    {
      path:'/console',
      component:Console,
      children:[
        {
          path:'login',
          component:Login,
          beforeEnter(to, from, next) {
            if (store.getters.idToken) {
              next('/console/edit');
            } else {
              next();
            }
          }
        },
        {
          path:'edit',
          component:Edit,
          beforeEnter(to, from, next) {
            if (store.getters.idToken) {
              next();
            } else {
              next('/console/login');
            }
          }
        }
      ]
    },
    {
      path:'/judo_history',
      component:Judo_history
    },
    {
      path:'/judo_place_photo_seikei',
      component:Judo_place_photo_seikei
    },
    {
      path:'/judo_place_photo_budokan',
      component:Judo_place_photo_budokan
    },
    {
      path:'/coach_interview',
      component:Coach_interview
    },
    {
      path:'/archive_2019',
      component:Archive2019
    },
    {
      path:'/archive_2020',
      component:Archive2020
    },
    {
      path:'/archive_others',
      component:Archive_others
    },
    {
      path:'/analytics_by_member',
      component:Analytics_by_member
    },
    {
      path:'*',
      redirect:'/'
    }
  ]
});
