<template>
  <div>
    <div id="big_parallax">
      <agile ref="main" :options="options1" :as-nav-for="asNavFor1" class="mainview">
      <div class="slide" v-for="(slide, index) in slides" :key="index" :class="`slide--${index}`">
        <img :src="slide">
      </div>
      </agile>
      <agile ref="thumbnails" :options="options2" :as-nav-for="asNavFor2" class="thumbnails">
        <div class="slide slide--thumbniail" v-for="(slide, index) in slides" :key="index" @click="$refs.thumbnails.goTo(index);" :class="`slide--${index}`">
          <img :src="slide">
        </div>
      </agile>
    </div>
    <div class="home_content_wall">
      <div class="wrapper_2 clearfix">
        <Main></Main>
        <Sidemenu></Sidemenu>
      </div>
    </div>
  </div>
</template>

<script>
import Main from "./top_main.vue";
import Sidemenu from "./sidemenu.vue";
import { VueAgile } from 'vue-agile';
export default {
  components:{
    agile: VueAgile,
    Main,
    Sidemenu
  },
  data(){
    return{
      asNavFor1: [],
       asNavFor2: [],
       slides: [
         'https://i.gyazo.com/730775b43e25aa18a27da6a64ea8a546.jpg',//扇形
         'https://i.gyazo.com/24241d82e7dc73ee0c9e176d5d900fad.jpg',//練習風景
         'https://i.gyazo.com/51352df1f759a01ea1ce9b1f69a35a65.jpg',//文化祭
         'https://i.gyazo.com/0dd524e76430f1030422cae610c4d9e9.jpg',//スキー
         'https://i.gyazo.com/0daa38b4825b4654344901f63448e981.jpg',//箱根道場
         'https://i.gyazo.com/6b3d5b692110ad550c3e3afddd686be9.jpg',//合宿時食事
         'https://i.gyazo.com/591a4f540eb541a97d9438387e267685.jpg'//反省会
       ],
       options1: {
         dots: false,
         fade: true,
         navButtons: false
       },
       options2: {
         autoplay: true,
         centerMode: true,
         dots: false,
         navButtons: false,
         slidesToShow: 3,
         responsive: [
           {
             breakpoint: 600,
             settings: {
               slidesToShow: 5
             }
           },
           {
             breakpoint: 1000,
             settings: {
               navButtons: true
             }
           }
         ]
       }
    };
  },
  mounted(){
    this.asNavFor1.push(this.$refs.thumbnails);
    this.asNavFor2.push(this.$refs.main);
  }
};
</script>

<style scoped>
#big_parallax{
  width:100%;
  position: fixed;
  top:0;
  z-index:1;
  background-color:#EEEEEE;
}

.mainview{
  margin-bottom:10px;
}

.thumbnails {
  margin: 0 -5px;
  width: calc(100% + 10px);
}

.slide {
  -webkit-box-align: center;
  align-items: center;
  box-sizing: border-box;
  color: #fff;
  display: -webkit-box;
  display: flex;
  height: 570px;
  -webkit-box-pack: center;
  justify-content: center;
}

.slide--thumbniail {
  cursor: pointer;
  height: 130px;
  padding: 0 5px;
  -webkit-transition: opacity 0.3s;
  transition: opacity 0.3s;
}

.slide--thumbniail:hover {
  opacity: 0.75;
}

.slide img {
  height: 100%;
  -o-object-fit: cover;
     object-fit: cover;
  -o-object-position: center;
     object-position: center;
  width: 100%;
}

.home_content_wall{
  width: 100%;
  background-color:#EEEEEE;
  z-index: 3;
  position: relative;
}

.wrapper_2{
  width:970px;
  margin:710px auto 0;
  padding-top:35px;
  position: relative;
  z-index:3;
}

@media  (min-width: 500px) and (max-width:1000px){
.wrapper_2{
  width:100%;
  margin:0 0 0;
  padding-top:1px;
}

.home_content_wall{
  margin-top:710px;
}
}

@media (min-width: 500px) and (max-width:899px){
.slide{
  height:432px;
}

.slide--thumbniail{
  height:85px;
}

.home_content_wall{
  margin-top:527px;
}
}

@media (max-width:499px) {
.wrapper_2{
  width:100%;
  margin:0 0;
  padding-top:0;
  position: relative;
  z-index:3;
}

#big_parallax{
  background-color:black;
}

.mainview{
  margin-top:122px;
}

.slide{
  height:210px;
}

.slide--thumbniail{
  height:73px;
}

.home_content_wall{
  margin-top:415px;
}
}
</style>
