<template>
  <div id="post_introduce_sentences">
    <h1 style="margin:0;text-align: center;">紹介文の編集</h1>
    <label>紹介１</label><span v-if="loadErr" style="color:red;font-size: 2.4rem;font-weight: bold;margin-left:13px;">エラーが発生しました。画面をリロードしてください。</span><br>
    <textarea v-model="intro1"></textarea><br>
    <label>紹介２</label><br>
    <textarea v-model="intro2"></textarea><br>
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
      intro1:'',
      intro2:'',
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
    axios.get(process.env.VUE_APP_INTRODUCE_PATH)
          .then(response => {
            // データの受信成功
            this.intro1 = response.data.fields.intro1.stringValue;
            this.intro2 = response.data.fields.intro2.stringValue;
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
        process.env.VUE_APP_INTRODUCE_PATCH_PATH,
        {
          fields: {
            intro1:{
              stringValue:this.intro1
            },
            intro2:{
              stringValue:this.intro2
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
              this.intro1 = '';
              this.intro2 = '';
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
