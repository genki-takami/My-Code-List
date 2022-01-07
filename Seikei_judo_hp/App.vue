<template>
  <div id="app">
    <HEADER></HEADER>
    <router-view></router-view>
    <FOOTER></FOOTER>
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
};
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

.content_wall{
  width: 100%;
  height: 100%;
  background-color:#EEEEEE;
}

.wrapper{
  width:970px;
  margin:1px auto 1px;
  padding-top: 160px;
}

.main{
  display:block;
  float:left;
  width:660px;
}

.clearfix::after{
  content:'';
  display: block;
  clear: both;
}

.intro_head{
  margin:0 20px 20px 0;
  border-top:1px solid black;
  border-bottom:1px solid black;
  line-height:1.2rem;
}

/* 上に戻るボタン */
.pagetop {
	color: #fff;
	background-color: rgba(0,0,0,0.3);
	text-decoration: none;
	display: none;
	position: fixed;
	bottom: 2rem;
	right: 4rem;
	font-size: 4rem;
	width: 5.5rem;
	height: 5.5rem;
	line-height: 5.5rem;
	border-radius: 3.3rem;
	text-align: center;
	cursor: pointer;
  z-index:5;
}

.pagetop:hover {
	color: #fff !important;
	background-color: #ed702b;
	text-decoration: none;
}

.accept_space{
  margin-left: 10px;
}

.match_list{
  border-left:10px solid blue;
  margin:0 auto;
  width:70%;
  margin-bottom:70px;
}

.match_list h2{
  font-size:2rem;
  text-align: center;
}

.match_list p{
  font-size:3rem;
  text-align: center;
  font-family: serif;
}

.match_list_2{
  border-left:10px solid blue;
  margin:0 auto;
  width:80%;
  margin-bottom:70px;
  padding-left:60px;
}

.match_year{
  font-size:2rem;
  text-align: center;
}

.match_content{
  font-size:2rem;
  text-align:left;
}

.match_list pre{
  font-size:3rem;
  font-family: serif;
  margin-left:45px;
}

.score{
  font-size:2rem;
}

.line{
  font-family:"Hiragino Kaku Gothic ProN";
}

.winner{
  color:red;
  font-weight: bold;
}

.loser{
  color:blue;
  font-weight: bold;
}

.loser_normal{
  color: black;
}

.match_lists{
  margin-bottom:30px;
}

.article_frame{
  margin: 20px auto;
  padding:0;
  width: 300px;
  height: 300px;
  float: left;
}

.article_content{
  margin: 0;
  padding:0;
  position: relative;
}

.article_mask{
  margin: 0;
  padding:0;
  position: absolute;
  overflow: hidden;
  width: 200px;
  height: 200px;
  border-radius: 50%;
  top: 22px;
  left: 45px;
  border: solid 1px gray;
}

.article_mask img{
  margin: 0 0 0 -45px;
  padding:0;
  object-fit: cover;
  height: 100%;
}

.article_content h3{
  margin: 0;
  padding:0;
  position: absolute;
  top: 177px;
  left: 45px;
  font-weight: bold;
  font-size: 18px;
  background-color: #EEEEEE;
}

.article_content p{
  margin: -19px 0 0 -170px;
  padding: 0;
  position: absolute;
  top: 261px;
  left: 215px;
  font-size: 15px;
  font-weight: bold;
}

.archive_head h2{
  position: relative;
  padding: 0.5em;
  background: #a6d3c8;
  color: white;
}

.archive_head h2::after{
  position: absolute;
 content: '';
 top: 100%;
 left: 0;
 border: none;
 border-bottom: solid 15px transparent;
 border-right: solid 20px rgb(149, 158, 155);
}

.calendar_head h1 {
  position: relative;
  color: #158b2b;
  font-size: 18px;
  padding: 7px 0;
  text-align: center;
  margin: 1.5em 0;
  letter-spacing: 1.1em;
}
.calendar_head h1:before {
  content: "";
  position: absolute;
  top: -8px;
  left: 48%;
  width: 150px;
  height: 58px;
  border-radius: 50%;
  border: 5px solid #a6ddb0;
  border-left-color: transparent;
  border-right-color: transparent;
  -webkit-transform: translateX(-50%);
  transform: translateX(-50%);
}

.plan{
  margin:0 50px;
}

.plan ul{
  padding: 0;
  position: relative;
}

.plan ul li{
  border-left: solid 6px #2d8fdd;/*左側の線*/
  background: #f1f8ff;/*背景色*/
  margin-bottom: 3px;/*下のバーとの余白*/
   line-height: 1.5;
  padding: 0.5em;
  list-style-type: none!important;/*ポチ消す*/
}

.plan ul li a{
  color:#2d8fdd;
  font-size: 15px;
}

.month_photo_2{
  text-align: center;
}

.ribbon13-wrapper {
  display: inline-block;
  position: relative;
  margin: 15px 13px;
  padding: 10px 0;
  width: 300px;
  background: white;
  }

.no1{
    text-align: center;
    font-size:15px;
    font-weight: bold;
  }

.no2{
  padding-left:13px;
  text-align: left;
  font-size: 12px;
  font-weight: bold;
}

.ribbon13 {
  display: inline-block;
  position: relative;
  box-sizing: border-box;
  padding: 5px 0;
  margin: 0 0 0 -20px;
  width: calc(100% + 20px);
  color: white;
  background: #70a6ff;
  box-shadow: 0 2px 2px rgba(0, 0, 0, 0.2);
}

.ribbon13 h3{
  margin: 0;
  padding: 0 30px 0 15px;
  border-top: dashed 1px #FFF;
  border-bottom: dashed 1px #FFF;
  font-size: 19px;
  line-height: 46px;
}

.ribbon13:after {
  position: absolute;
  content: '';
  z-index: 1;
  top: 0;
  right: 0;
  width: 0px;
  height: 0px;
  border-width: 30px 15px 30px 0px;
  border-color: transparent #f1f1f1 transparent transparent;
  border-style: solid;
}

.ribbon13:before {
  position: absolute;
  content: '';
  top: 100%;
  left: 0;
  border: none;
  border-bottom: solid 15px transparent;
  border-right: solid 20px #6081b7;
}

.ribbon20-wrapper {
  display: inline-block;
  position: relative;
  margin: 10px 10px;
  padding: 20px 0;
  width: 300px;
  background: white;
  }
.ribbon20 {
  display: inline-block;
  position: absolute;
  left: 0;
  top: 5px;
  box-sizing: border-box;
  padding: 0 12px;
  margin: 0;
  height: 30px;
  line-height: 30px;
  font-size: 18px;
  letter-spacing: 0.1em;
  color: white;
  background: #70c7ff;
  box-shadow: 0 2px 2px rgba(0, 0, 0, 0.12);
}
.ribbon20:before {
  position: absolute;
  content: '';
  top: 0;
  left: -7px;
  border: none;
  height: 38px;
  width: 7px;
  background: #70c7ff;
  border-radius: 5px 0 0 5px;
}
.ribbon20:after {
  position: absolute;
  content: '';
  bottom: -7px;
  left: -5px;
  border: none;
  height: 7px;
  width: 5px;
  background: #4d99ca;
  border-radius: 5px 0 0 5px;
}

.ribbon20-wrapper p{
  text-align: center;
  padding-top:16px;
}

.ribbon20-wrapper p a{
  color: black;
  font-size: 16px;
}

.scroll-list{
  overflow-y: auto;
  margin-bottom:30px;
  list-style-type: none;
}

.scroll-list .scroll-item a{
  display: block;
  padding: 10px 15px;
  color:#333;
  transition:background-color 0.1s;
}

.scroll-list .scroll-item+.scroll-item a{
  border-top:1px dashed black;
}

.scroll-list .scroll-item a:hover{
  background-color:#fafaf8;
}

.scroll-list .date{
  display: inline-block;
  width:25%;
  letter-spacing:1px;
  font-weight: bold;
}

.scroll-list .category{
  display:inline-block;
  width:25%;
  font-weight: bold;
  border-radius:5px;
  text-align:center;
  letter-spacing:1px;
  line-height:16px;
}

.scroll-list .title{
  display: inline-block;
  width:50%;
  padding-left:15px;
}

@media  (min-width: 500px) and (max-width:1000px){
.wrapper{
  width:100%;
  margin:52px 0 0;
  padding-top: 22px;
  padding-bottom: 636px;
}

.main{
  width:100%;
}

.intro_head{
  margin:30px 20px 25px;
  line-height:2rem;
}

.intro_head h2{
  font-size:1.7rem;
}

.pagetop {
  bottom: 2rem;
  right: 2rem;
  font-size: 3rem;
  width: 5rem;
  height: 5rem;
  line-height: 5.2rem;
  border-radius: 50%;
}

.match_list{
  border-left:5px solid blue;
}

.match_list h2{
  font-size:2rem;
}

.match_list p{
  font-size:3rem;
}

.match_list_2{
  border-left:5px solid blue;
  width:75%;
  padding-left:100px;
}

.match_list_2 h2{
  font-size:2rem;
}

.score{
  font-size:1rem;
}

.match_list pre{
  font-size:3rem;
  margin-left:73px;
}

.match_lists{
  margin-bottom:30px;
}

.article_frame{
  margin: 22px 22px 0;
}

.plan ul li{
  margin-bottom: 10px;
  margin-right: 50px;
  display: inline-block;
}

.archive_head{
  margin: 0 10px;
}

.archive_scroll-list{
padding: 0 90px;
max-height: none;
margin-bottom:30px;
}

.match_box{
  margin-left: 50px;
}
}
@media (min-width: 500px) and (max-width:801px){
.wrapper{
  padding-bottom: 237px;
}

.intro_head{
  margin-top: 31px;
}
}

@media (min-width: 500px) and (max-width:601px){
.article_frame{
  width: 216px;
}

.article_mask,.article_content h3{
  left: 15px;
}

.article_content p{
  left: 176px;
}

.plan,.match_box{
  text-align: center;
}
}

@media (max-width:499px) {
.pagetop {
  bottom: 2rem;
  right: 2rem;
  font-size: 3rem;
  width: 5.5rem;
  height: 5.5rem;
  line-height: 5.5rem;
  border-radius: 3.3rem;
}

.wrapper{
  width:100%;
  margin:105px 0 0;
  padding-top: 0;
}

.main{
  width:100%;
  margin-bottom: 50px;
}

.intro_head{
  margin:30px 20px 25px;
  line-height:2rem;
}

.intro_head h2{
  font-size:1.7rem;
}

.match_list{
  border-left:5px solid blue;
}

.match_list h2{
  font-size:1.5rem;
}

.match_list p{
  font-size:1.5rem;
}

.match_list_2{
  border-left:5px solid blue;
  width:90%;
  padding-left:15px;
}

.match_list_2 h2{
  font-size:1.3rem;
}

.score{
  font-size:1rem;
}

.match_list pre{
  font-size:1.5rem;
  margin-left:10px;
}

.match_lists{
  margin-bottom:30px;
}

.article_frame{
  float: none;
}

.wrapper{
  margin-top: 121px;
}

.archive_head{
  margin: 0 10px;
}

.archive_scroll-list{
  padding: 0 25px;
  max-height: none;
  margin-bottom: 30px;
}

.match_box{
  padding-left: 25px;
  padding-right: 25px;
}
}
</style>
