<template>
  <div id="post_topic">
    <h1 style="margin:0;text-align: center;">トップニュースの編集</h1>
    <label>日付</label><br>
    <input type="text" v-model="date" placeholder="2020.04.01 WED"><br>
    <label>タイトル</label><br>
    <input type="text" v-model="title" placeholder="短くて理解しやすいタイトル"><br>
    <label>内容</label><br>
    <textarea v-model="text" placeholder="詳細な情報"></textarea><br>
    <label>リンク先のURL</label><br>
    <input type="text" v-model="url" placeholder="https://〇〇〇.〇〇〇/"><br>
    <label>画像のURL</label><br>
    <input type="text" v-model="imageurl" placeholder="https://〇〇〇.〇〇〇/"><br>
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
      title:'',
      text:'',
      url:'',
      imageurl:'',
      submit:false,
      load:false,
      err:false,
      updatedStamp:''
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
      axios.patch(
        process.env.VUE_APP_TOPICS_PATCH_PATH,
        {
          fields: {
            date:{
              stringValue:this.date
            },
            title:{
              stringValue:this.title
            },
            text:{
              stringValue:this.text
            },
            url:{
              stringValue:this.url
            },
            imageurl:{
              stringValue:this.imageurl
            }
          }
        },{headers: {Authorization: `Bearer ${this.idToken}`}}
      ).then(response => {
        if (response) {
          // トップニュースの送信成功
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
              this.title = '';
              this.text = '';
              this.url = '';
              this.imageurl = '';
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
        // トップニュースの更新失敗
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
