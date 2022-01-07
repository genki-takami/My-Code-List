<template>
  <div id="post_coach_trainer">
    <h1 style="margin:0;text-align: center;">監督などの編集</h1>
    <label>監督の名前</label><span v-if="loadErr" style="color:red;font-size: 2.4rem;font-weight: bold;margin-left:13px;">エラーが発生しました。画面をリロードしてください。</span><br>
    <input type="text" v-model="name1"><br>
    <label>監督の顔画像URL</label><br>
    <input type="text" v-model="url1"><br>
    <label>監督のプロフィール</label><br>
    <textarea v-model="status1"></textarea><br>
    <label>監督からのコメント</label><br>
    <textarea v-model="comment1"></textarea><br>
    <label>トレーナーの名前</label><br>
    <input type="text" v-model="name2"><br>
    <label>トレーナーの顔画像URL</label><br>
    <input type="text" v-model="url2"><br>
    <label>トレーナーのプロフィール</label><br>
    <textarea v-model="status2"></textarea><br>
    <label>トレーナーからのコメント</label><br>
    <textarea v-model="comment2"></textarea><br>
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
      name1:'',
      status1:'',
      comment1:'',
      name2:'',
      status2:'',
      comment2:'',
      url1:'',
      url2:'',
      loadErr:false,
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
  created() {
    axios.get(process.env.VUE_APP_COACH_AND_TRAINER_PATH)
          .then(response => {
            // データの受信成功
            this.name1 = response.data.fields.name1.stringValue;
            this.status1 = response.data.fields.status1.stringValue;
            this.comment1 = response.data.fields.comment1.stringValue;
            this.name2 = response.data.fields.name2.stringValue;
            this.status2 = response.data.fields.status2.stringValue;
            this.comment2 = response.data.fields.comment2.stringValue;
            this.url1 = response.data.fields.url1.stringValue;
            this.url2 = response.data.fields.url2.stringValue;
          }).catch(error => {
            if (error) {
              // データの受信失敗
              this.loadErr = true;
            }
          });
  },
  methods: {
    update() {
      this.load = true;

      axios.patch(
        process.env.VUE_APP_COACH_AND_TRAINER_PATCH_PATH,
        {
          fields: {
            name1:{
              stringValue:this.name1
            },
            status1:{
              stringValue:this.status1
            },
            comment1:{
              stringValue:this.comment1
            },
            url1:{
              stringValue:this.url1
            },
            name2:{
              stringValue:this.name2
            },
            status2:{
              stringValue:this.status2
            },
            comment2:{
              stringValue:this.comment2
            },
            url2:{
              stringValue:this.url2
            }
          }
        },{headers: {Authorization: `Bearer ${this.idToken}`}}
      ).then(response => {
        if (response) {
          // 送信成功
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
              this.name1 = '';
              this.status1 = '';
              this.comment1 = '';
              this.name2 = '';
              this.status2 = '';
              this.comment2 = '';
              this.url1 = '';
              this.url2 = '';
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
          // 送信失敗
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
