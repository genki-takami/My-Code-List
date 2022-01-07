<template>
  <div class="edit_dashboard_zone">
    <k-tabs class="box">
      <k-tab name="プレビューとダッシュボード" :selected="true">
        <div class="tab_section preview_dashboard">
          <div class="preview_zone">
            <h1>Preview</h1>
            <button @click="refresh" type="button" class="reload_btn"><i class="fas fa-undo"></i></button>
            <div class="device_preview">
              <img class="background_image" :src="pBackground.src">
              <img class="icon_image" :src="pIcon.src">
              <div class="back_btn"><i class="fas fa-reply"></i></div>
              <div class="vote_btn"><i class="fas fa-comment-medical"></i>投票</div>
              <p class="content_title">{{ pTitle }}</p>
              <div class="date_area">
                <div class="date_icon"><img class="icon_img" src="https://cdn4.iconfinder.com/data/icons/small-n-flat/24/calendar-128.png"></div>
                <div class="date_text"><p>{{ pDate }}</p></div>
              </div>
              <div class="place_area">
                <div class="place_text"><p>{{ pMap }}</p></div>
                <div class="place_icon"><img class="icon_img" src="https://cdn0.iconfinder.com/data/icons/simpline-mix/64/simpline_8-128.png"></div>
              </div>
              <div class="slogan_area">
                <div class="slogan_icon"><img class="icon_img" src="https://cdn4.iconfinder.com/data/icons/multimedia-75/512/multimedia-27-128.png"></div>
                <div class="slogan_text"><p>{{ pSlogan }}</p></div>
              </div>
              <p class="manager_text">{{ pOwner }}</p>
              <div class="btn_area1">
                <div class="sde_btn" style="background-color:#fb6363;">ショップ</div>
                <div class="sde_btn center_btn" style="background-color:rgb(95 165 255);">展示</div>
                <div class="sde_btn" style="background-color:#f7f75a;">イベント</div>
              </div>
              <div class="btn_area1">
                <div class="mn_btn" style="background-color:#13b113;"><i class="fas fa-map"></i> 地図</div>
                <div class="mn_btn" style="background-color:#e26a6a;"><i class="fas fa-bell"></i> お知らせ</div>
              </div>
              <div class="info_area">{{ pInfo }}</div>
              <div class="url_area">URL①</div>
              <div class="url_area" style="color:blue;">{{ pLink1 }}</div>
              <div class="url_area">URL②</div>
              <div class="url_area" style="color:blue;">{{ pLink2 }}</div>
              <div class="comment_area">
                <div class="comment_title">コメントを書く</div><div class="comment_list">コメント一覧</div>
                <div class="comment_name">匿名</div>
                <div class="comment_edit_area">
                  誰かを不快にするようなコメントは避けよう！
                  <div class="comment_submit"><i class="fas fa-paper-plane"></i></div>
                </div>
              </div>
            </div>
            <p style="text-align:center;"><i>4.7インチのiPhone</i></p>
          </div>
          <div class="dashboard_zone">
            <h1>Dashboard</h1>
            <div class="data_block" style="color:white;background-image:url('https://cdn.pixabay.com/photo/2013/07/13/12/47/cosmic-160340__340.png');background-size:cover;">
              <p class="section_title">メインデータ</p>
              <p class="section_content">{{ dMain }}</p>
            </div>
            <div class="data_block" style="color:white;background-image:url('https://cdn.pixabay.com/photo/2013/07/13/12/47/cosmic-160340__340.png');background-size:cover;">
              <p class="section_title">アイコンと背景の画像</p>
              <p class="section_content">{{ dImage }}</p>
            </div>
            <div class="data_block" style="color:white;background-image:url('https://cdn.pixabay.com/photo/2013/07/13/12/47/cosmic-160340__340.png');background-size:cover;">
              <p class="section_title">オリジナルマップ</p>
              <p class="section_content">{{ dMap1 }}<br>{{ dMap2 }}</p>
            </div>
            <div class="data_block" style="color:white;background-image:url('https://cdn.pixabay.com/photo/2013/07/13/12/47/cosmic-160340__340.png');background-size:cover;">
              <p class="section_title">ショップ/展示</p>
              <p class="section_content">{{ dContent1 }}<br>{{ dContent2 }}</p>
            </div>
            <div class="data_block" style="background-image:url('https://cdn.pixabay.com/photo/2016/12/21/18/34/clouds-1923545__340.png');background-size:cover;">
              <p class="section_title">お知らせ</p>
              <p class="section_content">{{ dNotice }}</p>
            </div>
            <div class="data_block" style="background-image:url('https://cdn.pixabay.com/photo/2016/12/21/18/34/clouds-1923545__340.png');background-size:cover;">
              <p class="section_title">イベント作成</p>
              <p class="section_content">{{ dEvent1 }}<br>{{ dEvent2 }}</p>
            </div>
            <div class="data_block" style="color:white;background-image:url('https://cdn.pixabay.com/photo/2020/02/05/15/47/natural-4821583__340.png');background-size:cover;">
              <p class="section_title">リンクの設置</p>
              <p class="section_content">{{ dLink }}</p>
            </div>
            <div class="data_block" style="color:white;background-image:url('https://cdn.pixabay.com/photo/2020/02/05/15/47/natural-4821583__340.png');background-size:cover;">
              <p class="section_title">投稿されたコメント</p>
              <p class="section_content">{{ dComment }}</p>
            </div>
          </div>
        </div>
      </k-tab>
      <k-tab name="投票機能">
        <div class="tab_section vote_function">
          <div v-if="accountUpgraded">
            <div style="margin-bottom:20px;">
              <button @click="addVote" type="button" style="font-size:1.8rem;font-weight:bold;cursor:pointer;"><i class="fas fa-plus-circle fa-1x"></i> 投票インベントの作成</button>
              <span @click="changeView" style="font-size:1.8rem;color:darkgreen;font-weight:bold;margin-left:8rem;cursor:pointer;"> {{ changeResult }}</span>
              <span @click="show('DashBoard')" class="modal_guaide_btn"><i class="far fa-file-alt"></i> 使用ガイド<i class="fas fa-chevron-circle-right"></i></span>
            </div>
            <div v-show="isEditor" style="height:620px;position:relative;border:1px solid gray;border-radius:5px;">
              <div style="position:absolute;top:0;left:0;height:100%;width:40%;overflow-y:auto;border-right:1px solid gray;">
                <ol style="padding-left:30px;font-size:1.5rem;">
                  <div v-for="(v,index) in votes" :key="index" @click="selectedOne(v,index)">
                    <li class="vote_lists">{{ v.name }}</li>
                  </div>
                </ol>
              </div>
              <div style="position:absolute;top:0;right:0;height:100%;width:60%;overflow-y:auto;">
                <div v-show="itemSelected">
                  <div style="margin:10px 10px;text-align:right;">
                    <div v-show="saving" style="display:inline-block;">
                      <i class="fas fa-sync-alt fa-2x fa-spin" style="color:blue"></i>
                    </div>
                    <button @click="finishVote()" type="button" style="font-size:1.8rem;font-weight:bold;padding:1px 10px;cursor:pointer;margin-left:15px;">{{ finishLabel }}</button>
                    <button @click="removeVoteItem(focusIndex)" type="button" style="font-size:2.26rem;font-weight:bold;padding:1px 10px;cursor:pointer;margin-left:15px;">
                      <i class="fas fa-trash-alt"></i>
                    </button>
                    <button @click="completeTask()" type="button" style="font-size:1.8rem;font-weight:bold;padding:1px 10px;cursor:pointer;margin-left:15px;">完了</button>
                  </div>
                  <div class="edit_voting">
                    <label>イベント名</label><br>
                    <input v-model="currentObject.name" type="text" style="width:60%;" :disabled="disabled"><br>
                    <label>説明/概要</label><br>
                    <textarea v-model="currentObject.info" rows="5" style="width:60%;"></textarea><br>
                    <input v-model="currentObject.choise" type="checkbox"><label> 複数選択にする</label><br><br>
                    <label @click="addChoise" style="cursor:pointer;">選択肢 <i class="fas fa-plus-circle fa-1x"></i></label><br>
                    <div v-for="(s,index2) in currentObject.lists" :key="index2">
                      <input v-model="s.title" type="text" style="width:60%;"><span @click="removeListItem(index2)" style="color:red;margin-left:5px;cursor:pointer;"><i class="fas fa-minus-circle"></i></span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div v-show="isConsole" style="height:620px;position:relative;border:1px solid gray;border-radius:5px;">
              <div style="position:absolute;top:0;left:0;height:100%;width:40%;overflow-y:auto;border-right:1px solid gray;">
                <ol style="padding-left:30px;font-size:1.5rem;">
                  <div v-for="(v,index) in voteObjects" :key="index" @click="touchOne(v)">
                    <li class="vote_lists">{{ v.dataset.name }}</li>
                  </div>
                </ol>
              </div>
              <div style="position:absolute;top:0;right:0;height:50%;width:60%;overflow-y:auto;border-bottom:1px solid gray;">
                <h2 style="margin:10px;">結果/経過 <span style="font-size:1.5rem;color:cornflowerblue;">(リストから再タップで更新)</span></h2>
                <div v-html="activityResult" style="margin-left:10px;"></div>
              </div>
              <div style="position:absolute;bottom:0;right:0;height:50%;width:60%;overflow-y:auto;">
                <h2 style="margin:10px;">票のデータ</h2>
                <div v-for="(l,index) in activityLog" :key="index" style="margin-left:5px;font-size:1.5rem;">
                  <span>{{ l.text }}</span>
                </div>
              </div>
            </div>
          </div>
          <div v-else>
            <img src="https://cdn.pixabay.com/photo/2018/02/18/20/29/computer-3163437__480.png">
            <div class="not_upgraded_vote">
              <h1>投票機能は有料オプションです</h1>
              <h3>投票機能を使用するには</h3>
              <p>
                (１)Apple Inc. が提供する App Store にて、モバイル端末に「Psyなび」をインストールする必要があります。<br>
                (２)インストールした「Psyなび」を起動します。<br>
                (３)「 作成など > 文化祭の更新 > サインイン > 投票機能 」と進んでください。<br>
                (４)「 アカウントをアップグレードする 」を選択し、App内課金の手続きを行ってください。<br>
                (５)モバイル端末で操作を継続する場合は「 投票機能の追加 」タブを閉じてから、もう一度「 投票機能 」に進みます。<br>
                (６)Psyなび Studio で操作を継続する場合は、画面をリロードしてください。<br>
                ※有料オプションのアクティベートには時間がかかる場合があります
              </p>
            </div>
          </div>
        </div>
      </k-tab>
      <k-tab name="公開" :tags="tags">
        <div class="tab_section content_release">
          <form-wizard
              @on-complete="onComplete"
              title="公開フロー"
              subtitle="公開するにあたっての手順です"
              color="#07bf07"
              next-button-text="確認"
              back-button-text="戻る"
              finish-button-text="公開">
            <tab-content title="データの完全性">
              <h2 style="text-align:center;">
                公開するデータはすべて保存し終えていますか？<br>
                あらかじめダッシュボードでリフレッシュすることを推奨します。
              </h2>
            </tab-content>
            <tab-content title="公開権利">
              <h2 style="text-align:center;">
                公開するにあたって、データに紐ずく会社・学校・コミュニティに<br>
                確認と承認を得て、適切な権利と責任をもっていますか？<br>
                <span style="font-size:1.5rem;">詳細は利用規約をご覧ください</span>
              </h2>
            </tab-content>
            <tab-content title="最終確認">
              <h2 style="text-align:center;">
                公開ボタンをクリックすると、アプリ上に反映されます<br>
                準備はいいですか？
              </h2>
            </tab-content>
          </form-wizard>
          <div v-show="publishing" style="text-align:center;color:#07bf07;">
            <h1><i class="fas fa-sync fa-5x fa-spin"></i></h1>
          </div>
          <div v-show="published" style="text-align:center;color:#07bf07;">
            <h1>公開されました！！</h1>
          </div>
        </div>
      </k-tab>
    </k-tabs>
  </div>
</template>

<script>
import {FormWizard, TabContent} from 'vue-form-wizard';
import 'vue-form-wizard/dist/vue-form-wizard.min.css';
import Vuex from '../store';
import { firestore, updateField, storage, database } from '../firebase';
export default {
  components: {
    'form-wizard': FormWizard,
    'tab-content': TabContent
  },
  data(){
    return{
      uid:'',
      pIcon:{src:"https://cdn.pixabay.com/photo/2017/11/22/17/13/christmas-2970954__340.png"},
      pBackground:{src:'https://cdn.pixabay.com/photo/2017/01/31/13/36/landscape-2024099__340.png'},
      pTitle:'文化祭名',
      pDate:'12/24(土),12/25(日)',
      pMap:'〇〇大学東京キャンパス',
      pSlogan:'スローガンのテキスト',
      pOwner:'created by 〇〇',
      pInfo:'説明',
      pLink1:'(例：ウェブサイトのリンク)',
      pLink2:'(例：SNSのリンク)',
      mCount:0,
      iCount:0,
      m1Count:'デフォルト',
      m2Count:0,
      c1Count:0,
      c2Count:0,
      nCount:0,
      e1Count:0,
      e2Count:0,
      lCount:0,
      commentCount:0,
      publishing:false,
      published:false,
      draftObject:{},
      tags:[],
      accountUpgraded:false,
      changeResult:'投票の経過と結果をみる',
      isEditor:true,
      isConsole:false,
      itemSelected:false,
      votes:[],
      currentObject:{},
      isNew:false,
      focusIndex:9999,
      voteObjects:[],
      activityResult:'<h2 style="text-align:center;">投票イベントを作成するかリストを選択してください</h2>',
      activityLog:[],
      saving:false,
      disabled:false,
      finishLabel:''
    };
  },
  created(){
    this.uid = Vuex.getters.idToken;
    this.load();
  },
  computed:{
    dMain(){
      return `完成率：${this.mCount}/7`
    },
    dImage(){
      return `完成率：${this.iCount}/2`
    },
    dMap1(){
      return `座標：${this.m1Count}`
    },
    dMap2(){
      return `ピンの数：${this.m2Count}個`
    },
    dContent1(){
      return `ショップ数：${this.c1Count}店舗`
    },
    dContent2(){
      return `展示数：${this.c2Count}カ所`
    },
    dNotice(){
      return `発信したお知らせ数：${this.nCount}件`
    },
    dEvent1(){
      return `イベント数：${this.e1Count}件`
    },
    dEvent2(){
      return `画像の数：${this.e2Count}枚`
    },
    dLink(){
      return `完成率：${this.lCount}/2`
    },
    dComment(){
      return `コメント数：${this.commentCount}件`
    }
  },
  methods:{
    show(comp){
      this.$modal.show(comp);
    },
    addVote(){
      if (!this.itemSelected) this.itemSelected = true;
      this.isNew = true;
      this.disabled = false;
      this.focusIndex = 9999;
      this.finishLabel = '状態：新規イベント';
      this.currentObject = {
        name:'',
        info:'',
        choise:false,
        finish:false,
        lists:[]
      };
    },
    addChoise(){
      this.currentObject.lists.push({title:'選択肢の名前'});
    },
    removeListItem(index){
      this.currentObject.lists.splice(index,1);
    },
    changeView(){
      if (this.isEditor) {
        this.isEditor = false;
        this.isConsole = true;
        this.changeResult = '編集に戻る';
      }else {
        this.isEditor = true;
        this.isConsole = false;
        this.changeResult = '投票の経過と結果をみる';
      }
    },
    selectedOne(arg,index){
      if (!this.itemSelected) this.itemSelected = true;
      this.isNew = false;
      this.disabled = true;
      this.focusIndex = index;
      arg.finish ? this.finishLabel = '投票は終了しています' : this.finishLabel = '投票を終了する';
      this.currentObject = Object.assign({},arg);
    },
    touchOne(arg){
      this.activityResult = '';
      this.activityLog = [];
      if (arg.result) {
        Object.keys(arg.result).forEach( key => {
          if (key == 'all') {
            this.activityResult = `<h2 style="color:green;text-align:center;">${arg.result[key]}</h2>` + this.activityResult;
          }else {
            this.activityResult = this.activityResult + `<h3>${arg.result[key]}票 => ${key}</h3>`;
          }
        });
      }else {
        this.activityResult = '<h2 style="color:orange;text-align:center;">まだ投票されていません</h2>';
      }
      if (arg.votes) {
        Object.keys(arg.votes).forEach( key => {
          this.activityLog.push({text:`${arg.votes[key].timestamp}__${arg.votes[key].vote}`});
        });
      }
    },
    completeTask(){
      if (this.currentObject.name != '') {
        this.saving = true;
        for (var li = 0; li < this.currentObject.lists.length; li++) {
          if (this.currentObject.lists[li].title == 'all') {
            alert('選択肢に「all」は使用できません');
            this.saving = false;
            return ;
          }
        }
        let newVoteItem = Object.assign({},this.currentObject);
        // databaseに保存
        var updates = {};
        updates[`/festivals/${this.uid}/${newVoteItem.name}/dataset`] = newVoteItem;
        database.ref().update(updates).then(() => {
          this.saving = false;
          this.currentObject = {};
          this.itemSelected = false;
          this.focusIndex = 9999;
        }).catch(() => {
          alert('投票イベントの保存に失敗しました\n再度お試しください');
          this.saving = false;
        });
      }
    },
    removeVoteItem(index){
      if (!this.isNew) {
        this.saving = true;
        // databaseから削除
        database.ref(`festivals/${this.uid}/${this.votes[index].name}`).remove().then(() => {
          this.saving = false;
          this.currentObject = {};
          this.itemSelected = false;
          this.focusIndex = 9999;
        }).catch(() => {
          alert('投票イベントの削除に失敗しました\n再度お試しください');
          this.saving = false;
        });
      }
    },
    finishVote(){
      if (!this.isNew && this.finishLabel == '投票を終了する') {
        this.saving = true;
        // finishプロパティをtrueにする
        this.currentObject.finish = true;
        let updateVoteItem = Object.assign({},this.currentObject);
        // 更新する
        var updates = {};
        updates[`/festivals/${this.uid}/${updateVoteItem.name}/dataset`] = updateVoteItem;
        database.ref().update(updates).then(() => {
          this.saving = false;
          this.currentObject = {};
          this.itemSelected = false;
          this.focusIndex = 9999;
        }).catch(() => {
          alert('投票イベントの終了に失敗しました\n再度お試しください');
          this.saving = false;
        });
      }
    },
    onComplete(){
      this.published = false;
      this.publishing = true;

      if (Object.keys(this.draftObject).length != 0) {
        var db = firestore;
        var batch = db.batch();
        var publicRef = db.collection('campus-festival').doc(this.uid);
        let newObject = Object.assign({},this.draftObject);
        batch.set(publicRef,newObject,{ merge: true });
        var catalogRef = db.collection('catalog').doc('nameList');
        batch.update(catalogRef,{list: updateField.FieldValue.arrayUnion(newObject.festivalName)});
        var draftRef = db.collection('draft-festival').doc(this.uid);
        batch.set(draftRef,{database:{published:true}},{merge: true});
        batch.commit().then(() => {
          this.publishing = false;
          this.published = true;
        }).catch(() => {
          alert('公開に失敗しました\nもう一度「公開」をして下さい');
          this.publishing = false;
        });
      }else {
        alert('ダッシュボードでデータをリフレッシュしてください');
        this.publishing = false;
      }
    },
    reset(){
      this.pIcon = {src:"https://cdn.pixabay.com/photo/2017/11/22/17/13/christmas-2970954__340.png"};
      this.pBackground = {src:'https://cdn.pixabay.com/photo/2020/07/06/01/33/sky-5375005__340.jpg'};
      this.pTitle = '文化祭名';
      this.pDate = '12/24(土),12/25(日)';
      this.pMap = '〇〇大学東京キャンパス';
      this.pSlogan = 'スローガンのテキスト';
      this.pOwner = 'created by 〇〇';
      this.pInfo = '説明';
      this.pLink1 = '(例：ウェブサイトのリンク)';
      this.pLink2 = '(例：SNSのリンク)';
      this.mCount = 0;
      this.iCount = 0;
      this.m1Count = 'デフォルト';
      this.m2Count = 0;
      this.c1Count = 0;
      this.c2Count = 0;
      this.nCount = 0;
      this.e1Count = 0;
      this.e2Count = 0;
      this.lCount = 0;
      this.commentCount = 0;
      this.draftObject = {};
      this.tags = [];
      this.accountUpgraded = false;
      this.changeResult = '投票の経過と結果をみる';
      this.isEditor = true;
      this.isConsole = false;
      this.itemSelected = false;
      this.votes = [];
      this.currentObject = {};
      this.isNew = false;
      this.focusIndex = 9999;
      this.voteObjects = [];
      this.activityResult = '<h2 style="text-align:center;">投票イベントを作成するかリストを選択してください</h2>';
      this.activityLog = [];
      this.finishLabel = '';
    },
    refresh(){
      this.reset();
      this.load();
    },
    load(){
      var db = firestore;
      db.collection("draft-festival").doc(this.uid).get().then((doc) => {
        if (doc.exists) {
          var data = doc.data();
          this.draftObject = data;
          if (data.festivalName) {
            this.pTitle = data.festivalName;
            this.mCount += 1;
          }
          if (data.date) {
            this.pDate = data.date;
            this.mCount += 1;
          }
          if (data.school) {
            this.pMap = data.school;
            this.mCount += 1;
          }
          if (data.slogan) {
            this.pSlogan = data.slogan;
            this.mCount += 1;
          }
          if (data.owner) {
            this.pOwner = `created by ${data.owner}`;
          }
          if (data.info) {
            this.pInfo = data.info;
            this.mCount += 1;
          }
          if (data.link) {
            if (data.link.title1) {
              this.pLink1 = data.link.title1;
              this.mCount += 1;
              this.lCount += 1;
            }
            if (data.link.title2) {
              this.pLink2 = data.link.title2;
              this.mCount += 1;
              this.lCount += 1;
            }
          }
          if (data.latitude && data.longitude) {
            this.m1Count = '設定済み';
          }
          if (data.database) {
            if (data.database.published) {
              this.tags = [{ content:'公開中'}];
            }
            if (data.database.shop) {
              this.c1Count += data.database.shop;
            }
            if (data.database.display) {
              this.c2Count += data.database.display;
            }
            if (data.database.event) {
              this.e1Count += data.database.event;
            }
            if (data.database.marker) {
              this.m2Count += data.database.marker;
            }
            if (data.database.notice) {
              this.nCount += data.database.notice;
            }
            if (data.database.eventImage) {
              this.e2Count += data.database.eventImage.length;
            }
            if (data.database.icon) {
              storage.child(`${data.database.icon}`).getDownloadURL().then(url => {
                this.iCount += 1;
                this.pIcon = {src:url};
              }).catch(() => {
                alert('データの取得に失敗しました\n更新ボタンを押すか、画面をリロードしてください');
              });
            }
            if (data.database.background) {
              storage.child(`${data.database.background}`).getDownloadURL().then(url => {
                this.iCount += 1;
                this.pBackground = {src:url};
              }).catch(() => {
                alert('データの取得に失敗しました\n更新ボタンを押すか、画面をリロードしてください');
              });
            }
          }
          if (data.upgrade) {
            this.accountUpgraded = true;
            var voteRef = database.ref(`festivals/${this.uid}`);
            voteRef.on('value', (snapshot) => {
              var voteData = snapshot.val();
              this.votes = [];
              this.voteObjects = [];
              Object.keys(voteData).forEach( key => {
                this.votes.push(voteData[key].dataset);
                this.voteObjects.push(voteData[key]);
              });
            });
          }
        }
      }).catch(() => {
        alert('データの取得に失敗しました\n更新ボタンを押すか、画面をリロードしてください');
      });
      db.collection("COMMENT").doc(this.uid).get().then((doc) => {
        if (doc.exists) {
          var data2 = doc.data();
          this.commentCount += Object.keys(data2).length;
        }
      }).catch(() => {
        alert('データの取得に失敗しました\n更新ボタンを押すか、画面をリロードしてください');
      });
    }
  }
};
</script>

<style scoped>
.edit_dashboard_zone{
  width: 100%;
  height: 100%;
  min-height: 100vh;
  color:black;
}

.tab_section{
  height:1000px;
}

.preview_dashboard{
  width:100%;
  position:relative;
}

.preview_zone{
  position: absolute;
  top:0;
  left:0;
  width:40%;
  height:100%;
}

.dashboard_zone{
  position:absolute;
  top:0;
  right:0;
  width:60%;
  height:100%;
}

.device_preview{
  width:375px;
  height:667px;
  margin:0 auto;
  border:1px solid gray;
  border-radius:5px;
  overflow-y:auto;
  position:relative;
}

.background_image{
  background-color:gray;
  width:100%;
  height: auto;
}

.icon_image{
  background-color:gray;
  width:100px;
  height:100px;
  position: absolute;
  left:0;
  right:0;
  margin:156px auto 0;
  border-radius:50px;
}
.back_btn{
  display: inline-block;
  font-size:2rem;
  color:royalblue;
  margin-left:10px;
}

.vote_btn{
  display: inline-block;
  font-size:2rem;
  color:purple;
  margin-left:260px;
}

.reload_btn{
  margin:0 1px 8px 36px;
  padding:3px 6px;
  font-size:1.3rem;
  cursor: pointer;
}

.content_title{
  font-size:2.5rem;
  text-align: center;
  font-weight: bold;
  margin-bottom:15px;
}

.date_area{
  position:relative;
  height:50px;
}

.date_icon{
  position:absolute;
  top:0;
  left:0;
  width:20%;
  height:100%;
}

.icon_img{
  width:100%;
  height:100%;
  object-fit:contain;
}

.date_text{
  position: absolute;
  top:0;
  right:0;
  width:80%;
  height:100%;
  font-size:1.5rem;
  white-space: nowrap;
  overflow: hidden;
}
.place_area{
  position:relative;
  height:50px;
}

.place_icon{
  position:absolute;
  top:0;
  right:0;
  width:20%;
  height:100%;
}

.place_text{
  position: absolute;
  top:0;
  left:0;
  width:80%;
  height:100%;
  font-size:1.5rem;
  white-space: nowrap;
  overflow: hidden;
  text-align: right;
}

.slogan_area{
  position:relative;
  height:50px;
}

.slogan_icon{
  position:absolute;
  top:0;
  left:0;
  width:20%;
  height:100%;
}

.slogan_text{
  position: absolute;
  top:0;
  right:0;
  width:80%;
  height:100%;
  font-size:1.5rem;
}

.manager_text{
  text-align: center;
  color:gray;
  font-size:1.5rem;
  margin:5px 0 0 0;
}

.btn_area1{
  height:50px;
  padding:0 5px;
  margin-top: 3px;
}

.sde_btn{
  display: inline-block;
  width:32%;
  height:100%;
  text-align: center;
  line-height: 50px;
  font-size:1.8rem;
}

.center_btn{
  margin:0 3px;
}

.mn_btn{
  display:inline-block;
  width:49%;
  height:100%;
  text-align:center;
  line-height: 50px;
  font-size:1.8rem;
  margin-right: 3px;
}

.info_area{
  margin:3px 5px;
  background-color:#80808033;
  height:200px;
  font-size:1.8rem;
}

.url_area{
  font-size:1.5rem;
  text-align:center;
  font-weight: bold;
}

.comment_area{
  height:150px;
  background-color:#eadabc;
  margin:5px 5px;
  position: relative;
  margin-bottom:60px;
}

.comment_title{
  position:absolute;
  top:0;
  left:5px;
  display: inline-block;
  font-size:1.9rem;
}

.comment_list{
  position: absolute;
  top:10px;
  right:5px;
  display: inline-block;
  font-size: 1.5rem;
  color:blue;
}

.comment_name{
  padding:30px 0 3px 18px;
  font-size:1.3rem;
}

.comment_edit_area{
  height:90px;
  background-color: white;
  position:relative;
  margin:0 5px;
  font-size:1.4rem;
  padding:5px 0 0 5px;
}

.comment_submit{
  position: absolute;
  bottom:0;
  right:0;
  color:white;
  background-color: blue;
  padding:3px 7px;
}

.data_block{
  margin:0 30px 10px;
  border-radius:15px;
}

.section_title{
  font-size:3.5rem;
  font-weight: bold;
  margin:0 0 0 15px;
}

.section_content{
  font-size:3rem;
  font-weight: bold;
  text-align: right;
  margin:0 10px 0 0;
}

.vote_function{
  position:relative;
}

.vote_function img{
  position: absolute;
  top:0;
  left:0;
  width:100%;
  height:auto;
}

.not_upgraded_vote{
  width:95%;
  margin:20px 0 0 20px;
  padding:0 15px;
  background-color:#ffffffd1;
  position:absolute;
  top:0;
  left:0;
  font-size:1.4rem;
  font-weight: bold;
}

.edit_voting{
  padding:0 10px;
  font-size:1.5rem;
  font-weight: bold;
}

.edit_voting input, .edit_voting textarea{
  margin:5px 0;
}

.vote_lists{
  cursor: pointer;
}

.vote_lists:hover{
  background-color:#80808052;
}

@media (max-width:1249px) {
.device_preview{
  width:285px;
  height:514px;
}

.icon_image{
  width:77px;
  height:77px;
  margin-top:120px;
}

.mn_btn{
  width:48%;
}

.vote_btn{
  margin-left:180px;
}
}
</style>
