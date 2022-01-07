<template>
  <div class="edit_links_zone">
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
      <span @click="show('Links')" class="modal_guaide_btn"><i class="far fa-file-alt"></i> 使用ガイド<i class="fas fa-chevron-circle-right"></i></span>
    </div>
    <div class="main_field">
      <div class="main_left">
        <label>リンク名 １</label><br>
        <input v-model="linkTitle1" type="text" placeholder="ホームページ名など"><br>
        <label>URL １</label><br>
        <input v-model="linkURL1" type="text" placeholder="https://www/〇〇.com"><br>
        <label>リンク名 ２</label><br>
        <input v-model="linkTitle2" type="text" placeholder="SNSアカウント名など"><br>
        <label>URL ２</label><br>
        <input v-model="linkURL2" type="text" placeholder="https://www/〇〇.com"><br>
      </div>
      <div class="main_right">
        <img src="https://cdn.pixabay.com/photo/2020/07/31/15/39/workplace-5453359_1280.png">
      </div>
    </div>
  </div>
</template>

<script>
import Vuex from '../store';
import { firestore } from '../firebase';
export default {
  data(){
    return{
      uid:'',
      linkTitle1:'',
      linkURL1:'',
      linkTitle2:'',
      linkURL2:'',
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
        if (data.link) {
          data.link.title1 ? this.linkTitle1 = data.link.title1 : this.linkTitle1 = '';
          data.link.url1 ? this.linkURL1 = data.link.url1 : this.linkURL1 = '';
          data.link.title2 ? this.linkTitle2 = data.link.title2 : this.linkTitle2 = '';
          data.link.url2 ? this.linkURL2 = data.link.url2 : this.linkURL2 = '';
        }
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

        if ((this.linkTitle1 != '' && this.linkURL1 != '') || (this.linkTitle2 != '' && this.linkURL2 != '')) {
          var db = firestore;
          var docRef = db.collection("draft-festival").doc(this.uid);
          docRef.set({
            link:{
              title1:this.linkTitle1,
              url1:this.linkURL1,
              title2:this.linkTitle2,
              url2:this.linkURL2
            }
          },{ merge: true })
          .then(() => {
            this.network(false,true,false,'','完了(再保存はリロード)',true);
          })
          .catch(() => {
            this.network(false,false,true,'送信失敗：再度送信してください','保存',false);
          });
        } else this.network(false,false,true,'１セット以上入力してください！','保存',false);
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
.edit_links_zone{
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
  background-color: cornflowerblue;
  border-radius:7px;
  box-shadow: 10px 10px 10px rgba(0,0,0,0.4);
  padding: 15px;
  font-size: 1.5rem;
  font-weight: bold;
  text-align: center;
  color: white;
}

.main_left input{
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
  padding: 0 35px;
}
</style>
