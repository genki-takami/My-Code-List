<template>
  <div id="post_rikou_match">
    <h1 style="margin:0;text-align: center;">理工大会の記録追加</h1>
    <label>年度</label><br>
    <input type="text" v-model="year" placeholder="20XX年">
    <div id="writing_area">
      <label>名前</label><br>
      <input type="text" v-model="name" placeholder="成蹊太郎"><br>
      <label>階級</label><br>
      <input type="text" v-model="weightclass" placeholder="100kg級"><br>
      <label>ラウンド</label><br>
      <input type="text" v-model="number" placeholder="1回戦"><br>
      <label>結果</label><br>
      <input type="text" v-model="result" placeholder="「勝」or「負」 (漢字一文字)"><br>
      <label>対戦相手</label><br>
      <input type="text" v-model="who" placeholder="魔法科大学(司波)">
    </div>
    <div id="register">
      <button class="register_button" @click="register">登録</button>
      <p>＜現在の登録者名＞</p>
      <div v-html="html" style="padding-left:20px;"></div>
    </div>
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
      weightclass:'',
      name:'',
      number:'',
      result:'',
      who:'',
      submit:false,
      load:false,
      err:false,
      idNumber:0,
      weightclasses:[],
      names:[],
      numbers:[],
      results:[],
      whos:[],
      html:'',
      updatedStamp:'',
      idList:[],
      matchList:{},
      idArray:{},
      objectId:''
    };
  },
  computed: {
    idToken() {
      return this.$store.getters.idToken;
    }
  },
  methods: {
    register(){
      this.weightclasses.push({stringValue:this.weightclass});
      this.names.push({stringValue:this.name});
      this.numbers.push({stringValue:this.number});
      this.results.push({stringValue:this.result});
      this.whos.push({stringValue:this.who});
      this.html = this.html + this.name + '<br>';
      this.weightclass ='';
      this.name ='';
      this.number = '';
      this.result = '';
      this.who = '';
    },
    update() {
      this.load = true;

      axios.get('/rikou-match')
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
              this.idNumber = parseFloat(idCount) + 1.1;
              this.matchList[this.objectId] = {
                mapValue:{
                  fields: {
                    year:{
                      stringValue:this.year
                    },
                    weightclasses:{
                      arrayValue:{
                        values:this.weightclasses
                      }
                    },
                    names:{
                      arrayValue:{
                        values:this.names
                      }
                    },
                    numbers:{
                      arrayValue:{
                        values:this.numbers
                      }
                    },
                    results:{
                      arrayValue:{
                        values:this.results
                      }
                    },
                    whos:{
                      arrayValue:{
                        values:this.whos
                      }
                    },
                    idNumber:{
                      doubleValue:this.idNumber
                    }
                  }
                }
              };
              // 更新する
              axios.patch('/rikou-match/data',{fields: this.matchList},{headers: {Authorization: `Bearer ${this.idToken}`}}
              ).then(response => {
                if (response) {
                  // データの更新成功
                  axios.patch('/rikou-match/idList?updateMask.fieldPaths=list',{fields: this.idArray},{headers: {Authorization: `Bearer ${this.idToken}`}}
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
                          this.weightclass ='';
                          this.name ='';
                          this.number ='';
                          this.result ='';
                          this.who ='';
                          this.idNumber = 0;
                          this.html = '';
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
#writing_area{
  width: 50%;
  float: left;
}

#register{
  width: 45%;
  border-left: 1px dashed black;
  float: right;
  font-size: 1.5rem;
  font-weight: bold;
  margin-bottom: 195px;
}

#register p{
  margin-bottom: 0;
}

.register_button{
  background-color:blue;
  color:white;
  padding: 5px 20px;
}

label,button{
  font-size: 1.5rem;
  font-weight: bold;
}

input{
  margin-bottom: 10px;
  width: 100%;
}

button{
  background-color: orange;
  color:black;
  padding: 5px 10px;
  cursor:pointer;
}
</style>
