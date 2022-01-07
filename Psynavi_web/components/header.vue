<template>
  <div class="header">
    <div class="header_logo">
      <router-link to="/"><i @click="selectNavigation(1)">Psyなび Studio</i></router-link>
    </div>
    <div class="header_caption">
      ようこそ Psyなび Studio の世界へ！文化祭や学園祭などをより
      <br>
      エキサイティングにする「Psyなび」に、君たちのコンテンツを載せよう！
    </div>
    <div class="header_navigation">
      <router-link to="/" class="navigation_tab" :class="{selected:isGuaide}">
        <div class="navigation_text" :class="{selected:isGuaide}" @click="selectNavigation(1)">使い方</div>
      </router-link>
      <router-link to="/editor" class="navigation_tab" :class="{selected:isLogin}">
        <div class="navigation_text" :class="{selected:isLogin}" @click="selectNavigation(2)">ログイン</div>
      </router-link>
      <router-link to="/user_policy" class="navigation_tab" :class="{selected:isUserPolicy}">
        <div class="navigation_text" :class="{selected:isUserPolicy}" @click="selectNavigation(3)">利用規約</div>
      </router-link>
      <router-link to="/privacy_policy" class="navigation_tab" :class="{selected:isPrivacyPolicy}">
        <div class="navigation_text" :class="{selected:isPrivacyPolicy}" @click="selectNavigation(4)">個人情報保護指針</div>
      </router-link>
    </div>
    <DropdownMenu
      v-model="show"
      :right="right"
      :hover="hover"
      :interactive="interactive">
      <button class="dropdown-toggle"><i class="fas fa-chevron-circle-down"></i></button>
      <div slot="dropdown">
        <router-link to="/" class="dropdown-item" @click="selectNavigation(1)">使い方</router-link>
        <router-link to="/editor" class="dropdown-item" @click="selectNavigation(2)">ログイン</router-link>
        <router-link to="/user_policy" class="dropdown-item" @click="selectNavigation(3)">利用規約</router-link>
        <router-link to="/privacy_policy" class="dropdown-item" @click="selectNavigation(4)">個人情報保護指針</router-link>
      </div>
    </DropdownMenu>
  </div>
</template>

<script>
import Vuex from '../store';
import DropdownMenu from '@innologica/vue-dropdown-menu';
export default {
  components:{
    DropdownMenu
  },
  data(){
    return {
      isGuaide:true,
      isLogin:false,
      isUserPolicy:false,
      isPrivacyPolicy:false,
      show:false,
      right:false,
      hover:false,
      interactive:false
    };
  },
  created(){
    let position = Vuex.getters.headerPosition;
    this.selectNavigation(position);
  },
  methods:{
    selectNavigation(arg){
      if (arg == 1) {
        this.isGuaide = true;
        this.isLogin = this.isUserPolicy = this.isPrivacyPolicy = false;
        this.$store.dispatch('changeHeaderPosition',arg);
      } else if (arg == 2) {
        this.isLogin = true;
        this.isGuaide = this.isUserPolicy = this.isPrivacyPolicy = false;
        this.$store.dispatch('changeHeaderPosition',arg);
      } else if (arg == 3) {
        this.isUserPolicy = true;
        this.isLogin = this.isGuaide = this.isPrivacyPolicy = false;
        this.$store.dispatch('changeHeaderPosition',arg);
      } else if (arg == 4) {
        this.isPrivacyPolicy = true;
        this.isLogin = this.isUserPolicy = this.isGuaide = false;
        this.$store.dispatch('changeHeaderPosition',arg);
      }
    }
  }
};
</script>

<style scoped>
.header{
  background-color:white;
  position: fixed;
  top:0;
  height: 80px;
  z-index: 10;
  min-width: 1000px;
  width: 100%;
  border-bottom: 1px solid lightgray;
  transition: all 0.15s;
}

.header_logo{
  display: inline-block;
  font-size: 44px;
  font-weight: bold;
  margin-left: 30px;
  line-height: 80px;
  background: -webkit-linear-gradient(45deg, #0066FF, #FF66FF 80%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  padding-right: 3px;
}

.header_logo a{
  color: black;
}

.header_caption{
  display: inline-block;
  color: rgba(39, 40, 44, 0.65);
  font-size: 12px;
  margin: 0 0 0 14px;
}

.header_navigation{
  display: inline-flex;
  float:right;
  margin-right: 30px;
  height: 101%;
}

.navigation_tab{
  padding: 0 20px;
  height: 100%;
  align-items: center;
  text-decoration: none;
  transition: 0.15s;
  line-height: 80px;
}

.navigation_tab:hover{
  background-color: rgb(22, 125, 255);
}

.navigation_text{
  font-size: 15px;
  color: black;
  font-weight: bold;
}

.navigation_text:hover{
  color:white;
}

.selected{
  background-color: rgb(22, 125, 255);
  color: white;
}

.dropdown, .dropleft, .dropright, .dropup {
  display:none;
  margin-left:15px;
}

@media (max-width:1269px) {
.header_caption{
  display: none;
}
}

@media (max-width:969px){
.header_logo{
  font-size:30px;
}

.header_navigation{
  display: inline-block;
  width:68%;
  height:80px;
}

.navigation_tab{
  display: inline-block;
}
}

@media (max-width:734px) {
.header_navigation{
  display:none;
}

.dropdown, .dropleft, .dropright, .dropup {
  display:inline-block;
}

.dropdown-toggle{
  border:none;
  font-size:3rem;
  background-color: white;
  color:deeppink;
}

.dropdown-item{
  display:table;
  background-color:deeppink;
  color:white;
  font-size:2rem;
  font-weight: bold;
  padding:10px;
  width:180px;
}

/*translate fade (top to down)*/
.translate-fade-down-enter-active, .translate-fade-down-leave-active {
  transition: all 250ms;
  transition-timing-function: cubic-bezier(.53,2,.36,.85);
}
.translate-fade-down-enter, .translate-fade-down-leave-active {
  opacity: 0;
}
.translate-fade-down-enter, .translate-fade-down-leave-to {
  position: absolute;
}

.translate-fade-down-enter {
  transform: translateY(-10px);
}
.translate-fade-down-leave-active {
  transform: translateY(10px);
}
}

@media (max-width:439px) {
.header_logo{
  font-size:20px;
  margin-left: 10px;
}
}

@media (max-width:360px){
.dropdown-item{
  font-size:1.4rem;
  width:137px;
}
}
</style>
