<template>
  <div class="edit_main_zone">
    <div class="main_header">
      <div v-show="error" style="display:inline-block;">
        <i class="fas fa-exclamation-triangle fa-2x" style="color:red;"></i>
      </div>
      <div v-show="success" style="display:inline-block;">
        <i class="fas fa-check fa-2x" style="color:#24b924;"></i>
      </div>
      <div v-show="saving" style="display:inline-block;">
        <i class="fas fa-sync-alt fa-2x fa-spin" style="color:blue"></i>
      </div>
      <button :class="{savedBtn:saved}" type="submit" @click="save">{{ saveStatus }}</button>
    </div>
    <div v-if="error" style="padding:10px 0;font-size:1.3rem;">
      <p style="margin:0;color:red;text-align:center;">{{ errorMessage }}</p>
    </div>
    <div style="margin:10px 0 0 -6rem;">
      <span @click="show('Main')" class="modal_guaide_btn"><i class="far fa-file-alt"></i> 使用ガイド<i class="fas fa-chevron-circle-right"></i></span>
    </div>
    <div class="main_field">
      <div class="main_left">
        <label>文化祭名</label>
        <vue-twitter-counter
          :current-length="fesName.length"
          danger-at="13"
          warn-length="4"
          safe="#00CC33"
          warn="#B8860B"
          danger="red"
          style="display:inline-block;text-align:left;font-size:1rem;padding-left:10px;">
        </vue-twitter-counter><br>
        <input v-model="fesName" type="text" placeholder="１３文字以内(全角のとき)"><br>
        <label>日付</label>
        <vue-twitter-counter
          :current-length="fesDate.length"
          danger-at="16"
          warn-length="5"
          safe="#00CC33"
          warn="#B8860B"
          danger="red"
          style="display:inline-block;text-align:left;font-size:1rem;padding-left:10px;">
        </vue-twitter-counter><br>
        <input v-model="fesDate" type="text" placeholder="１６文字以内(全角のとき)"><br>
        <label>学校名or開催場所</label>
        <vue-twitter-counter
          :current-length="fesPlace.length"
          danger-at="16"
          warn-length="5"
          safe="#00CC33"
          warn="#B8860B"
          danger="red"
          style="display:inline-block;text-align:left;font-size:1rem;padding-left:10px;">
        </vue-twitter-counter><br>
        <input v-model="fesPlace" type="text" placeholder="１６文字以内(全角のとき)"><br>
        <label>スローガン</label>
        <vue-twitter-counter
          :current-length="fesSlogan.length"
          danger-at="16"
          warn-length="5"
          safe="#00CC33"
          warn="#B8860B"
          danger="red"
          style="display:inline-block;text-align:left;font-size:1rem;padding-left:10px;">
        </vue-twitter-counter><br>
        <input v-model="fesSlogan" type="text" placeholder="１６文字以内(全角のとき)"><br>
        <label>説明or概要</label>
        <vue-twitter-counter
          :current-length="fesInfo.length"
          danger-at="264"
          warn-length="88"
          safe="#00CC33"
          warn="#B8860B"
          danger="red"
          style="display:inline-block;text-align:left;font-size:1rem;padding-left:10px;">
        </vue-twitter-counter><br>
        <textarea v-model="fesInfo" placeholder="２６４文字以内(全角のとき)" rows="7"></textarea>
      </div>
      <div class="main_right">
        <img src="https://cdn.pixabay.com/photo/2012/04/14/17/22/note-34670_1280.png">
      </div>
    </div>
  </div>
</template>

<script>
import Vuex from '../store';
import { firestore } from '../firebase';
import VueTwitterCounter from 'vue-twitter-counter';
export default {
  components:{
    VueTwitterCounter
  },
  data(){
    return{
      uid:'',
      fesName:'',
      fesDate:'',
      fesPlace:'',
      fesSlogan:'',
      fesInfo:'',
      saving:false,
      success:false,
      error:false,
      errorMessage:'',
      saveStatus:'保存',
      saved:false
    };
  },
  created(){
    this.uid = Vuex.getters.idToken;
    var db = firestore;
    var docRef = db.collection("draft-festival").doc(this.uid);
    docRef.get().then((doc) => {
      if (doc.exists) {
        var data = doc.data();
        data.festivalName ? this.fesName = data.festivalName : this.fesName = '';
        data.date ? this.fesDate = data.date : this.fesDate = '';
        data.school ? this.fesPlace = data.school : this.fesPlace = '';
        data.slogan ? this.fesSlogan = data.slogan : this.fesSlogan = '';
        data.info ? this.fesInfo = data.info : this.fesInfo = '';
      }
    }).catch(() => {
      this.network(false,false,true,'読み込み失敗：画面をリロードしてください','保存',false);
    });
  },
  methods:{
    show(comp){
      this.$modal.show(comp);
    },
    save(){
      if (!this.saved) {
        this.error = false;
        this.saving = true;

        if (this.fesName != '' && this.fesDate != '' && this.fesPlace != '' && this.fesSlogan != '' && this.fesInfo != '') {
          var db = firestore;
          var docRef = db.collection("draft-festival").doc(this.uid);
          let displayName = Vuex.getters.userDisplayName;
          docRef.set({
            festivalName: this.fesName,
            date: this.fesDate,
            school: this.fesPlace,
            slogan: this.fesSlogan,
            info: this.fesInfo,
            owner:displayName
          },{ merge: true })
          .then(() => {
            this.network(false,true,false,'','完了(再保存はリロード)',true);
          })
          .catch(() => {
            this.network(false,false,true,'送信失敗：再度送信してください','保存',false);
          });
        } else this.network(false,false,true,'すべての情報を入力してください！','保存',false);
      }
    },
    network(saving,success,error,errorMessage,saveStatus,saved){
      this.saving = saving;
      this.success = success;
      this.error = error;
      this.errorMessage = errorMessage;
      this.saveStatus = saveStatus;
      this.saved = saved;
    }
  }
};
</script>

<style scoped>
.edit_main_zone{
  height: 100%;
  color:black;
}

.main_header{
  height: 60px;
  text-align: right;
  border-bottom: 1px solid gray;
}

.main_header button{
  margin: 13px;
  font-size: 1.7rem;
  font-weight: bold;
  padding: 3px 13px;
  background-color: deepskyblue;
  color: white;
  border: none;
  border-radius: 7px;
  cursor: pointer;
}

.savedBtn{
  opacity:0.5;
}

.main_field{
  height: 100%;
  width: 100%;
  position: relative;
  margin-top: 10px;
}

.main_left{
  position: absolute;
  top:0;
  left:0;
  width: 40%;
  background-color: burlywood;
  border-radius:7px;
  box-shadow: 10px 10px 10px rgba(0,0,0,0.4);
  padding: 15px;
  font-size: 1.5rem;
  font-weight: bold;
  text-align: center;
}

.main_left input, .main_left textarea{
  margin: 10px 0;
  width: 100%;
  border: none;
  border-radius: 5px;
  padding: 5px;
}

.main_right{
  position: absolute;
  top:0;
  right:0;
  width: 60%;
}

.main_right img{
  width: 100%;
  object-fit: contain;
  padding: 35px;
}
</style>
