<template>
  <div id="post_news">
    <h1 style="margin:0;text-align: center;">ニュースの追加</h1>
    <label>日付</label><br>
    <input type="text" v-model="date" placeholder="2020.04.01 WED"><br>
    <label>カテゴリー</label><br>
    <input type="text" v-model="category" placeholder="４文字以内(文字数が足りない場合は全角スペースでうめる)"><br>
    <label>内容</label><br>
    <textarea v-model="text" placeholder="簡潔な内容"></textarea><br>
    <label>リンク先のURL</label><br>
    <input type="text" v-model="url" placeholder="https://〇〇〇.〇〇〇/"><br>
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
      date:'',
      category:'',
      text:'',
      url:'',
      submit:false,
      load:false,
      err:false,
      idNumber:0,
      updatedStamp:'',
      idList:[],
      newsList:{},
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

      axios.get('/news')
            .then(response => {
              // 情報ゲット
              let data = response.data;
              this.idList = data.documents[1].fields.list.arrayValue.values;
              let idCount = this.idList.length;
              for (var i = 0; i < idCount; i++) {
                let str = this.idList[i].stringValue;
                this.newsList[str] = data.documents[0].fields[str];
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
              this.newsList[this.objectId] = {
                mapValue:{
                  fields:{
                    date:{
                      stringValue:this.date
                    },
                    category:{
                      stringValue:this.category
                    },
                    text:{
                      stringValue:this.text
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
              axios.patch('/news/data',{fields: this.newsList},{headers: {Authorization: `Bearer ${this.idToken}`}}
              ).then(response => {
                if (response) {
                  // ニュースの更新成功
                  axios.patch('/news/idList?updateMask.fieldPaths=list',{fields: this.idArray},{headers: {Authorization: `Bearer ${this.idToken}`}}
                  ).then(response => {
                    if (response) {
                      // ニュースIDの更新成功
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
                          this.category = '';
                          this.text = '';
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
                      // ニュースIDの更新失敗
                      this.load = false;
                      this.err = true;
                    }
                  });
                }
              }).catch(error => {
                if (error) {
                  // ニュースの更新失敗
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
