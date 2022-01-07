<template>
  <div id="post_schedules">
    <h1 style="margin:0;text-align: center;">スケジュールの追加</h1>
    <label>日付</label><br>
    <input type="text" v-model="date" placeholder="〇月〇日"><br>
    <label>曜日</label><br>
    <input type="text" v-model="dayofweek" placeholder="〇曜日"><br>
    <label>現在状況</label><br>
    <input type="text" v-model="state" placeholder="「予定」or「済」or「延期」or「未確定」or「中止」"><br>
    <label>タイトル</label><br>
    <input type="text" v-model="title" placeholder="行事・大会名"><br>
    <label>リンク</label><br>
    <input type="text" v-model="url" placeholder="詳細へいくためのURL"><br>
    <button @click="update">UPDATE</button>
    <span v-if="submit" style="color:green;font-size: 2.4rem;font-weight: bold;margin-left:13px;">送信成功！</span>
    <span v-if="load" style="color:blue;font-size: 2.4rem;font-weight: bold;margin-left:13px;">送信中...</span>
    <span v-if="err" style="color:red;font-size: 2.4rem;font-weight: bold;margin-left:13px;">送信エラー</span>
    <br>
    <button @click="showEdit" class="edit_btn">スケジュールの編集はこちら</button>
    <br><span v-if="loadErr" style="color:red;font-size: 2.4rem;font-weight: bold;margin-left:13px;">エラーが発生しました。画面をリロードしてください。</span>
    <div v-if="startEdit">
      <h2 style="margin:0;text-align: center;color:red;">※完了ボタンは下にあります！</h2>
      <div v-for = "n in dataList.length" :key = "n">
        <label>タイトル</label><br>
        <input type="text" v-model="dataList[n-1].mapValue.fields.title.stringValue">
        <label>日付</label><br>
        <input type="text" v-model="dataList[n-1].mapValue.fields.date.stringValue">
        <label>曜日</label><br>
        <input type="text" v-model="dataList[n-1].mapValue.fields.dayofweek.stringValue">
        <label>現在状況</label><br>
        <input type="text" v-model="dataList[n-1].mapValue.fields.state.stringValue">
        <label>リンク</label><br>
        <input type="text" v-model="dataList[n-1].mapValue.fields.url.stringValue">
        <button v-if="deleteBtn" @click="deleteOne(n)" style="background-color:blue;color:white;">これを削除する</button>
        <hr color="blue" size="5">
      </div>
      <button @click="editData">編集を完了する</button>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  data() {
    return {
      date:'',
      dayofweek:'',
      state:'',
      title:'',
      url:'',
      idNumber:0,
      submit:false,
      load:false,
      err:false,
      loadErr:false,
      updatedStamp:'',
      idList:[],
      idList2:[],
      scheduleList:{},
      idArray:{},
      objectId:'',
      startEdit:false,
      dataList:[],
      deleteBtn:true
    };
  },
  computed: {
    idToken() {
      return this.$store.getters.idToken;
    }
  },
  watch:{
    dataList(val){
      if (val.length == 1) {
        // 削除できないようにする
        this.deleteBtn = false;
      }
    }
  },
  created(){
    axios.get('/schedules')
    .then(response => {
      // 情報ゲット
      let data = response.data;
      this.idList2 = data.documents[1].fields.list.arrayValue.values;
      for (var i = 0; i < this.idList2.length; i++) {
        let str = this.idList2[i].stringValue;
        this.dataList.push(data.documents[0].fields[str]);
      }
    }).catch(error => {
      if (error) {
        this.loadErr = true;
      }
    });
  },
  methods: {
    deleteOne(arg){
      let index = arg - 1;
      this.dataList.splice(index,1);
    },
    showEdit(){
      if (this.startEdit) {
        this.startEdit = false;
      }else {
        this.startEdit = true;
      }
    },
    update() {
      this.load = true;

      axios.get('/schedules')
            .then(response => {
              // 情報ゲット
              let data = response.data;
              this.idList = data.documents[1].fields.list.arrayValue.values;
              let idCount = this.idList.length;
              for (var i = 0; i < idCount; i++) {
                let str = this.idList[i].stringValue;
                this.scheduleList[str] = data.documents[0].fields[str];
              }
              // idの生成と格納
              this.objectId = new Date().getTime().toString(16) + Math.floor(Math.random() * 1000).toString();
              this.idList.push({stringValue:this.objectId});
              this.idArray["list"] = {
                arrayValue:{
                  values:this.idList
                }
              };
              // データの生成と格納
              this.idNumber = parseFloat(idCount) + 1.1;
              this.scheduleList[this.objectId] = {
                mapValue:{
                  fields: {
                    date:{
                      stringValue:this.date
                    },
                    dayofweek:{
                      stringValue:this.dayofweek
                    },
                    state:{
                      stringValue:this.state
                    },
                    title:{
                      stringValue:this.title
                    },
                    url:{
                      stringValue:this.url
                    },
                    idNumber:{
                      doubleValue:this.idNumber
                    }
                  }
                }
              };
              // 更新する
              axios.patch('/schedules/data',{fields: this.scheduleList},{headers: {Authorization: `Bearer ${this.idToken}`}}
              ).then(response => {
                if (response) {
                  // データの更新成功
                  axios.patch('/schedules/idList?updateMask.fieldPaths=list',{fields: this.idArray},{headers: {Authorization: `Bearer ${this.idToken}`}}
                  ).then(response => {
                    if (response) {
                      // データIDの更新成功
                      const date = new Date();
                      this.updatedStamp = date.getFullYear() + "/" + (date.getMonth() + 1) + "/" + date.getDate();
                      axios.patch(
                        '/updated-date/updatedStamp?updateMask.fieldPaths=updatedStamp',
                        {
                          fields:{
                            updatedStamp:{
                              stringValue:this.updatedStamp
                            }
                          }
                        },{headers: {Authorization: `Bearer ${this.idToken}`}}
                      ).then(response => {
                        if (response) {
                          // 更新日の送信成功
                          this.load = false;
                          this.err = false;
                          this.date = '';
                          this.dayofweek = '';
                          this.state = '';
                          this.title = '';
                          this.url = '';
                          this.idNumber = 0;
                          this.submit = true;
                          this.updatedStamp = '';
                        }
                      }).catch(error => {
                        if (error) {
                          // 更新日の更新失敗
                          this.load = false;
                          this.err = true;
                        }
                      });
                    }
                  }).catch(error => {
                    if (error) {
                      // データIDの更新失敗
                      this.load = false;
                      this.err = true;
                    }
                  });
                }
              }).catch(error => {
                if (error) {
                  // データの更新失敗
                  this.load = false;
                  this.err = true;
                }
              });
            }).catch(error => {
              // 情報取得失敗
              if (error) {
              this.load = false;
              this.err = true;
              }
            });
    },
    editData(){
      this.startEdit = false;
      this.load = true;

      // 更新処理をする
      for (var i = 0; i < this.idList2.length; i++) {
        let str = this.idList2[i].stringValue;
        this.scheduleList[str] = this.dataList[i];
      }
      axios.patch('/schedules/data',{fields: this.scheduleList},{headers: {Authorization: `Bearer ${this.idToken}`}}
      ).then(response => {
        if (response) {
          // データ送信成功
          const date = new Date();
          this.updatedStamp = date.getFullYear() + "/" + (date.getMonth() + 1) + "/" + date.getDate();
          axios.patch(
            '/updated-date/updatedStamp?updateMask.fieldPaths=updatedStamp',
            {
              fields:{
                updatedStamp:{
                  stringValue:this.updatedStamp
                }
              }
            },{headers: {Authorization: `Bearer ${this.idToken}`}}
          ).then(response => {
            if (response) {
              // 更新日の更新成功
              this.load = false;
              this.err = false;
              this.submit = true;
              this.scheduleList = {};
              this.updatedStamp = '';
            }else {
              // 更新日の更新失敗
              this.load = false;
              this.err = true;
            }
          }).catch(error => {
            if (error) {
              // 更新日の更新失敗
              this.load = false;
              this.err = true;
            }
          });
        }else {
          // データの送信失敗
          this.load = false;
          this.err = true;
        }
      }).catch(error => {
        if (error) {
          // データの送信失敗
          this.load = false;
          this.err = true;
        }
      });
    }
  }
};
</script>

<style scoped>
label,button{
  font-size: 1.5rem;
  font-weight: bold;
}

input{
  margin-bottom: 10px;
}

textarea,input{
  width: 100%;
}

textarea{
  height: 100px;
}

button{
  background-color: orange;
  color:black;
  padding: 5px 10px;
  cursor:pointer;
}

.edit_btn{
  margin-top: 10px;
  background-color: #EEEEEE;
  color: blue;
  font-size: 1.3rem;
  font-weight: normal;
  border: none;
  padding-left: 0;
}
</style>
