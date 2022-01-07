<template>
  <div id="post_calendar_images">
    <h1 style="margin:0;text-align: center;">カレンダーの編集</h1>
    <label>１月のリンク先のURL</label><span v-if="loadErr" style="color:red;font-size: 2.4rem;font-weight: bold;margin-left:13px;">エラーが発生しました。画面をリロードしてください。</span><br>
    <input type="text" v-model="url1"><br>
    <label>２月のリンク先のURL</label><br>
    <input type="text" v-model="url2"><br>
    <label>３月のリンク先のURL</label><br>
    <input type="text" v-model="url3"><br>
    <label>４月のリンク先のURL</label><br>
    <input type="text" v-model="url4"><br>
    <label>５月のリンク先のURL</label><br>
    <input type="text" v-model="url5"><br>
    <label>６月のリンク先のURL</label><br>
    <input type="text" v-model="url6"><br>
    <label>７月のリンク先のURL</label><br>
    <input type="text" v-model="url7"><br>
    <label>８月のリンク先のURL</label><br>
    <input type="text" v-model="url8"><br>
    <label>９月のリンク先のURL</label><br>
    <input type="text" v-model="url9"><br>
    <label>１０月のリンク先のURL</label><br>
    <input type="text" v-model="url10"><br>
    <label>１１月のリンク先のURL</label><br>
    <input type="text" v-model="url11"><br>
    <label>１２月のリンク先のURL</label><br>
    <input type="text" v-model="url12"><br>
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
      url1:'',
      url2:'',
      url3:'',
      url4:'',
      url5:'',
      url6:'',
      url7:'',
      url8:'',
      url9:'',
      url10:'',
      url11:'',
      url12:'',
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
    axios.get(process.env.VUE_APP_CALENDAR_IMAGES_PATH)
          .then(response => {
            this.url1 = response.data.fields.url1.stringValue;
            this.url2 = response.data.fields.url2.stringValue;
            this.url3 = response.data.fields.url3.stringValue;
            this.url4 = response.data.fields.url4.stringValue;
            this.url5 = response.data.fields.url5.stringValue;
            this.url6 = response.data.fields.url6.stringValue;
            this.url7 = response.data.fields.url7.stringValue;
            this.url8 = response.data.fields.url8.stringValue;
            this.url9 = response.data.fields.url9.stringValue;
            this.url10 = response.data.fields.url10.stringValue;
            this.url11 = response.data.fields.url11.stringValue;
            this.url12 = response.data.fields.url12.stringValue;
          }).catch(error => {
            if (error) {
              // データの受信に失敗
              this.loadErr = true;
            }
          });
  },
  methods: {
    update() {
      this.load = true;

      axios.patch(
        process.env.VUE_APP_CALENDAR_IMAGES_PATCH_PATH,
        {
          fields: {
            url1:{
              stringValue:this.url1
            },
            url2:{
              stringValue:this.url2
            },
            url3:{
              stringValue:this.url3
            },
            url4:{
              stringValue:this.url4
            },
            url5:{
              stringValue:this.url5
            },
            url6:{
              stringValue:this.url6
            },
            url7:{
              stringValue:this.url7
            },
            url8:{
              stringValue:this.url8
            },
            url9:{
              stringValue:this.url9
            },
            url10:{
              stringValue:this.url10
            },
            url11:{
              stringValue:this.url11
            },
            url12:{
              stringValue:this.url12
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
              this.url1 = '';
              this.url2 = '';
              this.url3 = '';
              this.url4 = '';
              this.url5 = '';
              this.url6 = '';
              this.url7 = '';
              this.url8 = '';
              this.url9 = '';
              this.url10 = '';
              this.url11 = '';
              this.url12 = '';
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
