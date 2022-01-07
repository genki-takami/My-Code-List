<template>
  <div class="edit_images_zone">
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
    <div style="margin:10px 0 -6px -6rem;">
      <span @click="show('Images')" class="modal_guaide_btn"><i class="far fa-file-alt"></i> 使用ガイド<i class="fas fa-chevron-circle-right"></i></span>
    </div>
    <div class="main_field">
      <div class="icon_field">
        <div class="icon_left">
          <h1>アイコン画像</h1>
          <div class="image-input">
            <div
              class="image-input__field"
              :class="{'over': isDragOver1}"
              @dragover.prevent="onDrag('over1')"
              @dragleave="onDrag('leave1')"
              @drop.stop="onDrop($event,'icon')"
            >
              <input type="file" title @change="onChange($event,'icon')">
              <p>画像をドラッグ＆ドロップ<br>またはクリックでファイル選択</p>
            </div>
          </div>
        </div>
        <div class="icon_right">
          <img :src="image1.src">
          <div class="icon_info" style="display:inline-block;">
            <p>
              ＜画像情報＞<br>
              ファイル名：{{ icon.name }}<br>
              画像サイズ：{{ icon.size }} bytes<br>
              イメージタイプ：{{ icon.type }}<br>
              ステータス：<span class="image_status_ok" :class="{image_status_no:iconCancel}">{{ iconStatus }}</span>
            </p>
          </div>
        </div>
      </div>
      <div class="back_field">
        <div class="icon_left">
          <h1>背景画像</h1>
          <div class="image-input">
            <div
              class="image-input__field"
              :class="{'over': isDragOver2}"
              @dragover.prevent="onDrag('over2')"
              @dragleave="onDrag('leave2')"
              @drop.stop="onDrop($event,'back')"
            >
              <input type="file" title @change="onChange($event,'back')">
              <p>画像をドラッグ＆ドロップ<br>またはクリックでファイル選択</p>
            </div>
          </div>
        </div>
        <div class="icon_right back_right">
          <img :src="image2.src">
          <div class="icon_info" style="display:inline-block;">
            <p>
              ＜画像情報＞<br>
              ファイル名：{{ back.name }}<br>
              画像サイズ：{{ back.size }} bytes<br>
              イメージタイプ：{{ back.type }}<br>
              ステータス：<span class="image_status_ok" :class="{image_status_no:backCancel}">{{ backStatus }}</span>
            </p>
          </div>
        </div>
      </div>
      <div>
        <p style="font-size:1.4rem;border-left:10px solid deepskyblue;padding-left:5px;">
          ※アイコン画像の推奨タイプは縦横等比のスクエアです<br>
          ※背景画像の推奨タイプは１６：９の横長画像です<br>
          ※「JPEGイメージ(.jpg)」以外の画像は、無料ツールか標準ソフトにて変換/書き出しすることをオススメします
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import Vuex from '../store';
import { firestore, storage } from '../firebase';
export default {
  data() {
    return {
      uid:'',
      isDragOver1: false,
      isDragOver2:false,
      image1:{},
      image2:{},
      icon:{name:"",size:0,type:""},
      back:{name:"",size:0,type:""},
      iconStatus:'',
      iconCancel:false,
      backStatus:'',
      backCancel:false,
      saving:false,
      success:false,
      error:false,
      iconFromStorage:false,
      backFromStorage:false,
      possibleTask:0,
      saveStatus:'保存',
      saved:false,
      mergeObject:{}
    };
  },
  created(){
    this.uid = Vuex.getters.idToken;
    var storageRef = storage;
    var iconRef = storageRef.child(`${this.uid}/festival-icon.jpg`);
    var backRef = storageRef.child(`${this.uid}/festival-background-image.jpg`);
    iconRef.getDownloadURL()
            .then(url => {
              this.image1 = {src:url};
              iconRef.getMetadata()
                      .then(metadata => {
                        this.icon.name = metadata.name;
                        this.icon.size = metadata.size;
                        this.icon.type = metadata.contentType;
                        this.iconState(false,false,'保存済みの画像');
                        this.iconFromStorage = true;
                      }).catch(() => {
                        this.iconState(true,true,'エラー発生：画面をリロードしてください');
                      });
            });
    backRef.getDownloadURL()
            .then(url => {
              this.image2 = {src:url};
              backRef.getMetadata()
                      .then(metadata => {
                        this.back.name = metadata.name;
                        this.back.size = metadata.size;
                        this.back.type = metadata.contentType;
                        this.backState(false,false,'保存済みの画像');
                        this.backFromStorage = true;
                      }).catch(() => {
                        this.backState(true,true,'エラー発生：画面をリロードしてください');
                      });
            });
  },
  methods: {
    show(comp){
      this.$modal.show(comp);
    },
    save(){
      if (!this.saved) {
        this.error = false;
        this.saving = true;

        !this.iconFromStorage && Object.keys(this.image1).length !== 0 ? this.possibleTask += 1 : this.possibleTask += 0 ;
        !this.backFromStorage && Object.keys(this.image2).length !== 0 ? this.possibleTask += 1 : this.possibleTask += 0 ;

        if (!this.iconCancel && !this.backCancel && (Object.keys(this.image1).length !== 0 || Object.keys(this.image2).length !== 0)) {
          var storageRef = storage;
          if (!this.iconFromStorage && Object.keys(this.image1).length !== 0) {
            var iconRef = storageRef.child(`${this.uid}/festival-icon.jpg`);
            var metadata = { contentType: this.icon.type, name:'festival-icon.jpg' };
            iconRef.put(this.icon,metadata).then(() => {
              this.mergeObject.icon = `${this.uid}/festival-icon.jpg`;
              if (!this.error) {
                this.possibleTask -= 1;
                if (this.possibleTask == 0) this.pushFirestore();
              }
              this.iconState(false,false,'新規送信完了');
            }).catch(() => {
              this.network(false,false,true,'保存',false);
              this.iconState(true,true,'エラー発生：再度試してください');
              this.possibleTask = 0;
            });
          }
          if (!this.backFromStorage && Object.keys(this.image2).length !== 0) {
            var backRef = storageRef.child(`${this.uid}/festival-background-image.jpg`);
            var metadata2 = { contentType: this.back.type, name:'festival-background-image.jpg' };
            backRef.put(this.back,metadata2).then(() => {
              this.mergeObject.background = `${this.uid}/festival-background-image.jpg`;
              if (!this.error) {
                this.possibleTask -= 1;
                if (this.possibleTask == 0) this.pushFirestore();
              }
              this.backState(false,false,'新規送信完了');
            }).catch(() => {
              this.network(false,false,true,'保存',false);
              this.backState(true,true,'エラー発生：再度試してください');
              this.possibleTask = 0;
            });
          }
        } else this.network(false,false,true,'保存',false);
      }
    },
    pushFirestore(){
      firestore.collection('draft-festival').doc(this.uid).set({database:this.mergeObject},{ merge: true }).then(() => {
        this.network(false,true,false,'完了(再保存はリロード)',true);
      }).catch(() => {
        this.network(false,false,true,'保存',false);
        this.possibleTask = 0;
        this.iconState(true,true,'エラー発生：再度試してください');
        this.backState(true,true,'エラー発生：再度試してください');
      });
    },
    onDrag(type) {
      this.isDragOver1 = type === "over1";
      this.isDragOver2 = type === "over2";
    },
    onDrop(event,arg) {
      this.isDragOver1 = false;
      this.isDragOver2 = false;
      const files = event.dataTransfer.files;
      if (files.length !== 1 || files[0].type.indexOf("image") !== 0) {
        return;
      }
      arg == 'icon' ? this.readIcon(files[0]) : this.readBackground(files[0]);
    },
    onChange(event,arg) {
      const files = event.target.files;
      if (files.length !== 1 || files[0].type.indexOf("image") !== 0) {
        return;
      }
      arg == 'icon' ? this.readIcon(files[0]) : this.readBackground(files[0]);
    },
    readIcon(file) {
      let reader = new FileReader();
      reader.onload = this.loadIconimage;
      reader.readAsDataURL(file);
      this.icon = file;
      if (file.size > 8406550) {
        this.iconState(true,true,'画像サイズが大きすぎます');
      }else if (file.type != 'image/jpeg') {
        this.iconState(true,true,'送信可能な画像の拡張子は「.jpg」のみです');
      }else {
        this.iconState(false,false,'送信可能な画像サイズです');
      }
    },
    readBackground(file) {
      let reader = new FileReader();
      reader.onload = this.loadBackgroundimage;
      reader.readAsDataURL(file);
      this.back = file;
      if (file.size > 8406550) {
        this.backState(true,true,'画像サイズが大きすぎます');
      }else if (file.type != 'image/jpeg') {
        this.backState(true,true,'送信可能な画像の拡張子は「.jpg」のみです');
      }else {
        this.backState(false,false,'送信可能な画像サイズです');
      }
    },
    loadIconimage(e) {
      this.image1 = {src:e.target.result};
      this.iconFromStorage = false;
    },
    loadBackgroundimage(e) {
      this.image2 = {src:e.target.result};
      this.backFromStorage = false;
    },
    network(saving,success,error,saveStatus,saved){
      this.saving = saving;
      this.success = success;
      this.error = error;
      this.saveStatus = saveStatus;
      this.saved = saved;
    },
    iconState(error,cancel,status){
      this.error = error;
      this.iconCancel = cancel;
      this.iconStatus = status;
    },
    backState(error,cancel,status){
      this.error = error;
      this.backCancel = cancel;
      this.backStatus = status;
    }
  }
};
</script>

<style scoped>
.edit_images_zone{
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
  margin-top: 10px;
}

.icon_field{
  height: 230px;
  position: relative;
}

.back_field{
  height: 230px;
  position: relative;
}

.icon_left{
  position: absolute;
  top:0;
  left:0;
  width: 35%;
  height: 100%;
}

.icon_right{
  position: absolute;
  top:0;
  right: 0;
  width:65%;
  height: 100%;
}

.icon_right img{
  width: 150px;
  height: 150px;
  object-fit:contain;
  margin-top: 67px;
  background-color: gray;
}

.back_right img{
  width: 266px;
  height: 150px;
}

.icon_info p{
  font-size: 1.2rem;
  margin-left: 10px;
}

.image_status_ok{
  color: green;
}

.image_status_no{
  color: red;
}

.image-input {
  width: 250px;
  height: 150px;
  border: 5px dashed gray;
  border-radius: 4px;
}

.image-input__field {
  width: 100%;
  height: 100%;
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
}

.image-input__field.over {
  background-color: #666;
}

.image-input__field > input {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  opacity: 0;
  cursor: pointer;
}

.image-input__field > p {
  color: #aaa;
  text-align: center;
  font-size: 1.2rem;
  font-weight: bold;
}

@media (max-width:1230px) {
.icon_info p{
  width: 200px;
}
}
</style>
