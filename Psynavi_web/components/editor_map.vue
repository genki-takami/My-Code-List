<template>
  <div class="edit_map_zone">
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
    <div class="main_field">
      <div class="map_config">
        <h3>マップの中心を設定する</h3>
        <label>緯度：</label>
        <input v-model="latitude" type="number" placeholder="(例) 35.681042">
        <label>経度：</label>
        <input v-model="longitude" type="number" placeholder="(例) 139.767214">
        <button @click="updateCenter()" type="button"> <i class="fas fa-sync-alt" style="color:white"></i> </button>
        <span @click="show('Maps')" class="modal_guaide_btn"><i class="far fa-file-alt"></i> 使用ガイド<i class="fas fa-chevron-circle-right"></i></span><br>
        <div style="margin:10px 0;">
          <label>詳細なマップ案内ファイルの共有リンク：</label>
          <input v-model="mapFileLink" type="text" placeholder="(例) https://drive.google.com/file/d/〇〇/view?usp=sharing" style="width:400px;">
          <a :href="mapFileLink" target="_blank" style="margin-left:5px;font-size:1.4rem;background-color:dodgerblue;color:white;padding:4px 5px;font-weight:bold;">
            確認する
          </a>
        </div>
        <hr style="margin-right:175px;border-color:deepskyblue;">
      </div>
      <GmapMap
        :center="center"
        :zoom="16"
        :options="{streetViewControl: false,fullscreenControl:false,disableDoubleClickZoom:true}"
        map-type-id="roadmap"
        @click="mapClick"
        style="width:760px;height:456px;margin:10px auto;"
      >
        <GmapMarker
          :key="index"
          v-for="(m, index) in markers"
          :position="{ lat: m.latitude, lng: m.longitude}"
          :title="m.title"
          :icon="m.icon"
          :clickable="true"
          :draggable="false"
          @click="toggleInfoWindow(m)"
        />

        <GmapInfoWindow
          :options="infoOptions"
          :position="infoWindowPos"
          :opened="infoWinOpen"
          @closeclick="infoWinOpen=false"
        >
          {{ markerTitle }}<br>{{ markerSubtitle }}
        </GmapInfoWindow>
      </GmapMap>
      <div class="map_edit_exp">
        <p>
          (a)マップの中心を設定 ： 緯度と経度を小数点以下３桁以上記述し、更新ボタンを押す<br>
          (b)ピンを設置 ： マップ上の任地の地点でダブルクリック<br>
          (c)タイトルとサブタイトルを設定 ： ピンの一覧から選択して編集し、更新ボタンを押す<br>
          (d)ピンの削除 ： ピンの一覧から選択して削除ボタンを押す<br>
        </p>
      </div>
      <h3>マップのマーカー(ピン)の一覧と編集</h3>
      <div class="map_list_and_edit">
        <div class="map_list">
          <ul style="padding-left:0;margin:0;">
            <div v-for="(m, index) in markers" :key="m.id" class="map_list_item" @click="selectOne(m,index)">
              <img :src="m.icon.url">
              <li>{{ m.title }}</li>
            </div>
          </ul>
        </div>
        <div class="map_edit">
          <label>タイトル</label><br>
          <input v-model="pinTitle" type="text"><br>
          <label>サブタイトル</label><br>
          <input v-model="pinSubtitle" type="text"><br>
          <label>アイコン</label><br>
          <img @click="tapIcon('food')" :class="{icon_selected:jadge.food}" src="https://cdn3.iconfinder.com/data/icons/flat-instagram-stories-2/512/ForkKnife-128.png" alt="food">
          <img @click="tapIcon('display')" :class="{icon_selected:jadge.display}" src="https://cdn3.iconfinder.com/data/icons/finance-152/64/44-128.png" alt="display">
          <img @click="tapIcon('attraction')" :class="{icon_selected:jadge.attraction}" src="https://cdn1.iconfinder.com/data/icons/icons-for-a-site-1/64/advantage_quality-128.png" alt="attraction">
          <img @click="tapIcon('event')" :class="{icon_selected:jadge.events}" src="https://cdn2.iconfinder.com/data/icons/circle-icons-1/64/microphone-128.png" alt="event">
          <img @click="tapIcon('bench')" :class="{icon_selected:jadge.bench}" src="https://cdn0.iconfinder.com/data/icons/citycons/150/Citycons_park-128.png" alt="bench"><br>
          <img @click="tapIcon('toilet')" :class="{icon_selected:jadge.toilet}" src="https://cdn4.iconfinder.com/data/icons/hygiene-22/64/toilet-paper-health-quarantine-sars-covid19-coronavirus-128.png" alt="toilet">
          <img @click="tapIcon('smoke')" :class="{icon_selected:jadge.smoke}" src="https://cdn1.iconfinder.com/data/icons/addiction-drugs-2/24/addiction_Cigarette_1-128.png" alt="smoke">
          <img @click="tapIcon('trash')" :class="{icon_selected:jadge.trash}" src="https://cdn4.iconfinder.com/data/icons/evil-icons-user-interface/64/basket-128.png" alt="trash">
          <img @click="tapIcon('info')" :class="{icon_selected:jadge.info}" src="https://cdn3.iconfinder.com/data/icons/miscellaneous-80/60/info-128.png" alt="info">
          <div>
            <button @click="editMarker" type="button" class="marker_edit"> <i class="fas fa-sync-alt fa-2x" style="color:green"></i> </button>
            <button @click="deleteMarker" type="button" class="marker_delete"> <i class="fas fa-trash-alt fa-2x" style="color:black"></i> </button>
            <span v-if="showResult" class="result_message" :class="{trashed:isTrashed}">{{ resultMessage }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Vuex from '../store';
import { firestore } from '../firebase';
import { uuid } from "vue-uuid";
export default {
  data(){
    return {
      uid:'',
      latitude:0,
      longitude:0,
      mapFileLink:'',
      center:{lat:0,lng:0},
      infoOptions:{pixelOffset:{width:0,height: -35}},
      infoWindowPos:null,
      infoWinOpen:false,
      markerTitle:'タイトル',
      markerSubtitle:'サブタイトル',
      pinTitle:'',
      pinSubtitle:'',
      saving:false,
      success:false,
      error:false,
      errorMessage:'',
      saveStatus:'保存',
      saved:false,
      selectedIndex:9999,
      showResult:false,
      isTrashed:false,
      resultMessage:'',
      editingMarker:{},
      jadge:{food:false,display:false,attraction:false,events:false,bench:false,toilet:false,smoke:false,trash:false,info:false},
      markers:[]
    };
  },
  created(){
    this.uid = Vuex.getters.idToken;
    var db = firestore;
    var docRef = db.collection("draft-festival").doc(this.uid);
    docRef.get().then((doc) => {
      if (doc.exists) {
        var data = doc.data();
        data.latitude ? this.latitude = data.latitude : this.latitude = 35.681042;
        data.longitude ? this.longitude = data.longitude : this.longitude = 139.767214;
        this.center.lat = this.latitude;
        this.center.lng = this.longitude;
        data.mapFileLink ? this.mapFileLink = data.mapFileLink : this.mapFileLink = '';
      }else {
        this.center.lat = this.latitude = 35.681042;
        this.center.lng = this.longitude = 139.767214;
      }
      var markerRef = db.collection("MAP").doc(this.uid);
      markerRef.get().then((doc) => {
        if (doc.exists) {
          var data = doc.data();
          let list = data.list;
          for (var i = 0; i < list.length; i++) {
            let objectId = list[i];
            data[objectId]["id"] = objectId;
            data[objectId]["icon"] = this.changeToURL(data[objectId].pinImage);
            this.markers.push(data[objectId]);
          }
        }
      }).catch(() => {
        this.network(false,false,true,'読み込み失敗：画面をリロードしてください','保存',false);
      });
    }).catch(() => {
      this.network(false,false,true,'読み込み失敗：画面をリロードしてください','保存',false);
    });
  },
  methods:{
    show(comp){
      this.$modal.show(comp);
    },
    changeToURL(pinImage){
      var unitObject = {scaledSize: {width: 30, height:30}};
      switch (pinImage) {
        case 'food':
          unitObject.url = 'https://cdn3.iconfinder.com/data/icons/flat-instagram-stories-2/512/ForkKnife-128.png';
          break;
        case 'display':
          unitObject.url = 'https://cdn3.iconfinder.com/data/icons/finance-152/64/44-128.png';
          break;
        case 'attraction':
          unitObject.url = 'https://cdn1.iconfinder.com/data/icons/icons-for-a-site-1/64/advantage_quality-128.png';
          break;
        case 'event':
          unitObject.url = 'https://cdn2.iconfinder.com/data/icons/circle-icons-1/64/microphone-128.png';
          break;
        case 'bench':
          unitObject.url = 'https://cdn0.iconfinder.com/data/icons/citycons/150/Citycons_park-128.png';
          break;
        case 'smoke':
          unitObject.url = 'https://cdn1.iconfinder.com/data/icons/addiction-drugs-2/24/addiction_Cigarette_1-128.png';
          break;
        case 'trash':
          unitObject.url = 'https://cdn4.iconfinder.com/data/icons/evil-icons-user-interface/64/basket-128.png';
          break;
        case 'toilet':
          unitObject.url = 'https://cdn4.iconfinder.com/data/icons/hygiene-22/64/toilet-paper-health-quarantine-sars-covid19-coronavirus-128.png';
          break;
        default:
          unitObject.url = 'https://cdn3.iconfinder.com/data/icons/miscellaneous-80/60/info-128.png';
      }
      return unitObject;
    },
    save(){
      if (!this.saved) {
        this.error = false;
        this.saving = true;

        if (this.markers.length != 0) {
          var db = firestore;
          var mainRef = db.collection("draft-festival").doc(this.uid);
          var mapRef = db.collection("MAP").doc(this.uid);
          var batch = db.batch();
          let renewObject = this.makeObject();
          let coordination = {
            latitude:this.center.lat,
            longitude:this.center.lng,
            database:{
              marker:this.markers.length
            },
            mapFileLink:this.mapFileLink
          };
          batch.set(mainRef,coordination,{merge: true});
          batch.set(mapRef,renewObject);
          batch.commit().then(() => {
            this.network(false,true,false,'','完了(再保存はリロード)',true);
          }).catch(() => {
            this.network(false,false,true,'送信失敗：再度送信してください','保存',false);
          });
        } else this.network(false,false,true,'エラー：ひとつ以上マーカーを挿入してください','保存',false);
      }
    },
    makeObject(){
      var finalObject = {};
      var listArray = [];
      for (var i = 0; i < this.markers.length; i++) {
        listArray.push(this.markers[i].id);
        var copyObject = Object.assign({},this.markers[i]);
        finalObject[this.markers[i].id] = copyObject;
        delete finalObject[this.markers[i].id].id;
        delete finalObject[this.markers[i].id].icon;
      }
      finalObject.list = listArray;
      return finalObject;
    },
    toggleInfoWindow(marker) {
      this.infoWindowPos = { lat: marker.latitude, lng: marker.longitude};
      this.infoWinOpen = true;
      this.markerTitle = marker.title;
      this.markerSubtitle = marker.subtitle;
    },
    mapClick(event){
      if (event) {
        var lat = event.latLng.lat();
        var lng = event.latLng.lng();
        this.markers.unshift({
          id: uuid.v4(),
          latitude: lat,
          longitude: lng,
          pinImage:'',
          subtitle:'サブタイトルなし',
          title:'タイトルなし',
          icon:{url:'https://cdn3.iconfinder.com/data/icons/miscellaneous-80/60/info-128.png',scaledSize: {width: 30, height:30}}
        });
      }
    },
    selectOne(argument,index){
      var arg = Object.assign({},argument);
      this.showResult = false;
      this.isTrashed = false;
      this.pinTitle = arg.title;
      this.pinSubtitle = arg.subtitle;
      this.editingMarker.id = arg.id;
      this.editingMarker.latitude = arg.latitude;
      this.editingMarker.longitude = arg.longitude;
      this.editingMarker.pinImage = arg.pinImage;
      this.editingMarker.subtitle = arg.subtitle;
      this.editingMarker.title = arg.title;
      this.tapIcon(arg.pinImage);
      this.selectedIndex = index;
    },
    editMarker(){
      if (this.selectedIndex != 9999) {
        this.editingMarker.subtitle = this.pinSubtitle;
        this.editingMarker.title = this.pinTitle;
        this.markers[this.selectedIndex] = Object.assign({},this.editingMarker);
        this.showResult = true;
        this.resultMessage = '更新しました';
      }
    },
    deleteMarker(){
      if (this.selectedIndex != 9999) {
        this.markers.splice(this.selectedIndex, 1);
        this.showResult = true;
        this.isTrashed = true;
        this.resultMessage = '削除しました';
        this.pinTitle = '';
        this.pinSubtitle = '';
        this.editingMarker = {};
        this.selectedIndex = 9999;
        this.jadge = {food:false,display:false,attraction:false,events:false,bench:false,toilet:false,smoke:false,trash:false,info:false};
      }
    },
    tapIcon(arg){
      switch (arg) {
        case 'food':
          this.jadge.food = true;
          this.jadge.display = this.jadge.attraction = this.jadge.events = this.jadge.bench = this.jadge.smoke = this.jadge.trash = this.jadge.toilet = this.jadge.info = false;
          this.editingMarker.pinImage = 'food';
          this.editingMarker.icon = this.changeToURL('food');
          break;
        case 'display':
          this.jadge.display = true;
          this.jadge.food = this.jadge.attraction = this.jadge.events = this.jadge.bench = this.jadge.smoke = this.jadge.trash = this.jadge.toilet = this.jadge.info = false;
          this.editingMarker.pinImage = 'display';
          this.editingMarker.icon = this.changeToURL('display');
          break;
        case 'attraction':
          this.jadge.attraction = true;
          this.jadge.display = this.jadge.food = this.jadge.events = this.jadge.bench = this.jadge.smoke = this.jadge.trash = this.jadge.toilet = this.jadge.info = false;
          this.editingMarker.pinImage = 'attraction';
          this.editingMarker.icon = this.changeToURL('attraction');
          break;
        case 'event':
          this.jadge.events = true;
          this.jadge.display = this.jadge.attraction = this.jadge.food = this.jadge.bench = this.jadge.smoke = this.jadge.trash = this.jadge.toilet = this.jadge.info = false;
          this.editingMarker.pinImage = 'event';
          this.editingMarker.icon = this.changeToURL('event');
          break;
        case 'bench':
          this.jadge.bench = true;
          this.jadge.display = this.jadge.attraction = this.jadge.events = this.jadge.food = this.jadge.smoke = this.jadge.trash = this.jadge.toilet = this.jadge.info = false;
          this.editingMarker.pinImage = 'bench';
          this.editingMarker.icon = this.changeToURL('bench');
          break;
        case 'smoke':
          this.jadge.smoke = true;
          this.jadge.display = this.jadge.attraction = this.jadge.events = this.jadge.bench = this.jadge.food = this.jadge.trash = this.jadge.toilet = this.jadge.info = false;
          this.editingMarker.pinImage = 'smoke';
          this.editingMarker.icon = this.changeToURL('smoke');
          break;
        case 'trash':
          this.jadge.trash = true;
          this.jadge.display = this.jadge.attraction = this.jadge.events = this.jadge.bench = this.jadge.smoke = this.jadge.food = this.jadge.toilet = this.jadge.info = false;
          this.editingMarker.pinImage = 'trash';
          this.editingMarker.icon = this.changeToURL('trash');
          break;
        case 'toilet':
          this.jadge.toilet = true;
          this.jadge.display = this.jadge.attraction = this.jadge.events = this.jadge.bench = this.jadge.smoke = this.jadge.trash = this.jadge.food = this.jadge.info = false;
          this.editingMarker.pinImage = 'toilet';
          this.editingMarker.icon = this.changeToURL('toilet');
          break;
        default:
          this.jadge.info = true;
          this.jadge.display = this.jadge.attraction = this.jadge.events = this.jadge.bench = this.jadge.smoke = this.jadge.trash = this.jadge.toilet = this.jadge.food = false;
          this.editingMarker.pinImage = 'info';
          this.editingMarker.icon = this.changeToURL('info');
      }
    },
    updateCenter(){
      this.center.lat = this.latitude = parseFloat(this.latitude);
      this.center.lng = this.longitude = parseFloat(this.longitude);
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
.edit_map_zone{
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

.map_config label{
  font-size:1.4rem;
  margin-left: 10px;
}

.map_config button{
  font-size: 1.5rem;
  margin-left: 10px;
  letter-spacing: 3px;
  background-color: blueviolet;
  border: none;
  border-radius: 3px;
  cursor:pointer;
}

.map_edit_exp{
  background-color:#808080cc;
  width:760px;
  margin:0 auto;
  color:white;
  padding:1px 15px;
  font-size:1.4rem;
  font-weight: bold;
}

.map_list_and_edit{
  height:300px;
  padding: 0 20px;
  position: relative;
}

.map_list{
  position: absolute;
  top:0;
  left:0;
  width: 40%;
  height: 100%;
  overflow-y: auto;
  padding:5px 10px;
}

.map_list_item{
  height:40px;
  position: relative;
  border-bottom:1px dashed gray;
  cursor:pointer;
}

.map_list_item:hover{
  background-color:lightgray;
}

.map_list_item img{
  position: absolute;
  top:0;
  left:0;
  width:30px;
  height:30px;
  object-fit:contain;
  margin:5px 10px;
}

.map_list_item li{
  position: absolute;
  top:0;
  left:50px;
  display: inline-block;
  font-size: 1.3rem;
  line-height: 40px;
  word-break: keep-all;
}

.map_edit{
  position: absolute;
  top:0;
  right:0;
  width:60%;
  height: 100%;
  padding:5px 10px;
  border:1px solid black;
  border-radius:15px;
}

.map_edit input, .map_edit label{
  margin:5px 0;
  font-size:1.4rem;
}

.map_edit img{
  width:50px;
  height:50px;
  object-fit: contain;
  margin:5px 10px;
  border-radius: 5px;
  cursor: pointer;
}

.icon_selected{
  background-color:lightskyblue;
}

.marker_delete, .marker_edit{
  width: 60px;
  height: 35px;
  margin:0 10px;
  cursor:pointer;
}

.result_message{
  font-size: 1.6rem;
  color:green;
}

.trashed{
  color:red;
}
</style>
