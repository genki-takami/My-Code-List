<template>
  <div class="header">
    <div id="nav-drawer">
      <input id="nav-input" type="checkbox" class="nav-unshown" @click="statusChange">
      <label id="nav-open" for="nav-input"><span></span></label>
      <label class="nav-unshown" id="nav-close" :style="menuCloseStyle" @click="clickEvent"></label>
      <div id="nav-content" :style="menuContentStyle">
        <h1><router-link to="/" @click.native="clickEvent">成蹊大学体育会柔道部</router-link></h1>
        <ul>
          <li><router-link to="/console/edit" @click.native="clickEvent"><i class="fas fa-sign-in-alt"></i><span class="accept_space"></span>コンソール</router-link></li>
          <li><router-link to="/introduce" @click.native="clickEvent"><i class="fas fa-info-circle"></i><span class="accept_space"></span>紹介</router-link></li>
          <li><router-link to="/members" @click.native="clickEvent"><i class="fas fa-users"></i><span class="accept_space"></span>メンバー</router-link></li>
          <li><router-link to="/coach_trainer" @click.native="clickEvent"><i class="fas fa-user-tie"></i><span class="accept_space"></span>監督/コーチ</router-link></li>
          <li><router-link to="/evaluation/index" @click.native="clickEvent"><i class="fas fa-sitemap"></i><span class="accept_space"></span>成績</router-link></li>
          <li><router-link to="/schedule" @click.native="clickEvent"><i class="fas fa-calendar-alt"></i><span class="accept_space"></span>スケジュール</router-link></li>
          <li><router-link to="/access" @click.native="clickEvent"><i class="fas fa-map-marker-alt"></i><span class="accept_space"></span>アクセス</router-link></li>
          <li><a href="https://docs.google.com/forms/d/e/1FAIpQLSdQk0HdhTkC3zNxi0czb5fxzcLvdMeK4DjTa3JfV5dDR4hUYA/viewform?usp=sf_link" @click.native="clickEvent"><i class="fas fa-envelope"></i><span class="accept_space"></span>お問い合わせ</a></li>
          <li>
            <details>
                <summary>アーカイブ</summary>
                  <ul>
                    <li><router-link to="/archive_2019" @click.native="clickEvent">2019年(平成31/令和1)</router-link></li>
                    <li><router-link to="/archive_2020" @click.native="clickEvent">2020年(令和2)</router-link></li>
                    <li><router-link to="/archive_others" @click.native="clickEvent">もっと見る</router-link></li>
                  </ul>
            </details>
          </li>
          <li>
            <details>
                <summary>柔道場</summary>
                  <ul>
                    <li><router-link to="/judo_place_photo_seikei" @click.native="clickEvent">大学柔道場/写真</router-link></li>
                    <li><router-link to="/judo_place_photo_budokan" @click.native="clickEvent">日本武道館/写真</router-link></li>
                  </ul>
            </details>
          </li>
          <li>
            <details>
                <summary>SNSリンク</summary>
                  <ul>
                    <li><a href="https://twitter.com/seikeijudo?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor">Twitter</a></li>
                    <li><a href="https://www.instagram.com/seikei_judo/">Instagram</a></li>
                    <li><a href="https://ja-jp.facebook.com/seikeijudo/">Facebook</a></li>
                    <li><a href="https://www.youtube.com/channel/UCBurrYvq9gATL7yx_xIYHJw">YouTube</a></li>
                  </ul>
            </details>
          </li>
          <li>
            <details>
                <summary>OB/OG</summary>
                  <ul>
                    <li><a href="http://seikei-judokai.org">成蹊柔道会トップ</a></li>
                    <li><a href="https://seikei-daigaku-judo.wixsite.com/seikei">旧ホームページ</a></li>
                  </ul>
            </details>
          </li>
          <li>
            <details>
                <summary>柔道について</summary>
                  <ul>
                    <li><router-link to="/judo_history" @click.native="clickEvent">柔道の歴史</router-link></li>
                    <li><a href="https://tokyo2020.org/jp/games/sport/olympic/judo/">2020東京五輪/柔道</a></li>
                  </ul>
            </details>
          </li>
        </ul>
      </div>
    </div>

    <h1 class="logo">
      <router-link to="/">成蹊大学体育会柔道部</router-link>
    </h1>
    <nav class="global-nav">
      <ul>
        <router-link to="/" active-class="now_active" exact class="nav-item normal_icon">トップ</router-link>
        <router-link to="/introduce" active-class="now_active" exact class="nav-item normal_icon">紹介</router-link>
        <router-link to="/members" active-class="now_active" exact class="nav-item normal_icon">メンバー</router-link>
        <router-link to="/coach_trainer" active-class="now_active" exact class="nav-item normal_icon">監督/コーチ</router-link>
        <router-link to="/evaluation/index" active-class="now_active" exact class="nav-item normal_icon">成績</router-link>
        <router-link to="/schedule" active-class="now_active" exact class="nav-item normal_icon">スケジュール</router-link>
        <router-link to="/access" active-class="now_active" exact class="nav-item normal_icon">アクセス</router-link>
        <a class="nav-item special_icon" href="https://twitter.com/seikeijudo?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor"><i class="fab fa-twitter fa-2x"></i> twitter</a>
        <a class="nav-item special_icon instagram_color" href="https://www.instagram.com/seikei_judo/"><i class="fab fa-instagram fa-2x"></i> インスタ</a>
        <a class="nav-item special_icon youtube_color" href="https://www.youtube.com/channel/UCBurrYvq9gATL7yx_xIYHJw"><i class="fab fa-youtube fa-2x"></i> ムービー</a>
      </ul>
    </nav>
  </div>
</template>

<script>
  export default{
    data(){
      return{
        isClose: true,
        isOpen: false,
        menuCloseStyle:{},
        menuContentStyle:{}
      };
    },
    methods:{
      statusChange(){
        if (this.isClose) {
          this.isClose = false;
          this.isOpen = true;
          this.menuCloseStyle = {
            display: 'block',
            opacity: '.5'
          };
          this.menuContentStyle = {
            '-webkit-transform': 'translateX(0%)',
            transform: 'translateX(0%)'
          };
        }
      },
      clickEvent(){
        if (this.isOpen) {
          this.isClose = true;
          this.isOpen = false;
          this.menuCloseStyle = {
            display: 'none',
            opacity: '0'
          };
          this.menuContentStyle = {
            '-webkit-transform': 'translateX(-105%)',
            transform: 'translateX(-105%)'
          }
        }
      }
    }
  };
</script>

<style scoped>
.header{
  height: 140px;
  width:100%;
  background-color: rgba(34, 49, 52, 0.9);
  position :fixed;
  top: 0;
  z-index: 10;
  padding:28px 0 10px;
}

.logo{
  width:400px;
  height:56px;
  margin:0 auto;
  display:block;
  font-family: serif;
  font-size: 40px;
}

.logo a{
  color:white;
}

.global-nav{
  margin-top: 15px;
  text-align: center;
}

.global-nav .nav-item{
  display: inline-block;
  margin: 0 12px;
  width:100px;
  height:30px;
  line-height:30px;
  text-align: center;
  border-radius:8px;
  color:white;
  font-size: 1.3rem;
  letter-spacing: 1px;
  transition:0.15s;
}

.now_active, .global-nav .nav-item:hover{
  background-color:#d03c56;
  color:#fff;
}

.global-nav .special_icon{
  display: none;
}

.special_icon{
  display: none;
}

@media  (min-width: 500px) and (max-width:1000px){

.header{
  height:64px;
  padding-top:5px;
  padding-left: 0;
}

.logo{
  width:100%;
  height:30px;
  text-align: center;
  margin-top: -54px;
}

.logo a{
  font-size:4rem;
  font-family: serif;
  margin-top: -55px;
}

.global-nav{
  display:none;
  text-align: center;
  margin-top: 35px;
}

.global-nav .nav-item{
  margin: 0 3px;
}

.global-nav .nav-item a{
  width:85px;
  height:25px;
  margin:0 0 10px 0;
  line-height:25px;
  font-size:1.1rem;
  font-weight: bold;
}

.global-nav .special_icon{
  display: none;
}

#nav-drawer {
  position: relative;
  display: inline-block;
}

/*チェックボックス等は非表示に*/
.nav-unshown {
  display:none;
}

/*アイコンのスペース*/
#nav-open {
  display: inline-block;
  width: 89px;
  height: 51px;
  padding-left: 24px;
  margin-top: 6px;
  vertical-align: middle;
}

/*ハンバーガーアイコンをCSSだけで表現*/
#nav-open span, #nav-open span:before, #nav-open span:after {
  position: absolute;
  height: 5px;
  width: 38px;
  border-radius: 3px;
  background: white;
  display: block;
  content: '';
  cursor: pointer;
  bottom: 34px;
}
#nav-open span:before {
  bottom: -13px;
}
#nav-open span:after {
  bottom: -26px;
}

/*閉じる用の薄黒カバー*/
#nav-close {
  display: none;/*はじめは隠しておく*/
  position: fixed;
  z-index: 99;
  top: 0;/*全体に広がるように*/
  left: 0;
  width: 100%;
  height: 100%;
  background: black;
  opacity: 0;
  transition: .3s ease-in-out;
}

/*中身*/
#nav-content {
  overflow: auto;
  position: fixed;
  top: 0;
  left: 0;
  z-index: 9999;/*最前面に*/
  width: 90%;/*右側に隙間を作る（閉じるカバーを表示）*/
  max-width: 330px;/*最大幅（調整してください）*/
  height: 100%;
  background-color: rgba(0,0,0, 0.8);
  transition: .3s ease-in-out;/*滑らかに表示*/
  -webkit-transform: translateX(-105%);
  transform: translateX(-105%);/*左に隠しておく*/
}

#nav-content h1{
  color:white;
  margin:15px 0 0 0;
  padding-left: 18px;
  padding-bottom: 10px;
  text-align: left;
  border-bottom: solid 1px white;
}

#nav-content h1 a{
  color: white;
}

#nav-content ul{
padding: 0;
position: relative;
margin: 0 18px;
}

#nav-content ul li{
border-bottom: solid 1px gray;
line-height: 3;
padding: 0.3em,0.5em;
list-style-type: none!important;
}

#nav-content ul li a{
display: inline-block;
color:white;
font-size: 16px;
text-align: left;
width: 100%;
}

#nav-content summary{
display: inline-block;
color:white;
font-size: 16px;
text-align: left;
width: 100%;
}
}

@media (min-width: 500px) and (max-width:801px){
.header{
  height:78px;
}
}


@media (max-width:499px) {
.header{
  height:122px;
  padding-top:5px;
  padding-left: 0;
}

#header{
  margin-top: 24px;
}

#header button{
  margin-left: 37px;
}

.logo{
  display: inline-block;
  width:80%;
  height:30px;
  text-align:center;
  margin:0;
}

.logo a{
  font-size:2.5rem;
  color: white;
}

.global-nav{
  text-align:left;
}

 .global-nav .normal_icon{
   display: none;
 }

.global-nav .nav-item{
  margin: 0 3px;
}

.global-nav .nav-item a{
  width:85px;
  height:25px;
  margin:0 0 10px 0;
  line-height:25px;
  font-size:1.1rem;
  font-weight: bold;
}

.global-nav .special_icon{
  display: inline-block;
}

.global-nav .special_icon{
  background-color:#3399FF;
  border:1px solid white;
  font-weight: bold;
}

.global-nav .instagram_color{
  background: linear-gradient(135deg, #427eff 0%, #f13f79 70%) no-repeat;
  border:1px solid white;
}

.global-nav .youtube_color{
  background:red;
  border:1px solid white;
}

.global-nav .special_icon.active,
.global-nav .special_icon:hover{
  background-color:#d03c56;
  color:#fff;
}

#nav-drawer {
  position: relative;
  display: inline-block;
}

/*チェックボックス等は非表示に*/
.nav-unshown {
  display:none;
}

/*アイコンのスペース*/
#nav-open {
  display: inline-block;
  width: 55px;
  height: 30px;
  padding-left: 15px;
  vertical-align:middle;
}

/*ハンバーガーアイコンをCSSだけで表現*/
#nav-open span, #nav-open span:before, #nav-open span:after {
  position: absolute;
  height: 3px;/*線の太さ*/
  width: 25px;/*長さ*/
  border-radius: 3px;
  background:white;
  display: block;
  content: '';
  cursor: pointer;
}
#nav-open span:before {
  bottom: -8px;
}
#nav-open span:after {
  bottom: -16px;
}

/*閉じる用の薄黒カバー*/
#nav-close {
  display: none;/*はじめは隠しておく*/
  position: fixed;
  z-index: 99;
  top: 0;/*全体に広がるように*/
  left: 0;
  width: 100%;
  height: 100%;
  background: black;
  opacity: 0;
  transition: .3s ease-in-out;
}

/*中身*/
#nav-content {
  overflow: auto;
  position: fixed;
  top: 0;
  left: 0;
  z-index: 9999;/*最前面に*/
  width: 90%;/*右側に隙間を作る（閉じるカバーを表示）*/
  max-width: 330px;/*最大幅（調整してください）*/
  height: 100%;
  background-color: rgba(0,0,0, 0.8);
  transition: .3s ease-in-out;/*滑らかに表示*/
  -webkit-transform: translateX(-105%);
  transform: translateX(-105%);/*左に隠しておく*/
}

#nav-content h1{
  color:white;
  margin:15px 0 0 0;
  padding-left: 18px;
  padding-bottom: 10px;
  text-align: left;
  border-bottom: solid 1px white;
}

#nav-content h1 a{
  color: white;
}

#nav-content ul{
padding: 0;
position: relative;
margin: 0 18px;
}

#nav-content ul li{
border-bottom: solid 1px gray;
line-height: 3;
padding: 0.3em,0.5em;
list-style-type: none!important;
}

#nav-content ul li a{
display: inline-block;
color:white;
font-size: 16px;
text-align: left;
width: 100%;
}

#nav-content summary{
display: inline-block;
color:white;
font-size: 16px;
text-align: left;
width: 100%;
}

details{
  font-size:1.6rem;
}
}

@media (max-width:321px){
.global-nav ul{
padding-left: 0;
}
}

@media screen and (min-width:1000px) {
#nav-drawer {
  display:none;
}
}
</style>
