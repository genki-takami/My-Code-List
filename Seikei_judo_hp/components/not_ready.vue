<template>
  <div class="content_wall">
    <div class="wrapper clearfix">
      <div class="main">
        <div class="intro_head">
          <h2>現在準備中！申し訳ありません。</h2>
        </div>
        <div class="sorry_image ">
          <img src="https://i.gyazo.com/aa5e947913d1e68d0175cc51c5acd351.png" alt="準備中">
        </div>
      </div>
      <SIDEMENU></SIDEMENU>
    </div>
  </div>
</template>

<script>
import SIDEMENU from "./sidemenu.vue";
export default {
  components:{
    SIDEMENU
  }
};
</script>

<style scoped>
h2{
  margin-left: 20px;
}

.sorry_image img{
  width:95%;
  height:400px;
  object-fit: cover;
}

@media  (min-width: 500px) and (max-width:1000px){
.sorry_image img{
  width: 90%;
  height: 475px;
  margin: 0 38px;
  object-fit: cover;
}
}

@media (max-width:499px) {
.sorry_image img{
  width:90%;
  height:230px;
  margin:0 0 200px 16px;
  object-fit: cover;
}
}
</style>
