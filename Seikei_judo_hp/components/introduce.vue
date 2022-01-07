<template>
  <div class="content_wall">
    <div class="wrapper clearfix">
      <div class="main">
        <div class="intro_head">
          <h2>成蹊大学体育会柔道部について</h2>
        </div>
        <img  class="introduce_anime_image" src="https://drive.google.com/uc?export=view&id=1eoXjf98kuKlQJm1lmcyIft3YAN84Xfe9" alt="柔道アニメーション画像">
        <div class="intro_body" v-html="introText1Html"></div>
        <div class="intro_head">
          <h2>成蹊大学を志望される方・在学生へ</h2>
        </div>
        <img class="introduce_anime_image" src="https://drive.google.com/uc?export=view&id=1vatTvFANVhh82_e4Wsj6jtvuRPPFcjIj" alt="握手">
        <div class="intro_body" v-html="introText2Html"></div>
      </div>
      <SIDEMENU></SIDEMENU>
    </div>
  </div>
</template>

<script>
import SIDEMENU from "./sidemenu.vue";
import axios from 'axios';

export default {
  components:{
    SIDEMENU
  },
  data() {
    return {
      introText1Html:'',
      introText2Html:''
    };
  },
  created() {
    axios.get(process.env.VUE_APP_INTRODUCE_PATH)
          .then(response => {
            this.introText1Html = '<p>' + response.data.fields.intro1.stringValue + '</p>';
            this.introText2Html = '<p>' + response.data.fields.intro2.stringValue + '</p>';
          });
  }
};
</script>

<style scoped>
.intro_body{
  margin:0 40px;
  font-size:1.5rem;
}

h2{
  margin-left: 20px;
}

.introduce_anime_image{
  width:90%;
  margin:0 30px;
  object-fit: cover;
  height:230px;
  border-radius:15px;
}

.inline_right{
  display: none;
}

.intro_hidden{
  display: block;
}

@media  (min-width: 500px) and (max-width:1000px){
.intro_body{
font-size:1.8rem;
}

.inline_right{
display: inline-block;
font-size:18px;
}
.intro_hidden{
display: none;
}

.introduce_anime_image{
width:90%;
height:200px;
object-fit: cover;
display: inline-block;
}
}

@media (min-width: 500px) and (max-width:801px){
.inline_right{
  display: none;
}

.intro_hidden{
  display: block;
}
}

@media (max-width:499px) {
.intro_body{
  font-size:1.8rem;
}

.inline_right{
  display: none;
}

.intro_hidden{
  display: block;
}

.introduce_anime_image{
  width:88%;
  height:200px;
  object-fit: contain;
  margin-left: 20px;
}
}
</style>
