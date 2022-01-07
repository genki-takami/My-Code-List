<template>
  <div class="content_wall">
    <div class="wrapper clearfix">
      <div class="main">
        <div class="intro_head">
          <h2>日本武道館</h2>
        </div>
        <img class="introduce_anime_image" src="https://drive.google.com/uc?export=view&id=1Pe7IOHY-SbkZjLDPrzJoQe-2x1V-UMzs" alt="整列">
        <div class="intro_body">
          <p class="explain_image">↑たくさんの道着を着た選手たちがすっぽり入ります</p>
        </div>
        <img class="introduce_anime_image" src="https://drive.google.com/uc?export=view&id=1WgJmJA2qcLfSCrYJ9ST0UNK8pksSdpbN" alt="礼">
        <div class="intro_body">
          <p class="explain_image">↑試合前は礼が基本</p>
        </div>
        <img class="introduce_anime_image" src="https://drive.google.com/uc?export=view&id=1GBLvqs2dqHhv0UYesqxMcISyKa9uiXmX" alt="スクエア">
        <div class="intro_body">
          <p class="explain_image">↑複数の試合が同時に行われ、声援もすごい！</p>
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

.intro_body{
  margin:0 40px;
  font-size:1.5rem;
  font-weight: bold;
}

.introduce_anime_image{
  width:450px;
  margin:0 90px;
  object-fit: cover;
  height:230px;
  border-radius:15px;
}

.explain_image{
  text-align:center;
}

@media  (min-width: 500px) and (max-width:1000px){
.introduce_anime_image{
  margin-left: 160px;
}
}

@media (max-width:499px) {
.introduce_anime_image{
  margin-left: 13px;
  width:343px;
}
}
</style>
