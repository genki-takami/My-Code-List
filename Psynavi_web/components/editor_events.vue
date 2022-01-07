<template>
  <div class="edit_events_zone">
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
      <p v-if="redelete" @click="doRedelete" style="margin:0;color:blue;text-align:center;cursor:pointer;">もう一度削除する(ここをクリック)</p>
    </div>
    <div style="margin:10px 0 -9px -6rem;">
      <span @click="show('Events')" class="modal_guaide_btn"><i class="far fa-file-alt"></i> 使用ガイド<i class="fas fa-chevron-circle-right"></i></span>
    </div>
    <div class="main_field">
      <div class="main_left">
        <div class="event_editing_area">
          <div style="text-align:left;font-size:2.3rem;"><label @click="addNew" style="cursor:pointer;"><i class="fas fa-plus-circle"></i></label></div>
          <label>
            データID<br>
            <span style="font-size:1.1rem;color:darkblue;">{{ editingEvent.id ? editingEvent.id : 'まだありません' }}</span>
          </label><br>
          <label>イベント名</label><br>
          <input v-model="editingEvent.eventTitle" type="text" placeholder="(例) 〇〇コンテスト" :disabled="disabled">
          <label>日時</label><br>
          <input v-model="editingEvent.eventDate" type="text" placeholder="〇〇日 13:00~">
          <label>内容</label>
          <vue-twitter-counter
            :current-length="editingEvent.caption.length"
            danger-at="200"
            warn-length="66"
            safe="#0099FF"
            warn="yellow"
            danger="red"
            style="display:inline-block;text-align:left;font-size:1rem;padding-left:10px;">
          </vue-twitter-counter><br>
          <textarea v-model="editingEvent.caption" rows="5" placeholder="２００文字以内"></textarea>
          <div class="event_image_section">
            <label>画像リスト </label><input type="file" @change="onChange"><br>
            <ul style="margin-top:0;padding-left:20px;">
              <div v-for="(item,fileIndex) in editingEvent.images" :key="fileIndex" class="event_image_list" @click="tapOne(item,fileIndex)">
                <li>{{ item.fileName }}</li>
              </div>
            </ul>
          </div>
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
        <div v-if="editingEvent.images.length >= 1" class="event_image_preview">
          <h3 style="margin-top:0;">イベント画像のプレビュー</h3>
          <img :src="preview.src">
          <p style="text-align:left;margin:0;">説明/キャプション</p>
          <textarea v-model="caption.text" rows="5" placeholder="２００文字程度" class="event_caption_edit"></textarea>
          <p style="margin:0 0 10px 0;font-size:1.25rem;">※「追加/編集完了」の押し忘れに注意して下さい</p>
          <button @click="editImage" type="button" style="width:60px;height:35px;margin:0 10px;cursor:pointer;"> <i class="fas fa-sync-alt fa-2x" style="color:green"></i> </button>
          <button @click="deleteImage" type="button" style="width:60px;height:35px;margin:0 10px;cursor:pointer;"> <i class="fas fa-trash-alt fa-2x" style="color:black"></i> </button>
          <span v-if="showResult" style="font-size: 1.6rem;color:black;">{{ resultMessage }}</span>
        </div>
      </div>
      <div class="main_right">
        <h2>イベントリスト<br><span style="font-size:1.2rem;">＜＜＜ ドラッグで並び替えができます ＞＞＞</span></h2>
        <draggable :list="events" :disabled="!enabled" class="list-group" ghost-class="ghost" @start="dragging = true" @end="dragging = false">
          <div class="list-group-item drag_item" v-for="(element,index) in events" :key="element.eventTitle" @click="selectOne(element,index)">
            {{ element.eventTitle }}
          </div>
        </draggable>
      </div>
    </div>
  </div>
</template>

<script>
import draggable from 'vuedraggable';
import Vuex from '../store';
import { firestore, storage } from '../firebase';
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
      editingEvent:{
        id:null,
        imageRefs:[],
        images:[],
        caption:'',
        eventDate:'',
        eventTitle:'',
        imageCaptions:[]
      },
      events:[],
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
      pushTask:0,
      preview:{},
      caption:{},
      showResult:false,
      resultMessage:'',
      focusIndex:9999,
      disabled:false,
      errorCount:0,
      redelete:false,
      redeleteList:[],
      showTrash:true,
      showLoad:false,
      showError:false
    };
  },
  created(){
    this.saving = true;
    this.uid = Vuex.getters.idToken;
    firestore.collection("EVENTS").doc(this.uid).get().then((doc) => {
      if (doc.exists) {
        var data = doc.data();
        data.list.forEach(objectId => {
          var one = data[objectId];
          one["id"] = objectId;
          one["images"] = [];
          storage.child(this.uid).child(`event-image/${one.eventTitle}`).listAll().then(res => {
            var refs = [];
            res.items.forEach(itemRef => {
              refs.push(itemRef.fullPath);
            });
            one["imageRefs"] = refs;
            this.events.push(data[objectId]);
            this.saving = false;
          }).catch(() => {
            this.network(false,false,true,`「${one.eventTitle}」には画像が１つもアップロードされていません`,'保存',false);
            one["imageRefs"] = [];
            this.events.push(one);
          });
        });
      } else this.saving = false;
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
      this.editingEvent.id = arg.id;
      if (arg.imageRefs.length >= 1) {
        this.editingEvent.imageRefs = arg.imageRefs;
        this.disabled = true;
        if (arg.images.length >= 1) {
          this.editingEvent.images = arg.images.filter((image) => image.psynavi == 'FROM-LOCAL-STORAGE');
        } else this.editingEvent.images = [];
        this.getImageFromStorage(arg.imageRefs,arg.imageCaptions);
      } else {
        this.editingEvent.imageRefs = [];
        this.editingEvent.images = arg.images;
        arg.imageCaptions ? this.editingEvent.imageCaptions = arg.imageCaptions : this.editingEvent.imageCaptions = [] ;
        this.disabled = false;
      }
      this.editingEvent.caption = arg.caption;
      this.editingEvent.eventTitle = arg.eventTitle;
      this.editingEvent.eventDate = arg.eventDate;
      this.isNew = false;
      this.selectedIndex = index;
      this.focusIndex = 9999;
      this.preview = {};
      this.caption = {};
    },
    addNew(){
      this.editingEvent.id = null;
      this.editingEvent.imageRefs = [];
      this.editingEvent.images = [];
      this.editingEvent.caption = '';
      this.editingEvent.eventDate = '';
      this.editingEvent.eventTitle = '';
      this.editingEvent.imageCaptions = [];
      this.isNew = true;
      this.selectedIndex = 9999;
      this.focusIndex = 9999;
      this.preview = {};
      this.caption = {};
      this.disabled = false;
      this.showTrash = true;
      this.showLoad = false;
      this.showError = false;
    },
    completeEdit(){
      if (this.isNew) {
        this.editingEvent.id = uuid.v4();
        if (this.editingEvent.eventTitle == '') this.editingEvent.eventTitle = 'タイトルなし' + Math.floor( Math.random() * 101 );
        var newObject = Object.assign({},this.editingEvent);
        this.events.push(newObject);
      } else {
        var fixObject = Object.assign({},this.editingEvent);
        this.events[this.selectedIndex] = fixObject;
      }
      this.addNew();
    },
    save(){
      if (!this.saved) {
        this.error = false;
        this.saving = true;

        if (this.events.length >= 1) {
          this.pushStorage();
        } else this.network(false,false,true,'エラー：１つ以上データを挿入してください','保存',false);
      }
    },
    pushStorage(){
      const targetList = this.events.filter((item) => item.images.length >= 1);
      if (targetList.length >= 1) {
        targetList.forEach(target1 => {
          this.pushTask += this.countTask(target1.images);
        });
        this.pushTask += 1;// firestore
        if (this.pushTask >= 2) {
          let folderRef = storage.child(this.uid).child('event-image');
          targetList.forEach(target2 => {
            let titleRef = folderRef.child(target2.eventTitle);
            target2.images.forEach(file => {
              if (file.psynavi == 'FROM-LOCAL-STORAGE') {
                var metadata = {
                  contentType: file.type,
                  name: file.fileName
                };
                titleRef.child(file.fileName).put(file,metadata).then(() => {
                  this.pushTask -= 1;
                  if (this.pushTask == 1) this.pushFireStore();
                }).catch(() => {
                  this.network(true,false,true,'エラー：一部の画像の送信に失敗','保存',false);
                  this.pushTask -= 1;
                  this.errorCount += 1;
                  if (this.pushTask == 1) this.pushFireStore();
                });
              }
            });
          });
        } else {
          this.pushTask = 1;
          this.pushFireStore();
        }
      } else {
        this.pushTask = 1;
        this.pushFireStore();
      }
    },
    countTask(arg){
      let count = arg.filter((image) => image.psynavi == 'FROM-LOCAL-STORAGE').length;
      return count;
    },
    pushFireStore(){
      var db = firestore;
      var batch = db.batch();
      var docRef = db.collection("EVENTS").doc(this.uid);
      var draftRef = db.collection('draft-festival').doc(this.uid);
      let renewObject = this.makeObject();
      let makedRefs = this.makeFullPath();
      batch.set(docRef,renewObject);
      batch.set(draftRef,{
        database:{
          event:this.events.length,
          eventImage:makedRefs
        }
      },{merge: true});
      batch.commit().then(() => {
        this.pushTask -= 1;
        if (this.pushTask == 0 && this.errorCount == 0){
          this.network(false,true,false,'','完了(再保存はリロード)',true)
        } else {
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
      this.events.forEach(event => {
        listArray.push(event.id);
        var copyObject = Object.assign({},event);
        finalObject[event.id] = copyObject;
        delete finalObject[event.id].id;
        delete finalObject[event.id].imageRefs;
        delete finalObject[event.id].images;
      });
      finalObject.list = listArray;
      return finalObject;
    },
    makeFullPath(){
      var refs = [];
      this.events.forEach(event => {
        if (event.imageRefs.length != 0) refs = refs.concat(event.imageRefs);
        if (event.images.length != 0) {
          event.images.forEach(image => {
            let imageName = image.fileName;
            refs.push(`${this.uid}/event-image/${event.eventTitle}/${imageName}`);
          });
        }
      });
      const resetRefs = [...new Set(refs)];
      return resetRefs;
    },
    onChange(event) {
      const files = event.target.files;
      if (files.length !== 1 || files[0].type.indexOf("image") !== 0) return;
      this.readImage(files[0],false);
    },
    readImage(file,tap){
      if (tap) {
        let reader = new FileReader();
        reader.onload = this.loadImage;
        reader.readAsDataURL(file);
      } else {
        if (file.size > 8406550) {
          this.network(false,false,true,'画像サイズが大きすぎます','保存',false);
          return;
        } else if (file.type != 'image/jpeg') {
          this.network(false,false,true,'送信可能な画像の拡張子は「.jpg」のみです','保存',false);
          return;
        }
        let reader = new FileReader();
        reader.onload = this.loadImage;
        reader.readAsDataURL(file);
        file.psynavi = 'FROM-LOCAL-STORAGE';
        var str = uuid.v4().substr(0,10);
        file.fileName = str + '.jpg';
        let firstCaption = 'まだ設定されていません';
        this.editingEvent.images.unshift(file);
        let payload = str + firstCaption;
        this.editingEvent.imageCaptions.unshift(payload);
        this.caption = {text:firstCaption};
        this.showResult = false;
        this.focusIndex = 0;
      }
    },
    loadImage(e) {
      this.preview = {src:e.target.result};
    },
    tapOne(item,fileIndex){
      this.showResult = false;
      this.focusIndex = fileIndex;
      if (item.psynavi == 'FROM-LOCAL-STORAGE') {
        this.readImage(item,true);
      } else if (item.psynavi == 'FROM-CLOUD-STORAGE') {
        this.loadImage(item);
      }
      var str = this.editingEvent.imageCaptions[fileIndex];
      this.caption = {text:str.slice(10)};
    },
    getImageFromStorage(list,captions){
      this.error = false;
      var getTask = list.length;
      list.forEach(path => {
        storage.child(path).getMetadata().then(metadata => {
          var srcObject = {
            target : {result:null},
            psynavi : 'FROM-CLOUD-STORAGE',
            fileName : metadata.name
          };
          storage.child(metadata.fullPath).getDownloadURL().then(url => {
            srcObject.target.result = url;
            this.editingEvent.images.push(srcObject);
            getTask -= 1;
            if (getTask == 0) {
              this.editingEvent.imageCaptions = captions;
              var arr = captions.concat();
              arr = arr.map(str => {
                return str.substr(0,10);
              });
              this.editingEvent.images.sort((x, y) => {
                return arr.indexOf(x.fileName.substr(0,10)) - arr.indexOf(y.fileName.substr(0,10));
              });
            }
          }).catch(() => {
            this.network(false,false,true,'読み込み失敗：リストから選択し直してください','保存',false);
            this.editingEvent.images = [];
            return ;
          });
        }).catch(() => {
          this.network(false,false,true,'読み込み失敗：リストから選択し直してください','保存',false);
          this.editingEvent.images = [];
          return ;
        });
      });
    },
    editImage(){
      if (this.focusIndex != 9999 && !this.saved) {
        this.showResult = true;
        if (this.caption.text.length >= 1) {
          let vertualObject = Object.assign({},this.caption);
          var str = this.editingEvent.imageCaptions[this.focusIndex];
          let headText = str.substr(0,10);
          let newText = headText + vertualObject.text;
          this.editingEvent.imageCaptions[this.focusIndex] = newText;
          this.resultMessage = '追記しました';
        } else {
          this.resultMessage = 'エラー：文字を入力してください';
        }
      }
    },
    deleteImage(){
      if (this.focusIndex != 9999 && !this.saved) {
        let from = this.editingEvent.images[this.focusIndex];
        if (from.psynavi == 'FROM-CLOUD-STORAGE') {
          let removeImageRef = storage.child(`${this.uid}/event-image/${this.editingEvent.eventTitle}/${from.fileName}`);
          removeImageRef.delete().then(() => {
            let refNumber = this.editingEvent.imageRefs.indexOf(`${removeImageRef.fullPath}`);
            this.editingEvent.imageRefs.splice(refNumber,1);
            this.resetCaptionArea();
          }).catch(() => {
            this.showResult = true;
            this.resultMessage = 'エラー：もう一度、押してください';
          });
        } else if (from.psynavi == 'FROM-LOCAL-STORAGE') {
          this.resetCaptionArea();
        }
      }
    },
    resetCaptionArea(){
      this.editingEvent.images.splice(this.focusIndex, 1);
      this.editingEvent.imageCaptions.splice(this.focusIndex, 1);
      this.preview = {};
      this.caption = {};
      this.focusIndex = 9999;
      this.showResult = true;
      this.resultMessage = '削除しました';
    },
    deleteOne(){
      if (this.selectedIndex != 9999 && this.showTrash && !this.saved) {
        this.showTrash = false;
        this.showLoad = true;
        let refs = this.events[this.selectedIndex].imageRefs;
        if (refs.length >= 1) {
          var deleteTasks = refs.length;
          refs.forEach(ref => {
            storage.child(ref).delete().then(() => {
              deleteTasks -= 1;
              if (deleteTasks == 0) {
                this.afterDelete(true);
              }
            }).catch(() => {
              this.network(false,false,true,'エラー：一部の画像の削除に失敗','保存',false);
              this.redelete = true;
              this.redeleteList.push(ref);
              deleteTasks -= 1;
              if (deleteTasks == 0) {
                this.afterDelete(true);
              }
            });
          });
        } else {
          this.afterDelete(false);
        }
      }
    },
    afterDelete(ok){
      this.events.splice(this.selectedIndex, 1);
      this.addNew();
      if (ok) {
        if (this.redelete) {
          this.deleteIconStatus(true,false,false,true);
        }
      }
    },
    doRedelete(){
      var deleteTasks = this.redeleteList.length;
      if (deleteTasks >= 1) {
        this.saving = true;
        this.redeleteList.forEach(path => {
          storage.child(path).delete().then(() => {
            deleteTasks -= 1;
            if (deleteTasks == 0) {
              this.network(false,false,false,'','保存',false);
              this.redeleteList = [];
              this.addNew();
              this.deleteIconStatus(false,true,false,false);
            }
          }).catch(() => {
            this.network(false,false,true,'再エラー：運営者にお問い合わせください','----',true);
            this.deleteIconStatus(false,false,false,true);
          });
        });
      }
    },
    deleteIconStatus(r,t,l,e){
      this.redelete = r;
      this.showTrash = t;
      this.showLoad = l;
      this.showError = e;
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
.edit_events_zone{
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
  padding:10px;
}

.event_editing_area{
  width:100%;
  background-color:orange;
  border-radius:7px;
  box-shadow: 10px 10px 10px rgba(0,0,0,0.4);
  padding: 15px;
  font-size: 1.5rem;
  font-weight: bold;
  text-align: center;
  color: white;
}

.event_editing_area input, .event_editing_area textarea{
  margin: 10px 0;
  width: 100%;
  border: none;
  border-radius: 5px;
  padding: 5px;
}

.event_image_list{
  text-align: left;
  cursor: pointer;
}

.event_image_list:hover{
  color:deepskyblue;
}

.event_image_section{
  max-height:231px;
  overflow-y: auto;
}

.event_image_section input{
  margin:0;
  width:90px;
  padding:0;
  font-size:1rem;
}

.add_edit_btn{
  font-size:2rem;
  border-radius: 4px;
  letter-spacing: 5px;
  cursor:pointer;
}

.event_image_preview{
  width:100%;
  padding:15px;
  font-size: 1.5rem;
  font-weight: bold;
  text-align: center;
  margin-top:15px;
  border:1px dashed black;
  border-radius:6px;
}

.event_image_preview img{
  width:100%;
  height:200px;
  background-color:gray;
  object-fit: contain;
}

.event_caption_edit{
  margin: 10px 0 0 0;
  width: 100%;
  border-radius: 5px;
  padding: 5px;
}

.main_right{
  position: absolute;
  top:0;
  right:0;
  width:60%;
  padding: 0 40px 0;
  text-align: center;
  height:1000px;
  overflow-y:auto;
}

.drag_item{
  color: crimson;
  display: block;
  font-size: 1.5rem;
  background-color:bisque;
  line-height:4rem;
  border-left:5px solid coral;
  border-right:5px solid coral;
  margin-bottom: 2px;
  font-weight: bold;
  cursor: pointer;
}

.drag_item:hover{
  background-color:coral;
}

.ghost {
  opacity: 0.5;
  background: #c8ebfb;
}
</style>
