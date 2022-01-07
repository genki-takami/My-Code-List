<template>
  <div class="edit_zone">
    <div class="edit_permission">
      <div class="edit_left">
        <div class="user_mini_prof">
          <div class="ump_left">
            <img src="https://cdn.pixabay.com/photo/2016/03/31/19/58/avatar-1295429_960_720.png" alt="ユーザー画像">
          </div>
          <div class="ump_right">
            <h4 style="margin:0;">{{ displayName }}</h4>
            <h5 style="margin:0;">{{ email }}</h5>
          </div>
        </div>
        <ul>
          <li class="editor_menu" @click="selectEditorMenu('DashBoard')" :class="{selected:isD}"><i class="fas fa-home" style="color: gray;"></i> ダッシュボード</li>
          <li class="editor_menu" @click="selectEditorMenu('Main')" :class="{selected:isMn}"><i class="fas fa-file-alt" style="margin-right:5px;color:gray;"></i> メインデータ</li>
          <li class="editor_menu" @click="selectEditorMenu('Images')" :class="{selected:isI}"><i class="fas fa-images" style="color:gray;"></i> アイコンと背景の画像</li>
          <li class="editor_menu" @click="selectEditorMenu('Maps')" :class="{selected:isMp}"><i class="fas fa-map-marked-alt" style="color:gray;"></i> マップの作成</li>
          <li class="editor_menu" @click="selectEditorMenu('Contents')" :class="{selected:isC}"><i class="fas fa-store" style="color:gray;"></i> ショップ/展示のリスト</li>
          <li class="editor_menu" @click="selectEditorMenu('Notices')" :class="{selected:isN}"><i class="fas fa-bell" style="margin-right:4px;color:gray;"></i> お知らせの作成</li>
          <li class="editor_menu" @click="selectEditorMenu('Events')" :class="{selected:isE}"><i class="fas fa-star" style="color:gray;"></i> イベントの作成</li>
          <li class="editor_menu" @click="selectEditorMenu('Links')" :class="{selected:isL}"><i class="fas fa-link" style="color:gray;"></i> リンクの設定</li>
          <hr>
          <li class="editor_menu" @click="selectEditorMenu('Setting')" :class="{selected:isS}"><i class="fas fa-user-cog" style="color:gray;"></i> 設定＆ログアウト</li>
        </ul>
        <img class="man_image" src="https://cdn.pixabay.com/photo/2020/07/31/16/00/workplace-5453406_1280.png">
      </div>
      <div class="edit_right">
        <keep-alive>
          <component :is="nowcomponent" class="editor_component"></component>
        </keep-alive>
      </div>
      <modal :name="nowcomponent" height="auto" scrollable="true">
        <div class="modal_header">
          <h2>{{ mHeader }}</h2>
        </div>
        <hr>
        <div class="modal_body">
          <div v-html="mText"></div>
          <button @click="hide(nowcomponent)" style="font-weight:bold;margin-bottom:2rem;">閉じる</button>
        </div>
      </modal>
    </div>
    <div class="edit_cancel">
      <h2>※画面が小さすぎます！<br>ノートパソコンかディスプレイ幅が1000px以上の端末で操作してください！</h2>
      <img src="https://cdn.pixabay.com/photo/2013/07/13/14/08/deckchair-162188_960_720.png" alt="画面が小さい">
    </div>
  </div>
</template>

<script>
import Vuex from '../store';
import Contents from './editor_contents.vue';
import DashBoard from './editor_dashboard.vue';
import Events from './editor_events.vue';
import Images from './editor_images.vue';
import Links from './editor_links.vue';
import Main from './editor_main.vue';
import Maps from './editor_map.vue';
import Notices from './editor_notices.vue';
import Setting from './editor_setting.vue';

export default {
  data(){
    return {
      email:'',
      displayName:'',
      nowcomponent:'DashBoard',
      isD:true,
      isMn:false,
      isI:false,
      isMp:false,
      isC:false,
      isN:false,
      isE:false,
      isL:false,
      isS:false
    };
  },
  created(){
    this.email = Vuex.getters.userEmail;
    this.displayName = Vuex.getters.userDisplayName;
    if (this.displayName == null) this.displayName = '未登録';
  },
  components:{
    Contents,
    DashBoard,
    Events,
    Images,
    Links,
    Main,
    Maps,
    Notices,
    Setting
  },
  computed:{
    mHeader(){
      return this.castModal(this.nowcomponent,true)
    },
    mText(){
      return this.castModal(this.nowcomponent,false)
    }
  },
  methods: {
    hide(h){
      this.$modal.hide(h);
    },
    logout() {
      this.$store.dispatch('logout');
    },
    castModal(comp,arg){
      switch (comp) {
        case 'DashBoard':
          return (arg ? '投票機能について' : process.env.VUE_APP_MODAL_DASHBOARD);
        case 'Main':
          return (arg ? 'メインデータの編集機能について' : process.env.VUE_APP_MODAL_MAIN);
        case 'Images':
          return (arg ? 'アイコン/背景画像の追加編集機能について' : process.env.VUE_APP_MODAL_IMAGES);
        case 'Maps':
          return (arg ? '案内マップの編集機能について' : process.env.VUE_APP_MODAL_MAP);
        case 'Contents':
          return (arg ? 'ショップ/展示の追加編集機能について' : process.env.VUE_APP_MODAL_CONTENT);
        case 'Notices':
          return (arg ? 'お知らせ配信の追加編集機能について' : process.env.VUE_APP_MODAL_NOTICE);
        case 'Events':
          return (arg ? '企画イベントの追加編集機能について' : process.env.VUE_APP_MODAL_EVENT);
        case 'Links':
          return (arg ? 'ウェブサイトURLの設置について' : process.env.VUE_APP_MODAL_LINK);
        default:
          return 'エラー';
      }
    },
    selectEditorMenu(arg){
      this.nowcomponent = arg;
      switch (arg) {
        case 'DashBoard':
          this.isD = true;
          this.isMn = this.isI = this.isMp = this.isC = this.isN = this.isE = this.isL = this.isS = false;
          break;
        case 'Main':
          this.isMn = true;
          this.isD = this.isI = this.isMp = this.isC = this.isN = this.isE = this.isL = this.isS = false;
          break;
        case 'Images':
          this.isI = true;
          this.isMn = this.isD = this.isMp = this.isC = this.isN = this.isE = this.isL = this.isS = false;
          break;
        case 'Maps':
          this.isMp = true;
          this.isMn = this.isI = this.isD = this.isC = this.isN = this.isE = this.isL = this.isS = false;
          break;
        case 'Contents':
          this.isC = true;
          this.isMn = this.isI = this.isMp = this.isD = this.isN = this.isE = this.isL = this.isS = false;
          break;
        case 'Notices':
          this.isN = true;
          this.isMn = this.isI = this.isMp = this.isC = this.isD = this.isE = this.isL = this.isS = false;
          break;
        case 'Events':
          this.isE = true;
          this.isMn = this.isI = this.isMp = this.isC = this.isN = this.isD = this.isL = this.isS = false;
          break;
        case 'Links':
          this.isL = true;
          this.isMn = this.isI = this.isMp = this.isC = this.isN = this.isE = this.isD = this.isS = false;
          break;
        default:
          this.isS = true;
          this.isMn = this.isI = this.isMp = this.isC = this.isN = this.isE = this.isL = this.isD = false;
      }
    }
  }
};
</script>

<style scoped>
.edit_zone{
  height: 100%;
  min-height: 100vh;
  color:black;
  padding:80px 0 68px;
}

.edit_permission{
  width: 100%;
  height: 100%;
  min-height:1300px;
  position: relative;
}

.edit_left{
  position: absolute;
  top:0;
  left:0;
  width: 20%;
  height: 103%;
  padding: 10px;
  background-color:#040433;
}

.edit_left ul{
  color: white;
  list-style: none;
  margin: 30px 0;
  padding: 0 10px;
}

.user_mini_prof{
  width: 100%;
  height: 60px;
  position: relative;
}

.ump_left{
  position: absolute;
  top:0;
  left:0;
  width: 30%;
  height: 100%;
}

.ump_left img{
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.ump_right{
  position: absolute;
  top:0;
  right:0;
  width: 70%;
  height: 100%;
  color: white;
  padding: 10px 0;
  word-break: break-word;
}

.editor_menu{
  font-size: 1.6rem;
  font-weight: bold;
  padding: 10px 0;
  cursor: pointer;
}

.selected{
  color: deepskyblue;
}

.edit_right{
  position: absolute;
  top:0;
  right: 0;
  width: 80%;
  height: 100%;
}

.editor_component{
  width: 100%;
  padding: 5px 20px;
}

.edit_cancel{
  display: none;
}

.man_image{
  width:100%;
  height: auto;
}

.modal_header{
  text-align: center;
}

.modal_body{
  padding:0 20px;
  font-size: 1.5rem;
}

@media (max-width:1170px) {
.editor_menu{
  font-size: 1.3rem;
}
}

@media (max-width:1000px) {
.edit_permission{
  display: none;
}

.edit_cancel{
  display: block;
  text-align: center;
  width: 65%;
  margin: 60px auto 0;
}

.edit_cancel img{
  width: 65%;
  object-fit: contain;
}
}
</style>
