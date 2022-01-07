<template>
  <div class="edit_contents_zone">
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
      <span @click="show('Contents')" class="modal_guaide_btn"><i class="far fa-file-alt"></i> 使用ガイド<i class="fas fa-chevron-circle-right"></i></span>
    </div>
    <div class="main_field">
      <div class="main_left">
        <div style="text-align:left;font-size:2.3rem;"><label @click="addNew" style="cursor:pointer;"><i class="fas fa-plus-circle"></i></label></div>
        <label>
          データID<br>
          <span style="font-size:1.1rem;color:darkblue;">{{ editingContent.id ? editingContent.id : 'まだありません' }}</span><br>
          <i class="fas fa-chevron-circle-down"></i> クリックで画像を選択
        </label><br>
        <div class="content_image_box">
          <img :src="contentImage.src">
          <input type="file" @change="onChange">
        </div>
        <div class="s_or_d_checkbox">
          <span>ショップですか？ (ダブルクリック)</span><br>
          <rocker-switch :size="0.8" :value="checked" :labelOn="'YES'" :labelOff="'NO'" @change="isOn => checked = isOn"></rocker-switch>
        </div>
        <label>ショップ/展示名</label>
        <vue-twitter-counter
          :current-length="editingContent.name.length"
          danger-at="12"
          warn-length="4"
          safe="blue"
          warn="yellow"
          danger="#AA0000"
          style="display:inline-block;text-align:left;font-size:1rem;padding-left:10px;">
        </vue-twitter-counter><br>
        <input v-model="editingContent.name" type="text" placeholder="１２文字以内" :disabled="disabled">
        <label>タグ</label><br>
        <input v-model="editingContent.tag" type="text" placeholder="(例) ドリンク,酒,揚げ物,楽しい">
        <label>運営団体</label><br>
        <input v-model="editingContent.manager" type="text" placeholder="ショップ/展示を運営する団体の名前">
        <label>日時</label><br>
        <input v-model="editingContent.date" type="text" placeholder="運営日時">
        <label>場所</label><br>
        <input v-model="editingContent.place" type="text" placeholder="運営場所">
        <label>詳細</label>
        <vue-twitter-counter
          :current-length="editingContent.info.length"
          danger-at="100"
          warn-length="33"
          safe="blue"
          warn="yellow"
          danger="#AA0000"
          style="display:inline-block;text-align:left;font-size:1rem;padding-left:10px;">
        </vue-twitter-counter><br>
        <textarea v-model="editingContent.info" rows="3" placeholder="１００文字以内"></textarea>
        <label>団体詳細</label>
        <vue-twitter-counter
          :current-length="editingContent.managerInfo.length"
          danger-at="100"
          warn-length="33"
          safe="blue"
          warn="yellow"
          danger="#AA0000"
          style="display:inline-block;text-align:left;font-size:1rem;padding-left:10px;">
        </vue-twitter-counter><br>
        <textarea v-model="editingContent.managerInfo" rows="3" placeholder="１００文字以内"></textarea>
        <button @click="completeEdit" type="button" class="add_edit_btn">追加/編集完了</button>
        <label @click="deleteOne" style="cursor:pointer;font-size:2.3rem;margin-left:50px;">
          <div v-show="showTrash" style="display:inline-block;">
            <i class="fas fa-trash-alt"></i>
          </div>
          <div v-show="showLoad" style="display:inline-block;">
            <i class="fas fa-sync-alt fa-spin"></i>
          </div>
          <div v-show="showError" style="display:inline-block;">
            <i class="fas fa-arrow-alt-circle-up faa-bounce animated"></i>
          </div>
        </label>
      </div>
      <div class="main_right">
        <h2>ショップ/展示リスト<br><span style="font-size:1.2rem;">＜＜＜ ドラッグで並び替えができます ＞＞＞</span></h2>
        <draggable :list="contents" :disabled="!enabled" class="list-group" ghost-class="ghost" @start="dragging = true" @end="dragging = false">
          <div class="list-group-item drag_item" v-for="(element,index) in contents" :key="element.name" @click="selectOne(element,index)">
            {{ element.name }}
          </div>
        </draggable>
      </div>
    </div>
  </div>
</template>

<script>
import RockerSwitch from "vue-rocker-switch";
import "vue-rocker-switch/dist/vue-rocker-switch.css";
import draggable from 'vuedraggable';
import Vuex from '../store';
import { firestore, storage } from '../firebase';
import { uuid } from "vue-uuid";
import VueTwitterCounter from 'vue-twitter-counter';
export default {
  components:{
    draggable,
    'rocker-switch':RockerSwitch,
    VueTwitterCounter
  },
  data(){
    return{
      uid:'',
      editingContent:{
        id:null,
        imageFile:null,
        fromStorage:false,
        switchFlag:false,
        name:'',
        tag:'',
        manager:'',
        date:'',
        place:'',
        info:'',
        managerInfo:''
      },
      contentImage:{},
      contents:[],
      checked:false,
      enabled: true,
      dragging: false,
      saving:false,
      success:false,
      error:false,
      errorMessage:'',
      isNew:true,
      selectedIndex:9999,
      saveStatus:'保存',
      saved:false,
      pushTask:0,
      errorCount:0,
      showTrash:true,
      showLoad:false,
      showError:false,
      disabled:false
    };
  },
  created(){
    this.saving = true;
    this.uid = Vuex.getters.idToken;
    var db = firestore;
    var docRef = db.collection("CONTENTS").doc(this.uid);
    docRef.get().then((doc) => {
      if (doc.exists) {
        var data = doc.data();
        let list = data.list;
        for (var i = 0; i < list.length; i++) {
          let objectId = list[i];
          data[objectId]["id"] = objectId;
          data[objectId]["imageFile"] = null;
          data[objectId]["fromStorage"] = true;
          this.contents.push(data[objectId]);
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
      this.editingContent.id = arg.id;
      this.readImage(arg.imageFile);
      if (arg.fromStorage) {
        this.editingContent.fromStorage = true;
        this.pullFromStorage(arg.name);
        this.disabled = true;
      }else {
        this.editingContent.fromStorage = false;
        this.disabled = false;
      }
      this.editingContent.switchFlag = arg.switchFlag;
      this.checked = arg.switchFlag;
      this.editingContent.name = arg.name;
      this.editingContent.tag = arg.tag;
      this.editingContent.manager = arg.manager;
      this.editingContent.date = arg.date;
      this.editingContent.place = arg.place;
      this.editingContent.info = arg.info;
      this.editingContent.managerInfo = arg.managerInfo;
      this.isNew = false;
      this.selectedIndex = index;
    },
    addNew(){
      this.editingContent.id = null;
      this.editingContent.imageFile = null;
      this.editingContent.fromStorage = false;
      this.editingContent.switchFlag = false;
      this.checked = false;
      this.editingContent.name = '';
      this.editingContent.tag = '';
      this.editingContent.manager = '';
      this.editingContent.date = '';
      this.editingContent.place = '';
      this.editingContent.info = '';
      this.editingContent.managerInfo = '';
      this.isNew = true;
      this.selectedIndex = 9999;
      this.contentImage = {};
      this.showTrash = true;
      this.showLoad = false;
      this.showError = false;
      this.disabled = false;
    },
    completeEdit(){
      if (this.isNew) {
        this.editingContent.switchFlag = this.checked;
        this.editingContent.id = uuid.v4();
        if (this.editingContent.name == '') this.editingContent.name = 'データなし' + Math.floor( Math.random() * 101 );
        var newObject = Object.assign({},this.editingContent);
        this.contents.push(newObject);
      }else {
        this.editingContent.switchFlag = this.checked;
        var fixObject = Object.assign({},this.editingContent);
        this.contents[this.selectedIndex] = fixObject;
      }
      this.addNew();
    },
    save(){
      if (!this.saved) {
        this.error = false;
        this.saving = true;

        if (this.contents.length != 0) {
          const filterList = this.contents.filter((content) => content.fromStorage == false && content.imageFile == null);
          if (filterList.length >= 1) {
            this.saving = false;
            this.error = true;
            this.errorMessage = 'エラー：すべてに画像を必ず挿入してください';
          }else {
            this.pushStorage();
          }
        } else this.network(false,false,true,'エラー：ひとつ以上データを挿入してください','保存',false);
      }
    },
    pushStorage(){
      const targetList = this.contents.filter((content) => content.fromStorage == false);
      let targets = targetList.length;
      if (targets != 0) {
        this.pushTask = targets + 1;
        var storageRef = storage.child(this.uid).child("content-image");
        for (var targetIndex = 0; targetIndex < targets; targetIndex++) {
          let imageName = targetList[targetIndex].name + '.jpg';
          let imageRef = storageRef.child(imageName);
          let metadata = { contentType:'image/jpeg', name:imageName};
          imageRef.put(targetList[targetIndex].imageFile,metadata).then(() => {
            this.pushTask -= 1;
            if (this.pushTask == 1) this.pushFireStore();
          }).catch(() => {
            this.network(true,false,true,'エラー：一部の画像の送信に失敗','保存',false);
            this.pushTask -= 1;
            this.errorCount += 1;
            if (this.pushTask == 1) this.pushFireStore();
          });
        }
      }else {
        this.pushTask = 1;
        this.pushFireStore();
      }
    },
    pushFireStore(){
      var db = firestore;
      var batch = db.batch();
      var docRef = db.collection("CONTENTS").doc(this.uid);
      var draftRef = db.collection('draft-festival').doc(this.uid);
      let renewObject = this.makeObject();
      let makedRefs = this.makeFullPath();
      let [shops,displays] = this.makeCount();
      batch.set(docRef,renewObject);
      batch.set(draftRef,{
        database:{
          shop:shops,
          display:displays,
          contentImage:makedRefs
        }
      },{merge: true});
      batch.commit().then(() => {
        this.pushTask -= 1;
        if (this.pushTask == 0 && this.errorCount == 0){
          this.network(false,true,false,'','完了(再保存はリロード)',true)
        }else {
          this.network(false,false,true,'送信失敗：すぐに再度保存してください','保存',false);
          this.errorCount = 0;
          this.pushTask = 0;
        }
      }).catch(() => {
        this.network(false,false,true,'送信失敗：すぐに再度保存してください','保存',false);
        this.pushTask = 0;
        this.errorCount = 0;
      });
    },
    makeObject(){
      var finalObject = {};
      var listArray = [];
      for (var i = 0; i < this.contents.length; i++) {
        listArray.push(this.contents[i].id);
        var copyObject = Object.assign({},this.contents[i]);
        finalObject[this.contents[i].id] = copyObject;
        delete finalObject[this.contents[i].id].id;
        delete finalObject[this.contents[i].id].imageFile;
        delete finalObject[this.contents[i].id].fromStorage;
      }
      finalObject.list = listArray;
      return finalObject;
    },
    makeFullPath(){
      var refs = [];
      for (var fullPathIndex = 0; fullPathIndex < this.contents.length; fullPathIndex++) {
        let imageName = this.contents[fullPathIndex].name + '.jpg';
        refs.push(`${this.uid}/content-image/${imageName}`);
      }
      return refs;
    },
    makeCount(){
      var shopCount = 0;
      var displayCount = 0;
      for (var countIndex = 0; countIndex < this.contents.length; countIndex++) {
        if (this.contents[countIndex].switchFlag) {
          shopCount += 1;
        }else {
          displayCount += 1;
        }
      }
      return [shopCount,displayCount];
    },
    onChange(event) {
      const files = event.target.files;
      if (files.length !== 1 || files[0].type.indexOf("image") !== 0) return;
      this.readImage(files[0]);
    },
    readImage(file) {
      if (file) {
        if (file.size > 8406550) {
          this.network(false,false,true,'画像サイズが大きすぎます','保存',false);
          return ;
        }else if (file.type != 'image/jpeg') {
          this.network(false,false,true,'送信可能な画像の拡張子は「.jpg」のみです','保存',false);
          return ;
        }
        let reader = new FileReader();
        reader.onload = this.loadImage;
        reader.readAsDataURL(file);
        this.editingContent.imageFile = file;
        if (this.editingContent.fromStorage) this.editingContent.fromStorage = false;
      }else {
        this.editingContent.imageFile = null;
        this.contentImage = {};
      }
    },
    loadImage(e) {
      this.contentImage = {src:e.target.result};
    },
    pullFromStorage(arg){
      let fileName = arg;
      storage.child(`${this.uid}/content-image/${fileName}.jpg`).getDownloadURL().then(url => {
        let srcObject = {target:{result:url}};
        this.loadImage(srcObject);
      }).catch(() => {
        this.network(false,false,true,'読み込み失敗：選択しなおしてください','保存',false);
      });
    },
    deleteOne(){
      if (this.selectedIndex != 9999 && this.showTrash && !this.saved) {
        this.showTrash = false;
        this.showLoad = true;
        let one = this.contents[this.selectedIndex];
        if (one.fromStorage) {
          var deleteRef = storage.child(this.uid).child("content-image").child(`${one.name}.jpg`);
          deleteRef.delete().then(() => {
            this.contents.splice(this.selectedIndex, 1);
            this.addNew();
          }).catch(() => {
            this.network(false,false,true,'画像の削除失敗：すでに保存された画像はショップ/展示名に紐付いています。編集前の名前で削除してください。','保存',false);
            this.showLoad = false;
            this.showError = true;
          });
        }else {
          this.contents.splice(this.selectedIndex, 1);
          this.addNew();
        }
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
.edit_contents_zone{
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
  background-color:hotpink;
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

.content_image_box{
  width: 266px;
  height: 150px;
  margin: 10px auto;
  position: relative;
}

.content_image_box img{
  width: 100%;
  height: 100%;
  background-color: gray;
  object-fit: contain;
}

.content_image_box > input{
  position: absolute;
  height: 100%;
  top: 0;
  left: 0;
  opacity: 0;
  cursor: pointer;
  padding: 0;
  margin: 0;
}

.s_or_d_checkbox{
  margin: 10px 0;
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
  color: black;
  font-size: 1.5rem;
  background-color: lightpink;
  line-height:4rem;
  border-left:5px solid deeppink;
  border-right:5px solid deeppink;
  margin-bottom: 2px;
  font-weight: bold;
  cursor: pointer;
}

.drag_item:hover{
  background:deeppink;
}

.ghost {
  opacity: 0.5;
  background: #c8ebfb;
}
</style>
