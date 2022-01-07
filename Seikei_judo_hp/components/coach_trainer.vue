<template>
  <div class="content_wall">
    <div class="wrapper clearfix">
      <div class="main">
        <div class="intro_head">
          <h2>監督<span class="accept_space"></span>/<span class="accept_space"></span>トレーナー<span class="accept_space"></span>(クリックで詳細)</h2>
        </div>
        <div class="mentor" @click="show('coach')">
          <div class="mentor_mask">
            <img :src="coachUrl">
            <div class="mentor_cover">
              <div class="mentor_cover_margin"></div>
            </div>
            <div class="mentor_content01" v-html="coachName"></div>
            <div class="mentor_content02" v-html="coachStatus"></div>
          </div>
        </div>
        <modal name="coach" :adaptive="true">
          <div class="modal-header">
            <h2>{{ coachTitle }}</h2>
          </div>
          <div class="modal-body">
            <p>{{ coachComment }}</p>
            <button @click="hide('coach')">閉じる</button>
          </div>
        </modal>
        <div class="mentor" @click="show('trainer')">
          <div class="mentor_mask">
            <img :src="trainerUrl">
            <div class="mentor_cover">
              <div class="mentor_cover_margin"></div>
            </div>
            <div class="mentor_content01" v-html="trainerName"></div>
            <div class="mentor_content02" v-html="trainerStatus"></div>
          </div>
        </div>
        <modal name="trainer" :adaptive="true">
          <div class="modal-header">
            <h2>{{ trainerTitle }}</h2>
          </div>
          <div class="modal-body">
            <p>{{ trainerComment }}</p>
            <button @click="hide('trainer')">閉じる</button>
          </div>
        </modal>
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
      coachName:'',
      coachTitle:'',
      coachStatus:'',
      coachComment:'',
      coachUrl:'',
      trainerName:'',
      trainerTitle:'',
      trainerStatus:'',
      trainerComment:'',
      trainerUrl:'',
      pStyle:'<p style="margin:0;">',
      pStyle2:'<p style="font-size:1.5rem;margin:30px 20px;">',
      pStyleEnd:'</p>'
    };
  },
  created() {
    axios.get(process.env.VUE_APP_COACH_AND_TRAINER_PATH)
          .then(response => {
            this.coachUrl = response.data.fields.url1.stringValue;
            this.trainerUrl = response.data.fields.url2.stringValue;
            this.coachName = this.pStyle + response.data.fields.name1.stringValue + this.pStyleEnd;
            this.coachTitle = response.data.fields.name1.stringValue;
            this.coachStatus = this.pStyle + response.data.fields.status1.stringValue + this.pStyleEnd;
            this.coachComment = response.data.fields.comment1.stringValue;
            this.trainerName = this.pStyle + response.data.fields.name2.stringValue + this.pStyleEnd;
            this.trainerTitle = response.data.fields.name2.stringValue;
            this.trainerStatus = this.pStyle + response.data.fields.status2.stringValue + this.pStyleEnd;
            this.trainerComment = response.data.fields.comment2.stringValue;
          });
  },
  methods:{
    show(name){
      this.$modal.show(name);
    },
    hide(hname){
      this.$modal.hide(hname);
    }
  }
};
</script>

<style scoped>
h2{
  margin-left: 20px;
}
.mentor{
  width: 620px;
  height: 400px;
  overflow: hidden;
  margin: 0;
  margin-left: 14px;
  margin-bottom: 20px;
  cursor:pointer;
}

.mentor_mask{
  position: relative;
  margin: 0;
}

.mentor_mask img{
  position: absolute;
  top:-80px;
  left:-70px;
  margin: 0;
  object-fit: cover;
  width: 100%;
  z-index: 2;
}

.mentor_cover{
  width:810px;
  height: 400px;
  transform: rotate(-38deg);
  background-color:navy;
  margin: 0;
  position: absolute;
  top:140px;
  left:-22px;
  z-index: 3;
}

.mentor_content01{
  z-index: 5;
  position: absolute;
  bottom: -400px;
  right: 0;
  height:400px;
  width: 125px;
  text-align: center;
  font-size: 55px;
  font-weight: bold;
  font-family: serif;
  margin: 0;
  padding:30px 35px 0;
  color: yellow;
}

.mentor_content02{
  z-index: 4;
  position: absolute;
  bottom: -331px;
  right:121px;
  height:189px;
  width:185px;
  text-align: left;
  font-size: 25px;
  font-family: serif;
  margin: 0;
  color: yellow;
}

.mentor_cover_margin{
  margin: 0;
  width: 356px;
  height: 400px;
  background-color:white;
  opacity: 0.5;
  border-right: solid 8px red;
}

.modal-header, .modal-body {
  padding: 5px 25px;
}

.modal-header {
  border-bottom: 1px solid #ddd;
}

@media  (min-width: 500px) and (max-width:1000px){
.mentor{
  margin-left: 67px;
}
}

@media (min-width: 500px) and (max-width:601px){
.mentor{
  margin-left: -11px;
}
}

@media (max-width:499px) {
.mentor{
  width:346px;
  height: 220px;
}

.mentor_mask img{
  top:-40px;
  left:-65px;
}

.mentor_cover{
  width: 466px;
  height: 238px;
  top:87px;
  left:-22px;
}

.mentor_cover_margin{
  width: 197px;
  height: 238px;
}

.mentor_content01{
  font-size: 34px;
  bottom: -377px;
  right: -24px;
}

.mentor_content02{
  bottom: -285px;
  right:60px;
  height:192px;
  width:111px;
  font-size: 14px;
}
}
</style>
