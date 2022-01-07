<template>
  <div class="content_wall">
    <div class="wrapper clearfix">
      <div class="main">
        <div class="intro_head">
          <h2>アクセス</h2>
        </div>
        <div class="access_link_frame " style="height:230px;">
          <div class="access_link_top">
            <img src="https://drive.google.com/uc?export=view&id=1JyrG67dKo9aC40ciddDZiUB96V14bX1f">
          </div>
          <div class="access_link_bottom" style="margin-top: -18px;background-color:gray;">
            <a href="https://www.seikei.ac.jp/university/aboutus/accessmap.html">
              <p style="font-size:14px;color:white;">
                西武新宿線
                <br>西武柳沢駅南口より関東バス
                <span class="accept_space"></span>
                <i class="fas fa-external-link-alt" style="color:orange;"></i>
                <br>(吉祥寺駅行)約15分『成蹊学園前』
                <br>武蔵関駅から成蹊大学まで徒歩約20分
              </p>
            </a>
          </div>
        </div>
        <div class="access_link_frame " style="height:230px;">
          <div class="access_link_top">
            <img src="https://drive.google.com/uc?export=view&id=1skxqi0N5vFEq23C0iTPpuYGuhzuBQBTo">
          </div>
          <div class="access_link_bottom" style="margin-top: -18px;background-color:gray;">
            <a href="https://www.seikei.ac.jp/university/aboutus/accessmap.html">
              <p style="font-size:14px;color:white;">
                JR中央線/総武線/京王井の頭線
                <br>吉祥寺駅より徒歩約15分
                <br>吉祥寺駅北口バスのりば1・2番より
                <br>関東バス約5分『成蹊学園前』
                <span class="accept_space"></span>
                <i class="fas fa-external-link-alt" style="color:orange;"></i>
              </p>
            </a>
          </div>
        </div>
        <div class="access_link_frame ">
          <div class="access_link_top">
            <img src="https://drive.google.com/uc?export=view&id=11Cvbxyj-7t7Rz92OszH2Rg4L0nyl6Idp">
          </div>
          <div class="access_link_bottom">
            <a href="https://www.seikei.ac.jp/university/pdf/campusmap.pdf" target="_blank">
              <h2>
                西部室棟3F(柔道場)
                <span class="accept_space"></span>
                <i class="fas fa-external-link-alt" style="color:orange;"></i>
              </h2>
            </a>
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
.intro_head h2{
  margin-left: 20px;
}
.access_link_frame{
  width: 300px;
  height: 200px;
  float: left;
  margin:20px 20px 0 0;
}

.access_link_top img{
  width: 100%;
  height: 140px;
  object-fit: cover;
}

.access_link_bottom{
  margin-top: -5px;
  background-color: white;
  text-align: center;
}

.access_link_bottom a{
  display: block;
  height:95px;
}

.access_link_bottom h2{
  margin: 0;
  color: black;
  padding-top: 20px;
}

@media  (min-width: 500px) and (max-width:1000px){
.access_link_frame{
  margin: 27px;
}
}

@media (min-width: 500px) and (max-width:601px){
.access_link_frame{
  margin: 27px 149px;
}
}

@media (max-width:499px) {
.access_link_frame{
  margin: 0 35px 20px 35px;
}
}
</style>
