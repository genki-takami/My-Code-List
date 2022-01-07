<template>
  <div id="post_four_fresh">
    <h1 style="margin:0;text-align: center;">四大新人戦の記録追加</h1>
    <label>年度</label><br>
    <input type="text" v-model="year" placeholder="20XX年"><br>
    <label>１位</label><br>
    <input type="text" v-model="is1st" placeholder="〇〇大学"><br>
    <label>２位</label><br>
    <input type="text" v-model="is2nd" placeholder="〇〇大学"><br>
    <label>３位</label><br>
    <input type="text" v-model="is3rd" placeholder="〇〇大学"><br>
    <label>４位</label><br>
    <input type="text" v-model="worst" placeholder="〇〇大学"><br>
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
      is1st:'',
      is2nd:'',
      is3rd:'',
      worst:'',
      submit:false,
      load:false,
      err:false,
      idNumber:0,
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
    update() {
      this.load = true;

      axios.get('/four-fresh')
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
                    is1st:{
                      stringValue:this.is1st
                    },
                    is2nd:{
                      stringValue:this.is2nd
                    },
                    is3rd:{
                      stringValue:this.is3rd
                    },
                    worst:{
                      stringValue:this.worst
                    },
                    idNumber:{
                      doubleValue:this.idNumber
                    }
                  }
                }
              };
              // 更新する
              axios.patch('/four-fresh/data',{fields: this.matchList},{headers: {Authorization: `Bearer ${this.idToken}`}}
              ).then(response => {
                if (response) {
                  // データの更新成功
                  axios.patch('/four-fresh/idList?updateMask.fieldPaths=list',{fields: this.idArray},{headers: {Authorization: `Bearer ${this.idToken}`}}
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
                          this.is1st = '';
                          this.is2nd = '';
                          this.is3rd = '';
                          this.worst = '';
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
</style>
