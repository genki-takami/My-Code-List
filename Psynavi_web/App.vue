<template>
  <div id="app">
    <div class="content_world">
      <HEADER></HEADER>
      <router-view></router-view>
      <FOOTER></FOOTER>
    </div>
  </div>
</template>

<script>
import HEADER from "./components/header.vue";
import FOOTER from "./components/footer.vue";

export default {
  components:{
    HEADER,
    FOOTER
  }
}
</script>

<style>
#app {
  font-family: "Hiragino Kaku Gothic ProN",sans-serif,'Gulim';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

*,*::after,*::before{
  box-sizing: border-box;
}

a:link,a:visited,a:hover,a:active{
  color:#d03c56;
  text-decoration: none;
}

.content_world{
  min-height: 100vh;
}

ul{
  padding-left: 0;
}

.modal_guaide_btn{
  font-size:1.8rem;
  color:black;
  font-weight:bold;
  margin-left:8rem;
  cursor:pointer;
}

.modal_guaide_btn:hover{
  color:orange;
}
</style>
