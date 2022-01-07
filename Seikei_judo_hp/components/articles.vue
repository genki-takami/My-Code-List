<template>
  <div class="articles">
    <h2 id="articletop">ARTICLES</h2>
    <keep-alive>
      <component :is="nowcomponent" class="page_component"></component>
    </keep-alive>
    <div class="btn_area">
      <button @click="nextPage" class="step_page_button" v-scroll-to="toTop">NEXT</button>
      <button @click="backPage" class="step_page_button" v-scroll-to="toTop">BACK</button>
    </div>
  </div>
</template>

<script>
import Page1 from "./article_pages/page1.vue";
import Page2 from "./article_pages/page2.vue";
import Page3 from "./article_pages/page3.vue";
import Page4 from "./article_pages/page4.vue";
import Page5 from "./article_pages/page5.vue";
import Page6 from "./article_pages/page6.vue";
import Page7 from "./article_pages/page7.vue";
import Page8 from "./article_pages/page8.vue";
import Page9 from "./article_pages/page9.vue";
import Page10 from "./article_pages/page10.vue";
export default {
  data() {
    return {
      nowcomponent:'Page1',
      toTop:'#articletop'
    };
  },
  components:{
    Page1,
    Page2,
    Page3,
    Page4,
    Page5,
    Page6,
    Page7,
    Page8,
    Page9,
    Page10
  },
  methods: {
    backPage(){
      if (this.nowcomponent == "Page1") {
        return
      }else if (this.nowcomponent == "Page2") {
        this.nowcomponent = "Page1"
      }else if (this.nowcomponent == "Page3") {
        this.nowcomponent = "Page2"
      }else if (this.nowcomponent == "Page4") {
        this.nowcomponent = "Page3"
      }else if (this.nowcomponent == "Page5") {
        this.nowcomponent = "Page4"
      }else if (this.nowcomponent == "Page6") {
        this.nowcomponent = "Page5"
      }else if (this.nowcomponent == "Page7") {
        this.nowcomponent = "Page6"
      }else if (this.nowcomponent == "Page8") {
        this.nowcomponent = "Page7"
      }else if (this.nowcomponent == "Page9") {
        this.nowcomponent = "Page8"
      }else if (this.nowcomponent == "Page10") {
        this.nowcomponent = "Page9"
      }
    },
    nextPage(){
      if (this.nowcomponent == "Page1") {
        this.nowcomponent = "Page2"
      }else if (this.nowcomponent == "Page2") {
        this.nowcomponent = "Page3"
      }else if (this.nowcomponent == "Page3") {
        this.nowcomponent = "Page4"
      }else if (this.nowcomponent == "Page4") {
        this.nowcomponent = "Page5"
      }else if (this.nowcomponent == "Page5") {
        this.nowcomponent = "Page6"
      }else if (this.nowcomponent == "Page6") {
        this.nowcomponent = "Page7"
      }else if (this.nowcomponent == "Page7") {
        this.nowcomponent = "Page8"
      }else if (this.nowcomponent == "Page8") {
        this.nowcomponent = "Page9"
      }else if (this.nowcomponent == "Page9") {
        this.nowcomponent = "Page10"
      }else if (this.nowcomponent == "Page10") {
        return
      }
    }
  }
};
</script>

<style scoped>
.articles h2{
  text-align: center;
}

.btn_area{
  margin: 0 65px 80px 0;
}

.step_page_button{
  float:right;
  font-size: 1.5rem;
  font-weight: bold;
  color: white;
  background-color: #2d3d54;
  padding: 5px 10px;
  margin-left: 10px;
  cursor: pointer;
}

.page_component{
  width: 100%;
}

@media  (min-width: 500px) and (max-width:1000px){
.articles{
  margin: 0 40px;
}

.articles h2{
  font-size:2rem;
  text-align: center;
  border-top:1px solid black;
  padding-top:60px;
  margin-top:0;
}

.btn_area{
  margin-right: 24px;
}

}

@media (max-width:499px) {
.articles h2{
  font-size:2rem;
  text-align: center;
  border-top:1px solid black;
  padding-top:60px;
  margin-top:0;
}

.btn_area{
  margin-right: 30px;
}

.step_page_button{
  margin-right: 10px;
}
}
</style>
