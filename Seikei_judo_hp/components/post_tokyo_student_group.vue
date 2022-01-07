<template>
  <div id="post_tokyo_student_group">
    <h1 style="margin:0;text-align: center;">東京学生柔道優勝大会の記録追加</h1>
    <label>年度</label><br>
    <input type="text" v-model="year" placeholder="20XX年"><br>
    <label>ラウンド</label><br>
    <input type="text" v-model="title" placeholder="1回戦"><br>
    <label>対戦校名</label><br>
    <input type="text" v-model="university" placeholder="〇〇大学"><br>
    <label>自分たちの勝ち数</label><br>
    <input type="text" v-model="myscore" placeholder="数字"><br>
    <label>相手の勝ち数</label><br>
    <input type="text" v-model="theirscore" placeholder="数字"><br>
    <label>どちらが勝ったか</label><br>
    <input type="text" v-model="result" placeholder="〇〇大学"><br>
    <button @click="register" class="registerBtn">＋</button><br>
    <label>保存されたデータ：</label><p>{{ registerdList }}</p><br>
    <button @click="update">UPDATE</button>
    <span v-if="submit" style="color:green;font-size: 2.4rem;font-weight: bold;margin-left:13px;">送信成功！</span>
    <span v-if="load" style="color:blue;font-size: 2.4rem;font-weight: bold;margin-left:13px;">送信中...</span>
    <span v-if="err" style="color:red;font-size: 2.4rem;font-weight: bold;margin-left:13px;">送信エラー</span>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  data() {
    return {
      year:'',
      title:'',
      university:'',
      myscore:'',
      theirscore:'',
      result:'',
      yArray:[],
      tArray:[],
      uArray:[],
      mArray:[],
      thArray:[],
      rArray:[],
      idNumber:0,
      submit:false,
      load:false,
      err:false,
      updatedStamp:'',
      idList:[],
      matchList:{},
      idArray:{},
      objectId:'',
      registerdList:''
    };
  },
  computed: {
    idToken() {
      return this.$store.getters.idToken;
    }
  },
  methods: {
    register(){
      this.yArray.push({stringValue:this.year});
      this.tArray.push({stringValue:this.title});
      this.uArray.push({stringValue:this.university});
      this.mArray.push({stringValue:this.myscore});
      this.thArray.push({stringValue:this.theirscore});
      this.rArray.push({stringValue:this.result});
      this.registerdList = this.registerdList +  '・' + this.title;
      this.title = '';
      this.university ='';
      this.myscore ='';
      this.theirscore = '';
      this.result ='';
    },
    update() {
      this.load = true;

      axios.get('/tokyo-student-group')
            .then(response => {
              // 情報ゲット
              let data = response.data;
              this.idList = data.documents[1].fields.list.arrayValue.values;
              let idCount = this.idList.length;
              for (var i = 0; i < idCount; i++) {
                let str = this.idList[i].stringValue;
                this.matchList[str] = data.documents[0].fields[str];
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
              var innerData = [];
              for (var elm = 0; elm < this.yArray.length; elm++) {
                let object = {
                  mapValue:{
                    fields:{
                      year:this.yArray[elm],
                      title:this.tArray[elm],
                      university:this.uArray[elm],
                      myscore:this.mArray[elm],
                      theirscore:this.thArray[elm],
                      result:this.rArray[elm]
                    }
                  }
                };
                innerData.push(object);
              }
              this.idNumber = parseFloat(idCount) + 1.1;
              this.matchList[this.objectId] = {
                mapValue:{
                  fields: {
                    main:{
                      arrayValue:{
                        values:innerData
                      }
                    },
                    idNumber:{
                      doubleValue:this.idNumber
                    }
                  }
                }
              };
              // 更新する
              axios.patch('/tokyo-student-group/data',{fields: this.matchList},{headers: {Authorization: `Bearer ${this.idToken}`}}
              ).then(response => {
                if (response) {
                  // データの更新成功
                  axios.patch('/tokyo-student-group/idList?updateMask.fieldPaths=list',{fields: this.idArray},{headers: {Authorization: `Bearer ${this.idToken}`}}
                  ).then(response => {
                    if (response) {
                      // 試合IDの更新成功
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
                          this.year = '';
                          this.title = '';
                          this.university ='';
                          this.myscore ='';
                          this.theirscore = '';
                          this.result ='';
                          this.registerdList = '';
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
                      // 試合IDの更新失敗
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
              if (error) {
                // 情報取得失敗
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

.registerBtn{
  border:none;
  border-radius: 16px;
  font-weight: bold;
  background-color:cornflowerblue;
  color: white;
}
</style>
