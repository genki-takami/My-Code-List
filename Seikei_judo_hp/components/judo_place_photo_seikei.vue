<template>
  <div class="content_wall">
    <div class="wrapper clearfix">
      <div class="main">
        <div class="intro_head">
          <h2>成蹊大学柔道場</h2>
        </div>
        <div>
          <img class="introduce_anime_image" src="https://drive.google.com/uc?export=view&id=11Cvbxyj-7t7Rz92OszH2Rg4L0nyl6Idp" alt="昼道場">
          <div class="intro_body"><!--PC用-->
            <p class="explain_image">↑昼の柔道場</p>
          </div>
        </div>
        <div>
          <img class="introduce_anime_image" src="https://drive.google.com/uc?export=view&id=1YE8ToNNW-v3NEwfWe0eB3Oa5IDLx5_Ja" alt="夜道場">
          <div class="intro_body">
            <p class="explain_image">↑夜間の柔道場</p>
          </div>
        </div>
        <div>
          <img class="introduce_anime_image" src="https://drive.google.com/uc?export=view&id=1y3JqisS1Yt7dlik2sSsCMYZGhZXvs1AL" alt="綱トレーニング">
          <div class="intro_body">
            <p class="explain_image">↑複数ある綱で練習中</p>
          </div>
        </div>
        <div>
          <img class="introduce_anime_image" src="https://drive.google.com/uc?export=view&id=1W5Awf2y4UwpE75yEjTP-7tFiUooPQ74S" alt="トレーニングルーム">
          <div class="intro_body">
            <p class="explain_image">↑トレーニングルームはとても機材が充実している</p>
          </div>
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
