<template>
  <div class="sidemenu side_extra">
    <h2 class="heading">INFORMATION</h2>
    <iframe
      v-if="dialogflowWidjets"
      id="iframe"
      allow="microphone;"
      src="https://console.dialogflow.com/api-client/demo/embedded/9f65cc0d-3eb0-477b-816c-87d5ddce431b">
    </iframe>
    <div class="to_login">
      <router-link to="/console/edit" class="btn-gradient-3d-simple">コンソール</router-link>
    </div>
    <div class="to_login">
      <a href="https://docs.google.com/forms/d/e/1FAIpQLSdQk0HdhTkC3zNxi0czb5fxzcLvdMeK4DjTa3JfV5dDR4hUYA/viewform?usp=sf_link" class="btn-gradient-3d-simple form_layout">お問い合わせ</a>
    </div>
    <div v-if="twitterWidjet" class="twitter_install">
      <a
        class="twitter-timeline"
        data-width="300"
        data-height="500"
        href="https://twitter.com/seikeijudo?ref_src=twsrc%5Etfw">
        ※読み込みエラー<br>ツイッターのタイムラインが表示されない場合は、リロードしてね！
      </a>
    </div>
    <div class="object_1">
      <div class="object_1_mask">
        <div class="object_1_shape"></div>
        <div class="object_1_string">
          <p>アーカイブ</p>
          <router-link to="/archive_2019">2019年(平成31/令和1)</router-link>
          <router-link to="/archive_2020">2020年(令和2)</router-link>
          <router-link to="/archive_others">もっと見る</router-link>
        </div>
        <div class="object_2_shape"></div>
        <div class="object_2_string">
          <p>柔道場</p>
          <router-link to="/judo_place_photo_seikei">大学柔道場/写真</router-link>
          <router-link to="/judo_place_photo_budokan">日本武道館/写真</router-link>
        </div>
        <div class="object_3_shape"></div>
        <div class="object_3_shape_mask"></div>
        <div class="object_3_string">
          <p>SNSリンク</p>
          <a style="display:inline-block;padding-left: 38px;" href="https://twitter.com/seikeijudo?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor">Twitter</a>
          <a style="display:inline-block;padding-left: 38px;" href="https://www.instagram.com/seikei_judo/">Instagram</a>
          <a style="display:inline-block;padding-left: 38px;" href="https://ja-jp.facebook.com/seikeijudo/">Facebook</a>
          <a style="display:inline-block;padding-left: 38px;" href="https://www.youtube.com/channel/UCBurrYvq9gATL7yx_xIYHJw">YouTube</a>
        </div>
        <div class="object_4_shape"></div>
        <div class="object_4_string">
          <p>OB/OG</p>
          <a href="http://seikei-judokai.org">成蹊柔道会トップ</a>
          <a href="https://seikei-daigaku-judo.wixsite.com/seikei">旧ホームページ</a>
        </div>
        <div class="object_5_string">
          <p style="background-color: orange;padding-top:0;margin-top:10px;border:solid 4px navy;">柔道について詳しく</p>
          <router-link style="color:black;padding-left:28px;background-color: orange;padding-top:0;margin-top:10px;border:solid 4px navy;" to="/judo_history">柔道の歴史</router-link>
          <a style="color:black;padding-left:28px;background-color: orange;padding-top:0;margin-top:10px;border:solid 4px navy;" href="https://tokyo2020.org/jp/games/sport/olympic/judo/">2020東京五輪/柔道</a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  mounted(){
    window.twttr.widgets.load();
  },
  computed:{
    dialogflowWidjets(){
      return window.innerWidth > 1000 ? true : false;
    },
    twitterWidjet(){
      return window.innerWidth > 1000 ? true : false;
    }
  }
};
</script>

<style scoped>
.sidemenu{
  float:right;
  width:275px;
  background-color:#EEEEEE;
}

.heading{
  padding:10px 12px;
  background-color:#2d3d54;
  letter-spacing:1px;
  font-size:1.6rem;
  color:white;
}

.sidemenu .heading{
  margin-top: 0;
}

#iframe{
  height: 430px;
  width: 275px;
  border-width: 0;
  border-style: none;
}

.object_1{
  width:275px;
  overflow: hidden;
  margin: 20px 0 0 0;
  padding: 0;
  height: 900px;
}

.object_1_mask{
  margin: 0;
  padding: 0;
  position: relative;
}

.object_1_shape{
  width: 87%;
  background-color: violet;
  height: 138px;
  z-index: 3;
  position: absolute;
}

.object_2_shape{
  background-color: red;
  height: 200px;
  width: 200px;
  border-radius: 50%;
  position: absolute;
  top:114px;
  left:130px;
  z-index: 3;
}

.object_3_shape{
  background-color: deepskyblue;
  position: absolute;
  top:172px;
  left:0;
  height: 200px;
  width: 275px;
  z-index: 2;
}

.object_3_shape_mask{
  background-color: #EEEEEE;
    width: 500px;
    height: 200px;
    position: absolute;
    top: 135px;
    left: 0;
    transform: rotate(34deg);
    z-index: 2;
}

.object_4_shape{
  background-color: maroon;
    position: absolute;
    top: 365px;
    left: 80px;
    height: 158px;
    width: 324px;
    z-index: 3;
    transform: rotate(-32deg);
}

.object_1_string{
  position: absolute;
  top:0;
  left:0;
  color: white;
  z-index: 3;
}

.object_2_string{
  position: absolute;
  top: 136px;
  left: 132px;
  color: white;
  z-index: 3;
}

.object_3_string{
  position: absolute;
  top: 266px;
    left: -22px;
  color: white;
  z-index: 3;
}

.object_4_string{
  position: absolute;
    top: 424px;
    left: 76px;
    color: white;
    z-index: 3;
}

.object_5_string{
  position: absolute;
  top: 534px;
  left: -7px;
    color: navy;
    z-index: 3;
    text-align: center;
}

.object_1_string p,.object_2_string p,.object_3_string p,.object_4_string p,.object_5_string p{
  margin: 0;
  font-size: 26px;
  padding: 10px 0 0 28px;
  font-weight: bold;
}

.object_1_string a,.object_2_string a,.object_3_string a,.object_4_string a,.object_5_string a{
  display:block;
  color: white;
  padding: 5px 0 0 60px;
  font-size: 15px;
  font-weight: bold;
}

.to_login{
  color: white;
}

.btn-gradient-3d-simple {
  display: inline-block;
  padding: 0.5em 1em;
  text-decoration: none;
  border-radius: 4px;
  color: #ffffff;
  background-image: linear-gradient(#6795fd 0%, #67ceff 100%);
  box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.29);
  border-bottom: solid 3px #5e7fca;
  margin:0 0 13px 0;
  width: 100%;
  height: 56px;
  text-align: center;
  font-size: 27px;
  padding-top: 7px;
  font-family: monospace;
  font-weight: bold;
  letter-spacing: 16px;
}

.btn-gradient-3d-simple:active {
  -webkit-transform: translateY(4px);
  transform: translateY(4px);
  box-shadow: 0px 0px 1px rgba(0, 0, 0, 0.2);
  border-bottom: none;
}

.form_layout{
  padding-top: 11px;
  font-size: 22px;
  background-image: linear-gradient(red 0%, orange 100%);
  border-bottom: solid 3px hotpink;
}

.twitter_install a{
  font-size: 15px;
  font-weight: bold;
}

@media (max-width:1000px){
.sidemenu{
  display: none;
}
}
</style>
