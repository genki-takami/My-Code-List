<template>
  <div class="edit_notices_zone">
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
      <span @click="show('Notices')" class="modal_guaide_btn"><i class="far fa-file-alt"></i> 使用ガイド<i class="fas fa-chevron-circle-right"></i></span>
    </div>
    <div class="main_field">
      <div class="main_left">
        <div style="text-align:left;font-size:2.3rem;"><label @click="addNew" style="cursor:pointer;"><i class="fas fa-plus-circle"></i></label></div>
        <label>件名</label><br>
        <input v-model="editingNotice.noticeTitle" type="text" placeholder="お知らせのタイトル">
        <label>内容</label>
        <vue-twitter-counter
          :current-length="editingNotice.noticeContent.length"
          danger-at="100"
          warn-length="33"
          safe="lime"
          warn="orange"
          danger="red"
          style="display:inline-block;text-align:left;font-size:1rem;padding-left:10px;">
        </vue-twitter-counter><br>
        <textarea v-model="editingNotice.noticeContent" rows="3" placeholder="１００文字以内"></textarea>
        <button @click="completeEdit" type="button" class="add_edit_btn">追加/編集完了</button>
        <label @click="deleteOne" style="cursor:pointer;font-size:2.3rem;margin-left:50px;">
          <div v-show="showTrash" style="display:inline-block;">
            <i class="fas fa-trash-alt"></i>
          </div>
          <div v-show="showLoad" style="display:inline-block;">
            <i class="fas fa-sync-alt fa-spin"></i>
          </div>
        </label>
      </div>
      <div class="main_right">
        <h2>お知らせリスト<br><span style="font-size:1.2rem;">＜＜＜ ドラッグで並び替えができます ＞＞＞</span></h2>
        <draggable :list="notices" :disabled="!enabled" class="list-group" ghost-class="ghost" @start="dragging = true" @end="dragging = false">
          <div class="list-group-item drag_item" v-for="(element,index) in notices" :key="element.noticeTitle" @click="selectOne(element,index)">
            {{ element.noticeTitle }}
          </div>
        </draggable>
      </div>
    </div>
  </div>
</template>

<script>
import draggable from 'vuedraggable';
import Vuex from '../store';
import { firestore, updateField } from '../firebase';
import { uuid } from "vue-uuid";
import VueTwitterCounter from 'vue-twitter-counter';
export default {
  components:{
    draggable,
    VueTwitterCounter
  },
  data(){
    return{
      uid:'',
      editingNotice:{
        id:null,
        date:null,
        noticeTitle:'',
        noticeContent:''
      },
      notices:[],
      enabled: true,
      dragging: false,
      saving:false,
      success:false,
      error:false,
      errorMessage:'',
      saveStatus:'保存',
      saved:false,
      isNew:true,
      selectedIndex:9999,
      showTrash:true,
      showLoad:false
    };
  },
  created(){
    this.saving = true;
    this.uid = Vuex.getters.idToken;
    var db = firestore;
    var docRef = db.collection("NOTICE").doc(this.uid);
    docRef.get().then((doc) => {
      if (doc.exists) {
        var data = doc.data();
        let list = data.list;
        for (var i = 0; i < list.length; i++) {
          let objectId = list[i];
          data[objectId]["id"] = objectId;
          this.notices.push(data[objectId]);
        }
      }
      this.saving = false;
    }).catch(() => {
      this.network(false,false,true,'読み込み失敗：画面をリロードしてください','保存',false);
    });
  },
  methods:{
    show(comp){
      this.$modal.show(comp);
    },
    selectOne(argument,index){
      var arg = Object.assign({},argument);
      this.editingNotice.id = arg.id;
      this.editingNotice.date = arg.date;
      this.editingNotice.noticeTitle = arg.noticeTitle;
      this.editingNotice.noticeContent = arg.noticeContent;
      this.isNew = false;
      this.selectedIndex = index;
    },
    addNew(){
      this.editingNotice.id = null;
      this.editingNotice.date = null;
      this.editingNotice.noticeTitle = '';
      this.editingNotice.noticeContent = '';
      this.isNew = true;
      this.selectedIndex = 9999;
      this.showTrash = true;
      this.showLoad = false;
    },
    completeEdit(){
      if (this.isNew) {
        this.editingNotice.id = uuid.v4();
        this.editingNotice.date = updateField.Timestamp.fromDate(new Date());
        if (this.editingNotice.noticeTitle == '') this.editingNotice.noticeTitle = 'データなし' + Math.floor( Math.random() * 101 );
        var newObject = Object.assign({},this.editingNotice);
        this.notices.push(newObject);
      }else {
        this.editingNotice.date = updateField.Timestamp.fromDate(new Date());
        var fixObject = Object.assign({},this.editingNotice);
        this.notices[this.selectedIndex] = fixObject;
      }
      this.addNew();
    },
    save(){
      if (!this.saved) {
        this.error = false;
        this.saving = true;

        if (this.notices.length != 0) {
          var db = firestore;
          var batch = db.batch();
          var docRef = db.collection("NOTICE").doc(this.uid);
          var draftRef = db.collection('draft-festival').doc(this.uid);
          let renewObject = this.makeObject();
          batch.set(docRef,renewObject);
          batch.set(draftRef,{database:{notice:this.notices.length}},{merge: true});
          batch.commit().then(() => {
            this.network(false,true,false,'','完了(再保存はリロード)',true);
          }).catch(() => {
            this.network(false,false,true,'送信失敗：再度送信してください','保存',false);
          });
        } else this.network(false,false,true,'エラー：ひとつ以上データを挿入してください','保存',false);
      }
    },
    makeObject(){
      var finalObject = {};
      var listArray = [];
      for (var i = 0; i < this.notices.length; i++) {
        listArray.push(this.notices[i].id);
        var copyObject = Object.assign({},this.notices[i]);
        finalObject[this.notices[i].id] = copyObject;
        delete finalObject[this.notices[i].id].id;
      }
      finalObject.list = listArray;
      return finalObject;
    },
    deleteOne(){
      if (this.selectedIndex != 9999 && this.showTrash) {
        this.showTrash = false;
        this.showLoad = true;
        this.notices.splice(this.selectedIndex, 1);
        this.addNew();
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
.edit_notices_zone{
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
  background-color:cadetblue;
  border-radius:7px;
  box-shadow: 10px 10px 10px rgba(0,0,0,0.4);
  padding: 15px;
  font-size: 1.5rem;
  font-weight: bold;
  text-align: center;
  color: white;
}

.main_left input, .main_left textarea{
  margin: 10px 0;
  width: 100%;
  border: none;
  border-radius: 5px;
  padding: 5px;
}

.add_edit_btn{
  font-size:2rem;
  border-radius: 4px;
  letter-spacing: 5px;
  cursor:pointer;
}

.main_right{
  position: absolute;
  top:0;
  right:0;
  width: 60%;
  padding: 0 40px 0;
  text-align: center;
  height:1000px;
  overflow-y:auto;
}

.drag_item{
  color: brown;
  display: block;
  font-size: 1.5rem;
  background-color:yellowgreen;
  line-height:4rem;
  border-left:5px solid darkcyan;
  border-right:5px solid darkcyan;
  margin-bottom: 2px;
  font-weight: bold;
  cursor: pointer;
}

.drag_item:hover{
  background-color:darkcyan;
}

.ghost {
  opacity: 0.5;
  background: #c8ebfb;
}
</style>
