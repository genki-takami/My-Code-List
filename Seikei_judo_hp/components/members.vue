<template>
  <div class="content_wall">
    <div class="wrapper clearfix">
      <div class="main">
        <div class="intro_head">
          <h2>選手(クリックで詳細)</h2>
        </div>
        <div class="members" v-if="loadCompleteFlag">
          <div v-for="n in membersList.fields.names.arrayValue.values.length" :key="n">
            <div class="member" @click="show(membersList.fields.names.arrayValue.values[n-1].stringValue)">
              <div class="frame_box">
                <img :src="membersList.fields.imageURLs.arrayValue.values[n-1].stringValue">
                <div class="rotate_area">
                  <p class="member_name">{{ membersList.fields.names.arrayValue.values[n-1].stringValue }}</p>
                  <div class="non_rotate_area">
                    <p class="member_data">
                      {{ membersList.fields.grades.arrayValue.values[n-1].stringValue }}<br>
                      {{ membersList.fields.jobs.arrayValue.values[n-1].stringValue }}<br>
                      {{ membersList.fields.weightclasses.arrayValue.values[n-1].stringValue }}<br>
                      {{ membersList.fields.faculties.arrayValue.values[n-1].stringValue }}<br>
                      {{ membersList.fields.talls.arrayValue.values[n-1].stringValue }}<br>
                      {{ membersList.fields.highschools.arrayValue.values[n-1].stringValue }}
                      <span class="accept_space"></span><span class="accept_space"></span>
                      {{ membersList.fields.statuses.arrayValue.values[n-1].stringValue }}
                    </p>
                  </div>
                </div>
              </div>
            </div>
            <modal :name="membersList.fields.names.arrayValue.values[n-1].stringValue" :adaptive="true">
              <div class="modal-header">
                <h2>{{ membersList.fields.names.arrayValue.values[n-1].stringValue }}</h2>
              </div>
              <div class="modal-body">
                <p>{{ membersList.fields.comments.arrayValue.values[n-1].stringValue }}</p>
                <button @click="hide(membersList.fields.names.arrayValue.values[n-1].stringValue)">閉じる</button>
              </div>
            </modal>
          </div>
        </div>
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
      membersList:[],
      loadCompleteFlag:false
    };
  },
  created() {
    axios.get('/members')
          .then(response => {
            this.membersList = response.data.documents[0];
            this.loadCompleteFlag = true;
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
.members{
  margin-bottom:30px;
}

.member{
  overflow: hidden;
  float: left;
  margin:20px 20px;
  position: relative;
  width: 285px;
  height:248px;
  cursor:pointer;
}

.frame_box{
  width:330px;
  position:relative;
}

.member img{
  width:100%;
  height:300px;
  object-fit: cover;
  position: absolute;
  top:-50px;
  left:-50px;
  z-index: 4;
}

.rotate_area{
  width: 400px;
  height: 300px;
  background-color:navy;
  margin: 0;
  padding: 0;
  position: absolute;
  z-index: 5;
  transform: rotate(-41deg);
  top:80px;
  left:45px;
}

.non_rotate_area{
  transform: rotate(41deg);
  margin: 0;
  text-align: right;
  width: 300px;
  position: absolute;
  bottom: 155px;
  right:55px ;
}

.member_name{
  margin:0;
  font-weight: bold;
  font-size:3.5rem;
  text-align: center;
  font-family:'Gulim';
  letter-spacing:5px;
  background-color:#EEEEEE;
  color: black;
  font-family: serif;
}

.member_data{
  margin:0;
  width: 80%;
  font-size:1.7rem;
  color:yellow;
}

.intro_head_2{
  margin:20px 20px 20px 0;
  border-top:1px solid black;
  border-bottom:1px solid black;
  line-height:1.2rem;
}

.modal-header, .modal-body {
  padding: 5px 25px;
}

.modal-header {
  border-bottom: 1px solid #ddd;
}

@media  (min-width: 500px) and (max-width:1000px){
.members{
  margin: 0 40px;
}

.member{
  width:44%;
  height: 370px;
  float: left;
}
.member img{
  width: none;
  height:418px;
  top: -29px;
  left: -55px;
}

.member_name{
  margin:none;
  font-size:4rem;
  letter-spacing:20px;
  text-align: center;
}

.member_data{
  margin: 67px 0px -82px -36px;
  width: 69%;
  font-size: 20px;
  transform: rotate(20deg);
}

.rotate_area{
  width: 461px;
  transform: rotate(-61deg);
  top: 95px;
  left: 76px;
}
}

@media (min-width: 500px) and (max-width:601px){
.member{
  width: 65%;
  margin: 13px 90px;
}
}

@media (max-width:499px) {
.member{
  margin-left: 40px;
  margin-right: 30px;
}
}
</style>
