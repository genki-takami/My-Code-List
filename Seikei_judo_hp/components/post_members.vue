<template>
  <div id="post_members">
    <h1 style="margin:0;text-align: center;">部員の編集</h1>
    <div id="writing_area">
      <label>名前</label><br>
      <input type="text" v-model="name" placeholder="成蹊太郎"><br>
      <label>学年</label><br>
      <input type="text" v-model="grade" placeholder="4年"><br>
      <label>役職</label><br>
      <input type="text" v-model="job" placeholder="主将"><br>
      <label>柔道の階級</label><br>
      <input type="text" v-model="weightclass" placeholder="100kg級"><br>
      <label>学部</label><br>
      <input type="text" v-model="faculty" placeholder="法学部"><br>
      <label>身長</label><br>
      <input type="text" v-model="tall" placeholder="172cm"><br>
      <label>出身高校</label><br>
      <input type="text" v-model="highschool" placeholder="成蹊高校"><br>
      <label>段位</label><br>
      <input type="text" v-model="status" placeholder="弍段"><br>
      <label>顔画像のURL</label><br>
      <input type="text" v-model="imageURL" placeholder="https://〇〇〇.〇〇〇/"><br>
      <label>コメント</label><br>
      <textarea rows="3" v-model="comment" placeholder="複数行可"></textarea>
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
      name:'',
      grade:'',
      job:'',
      weightclass:'',
      faculty:'',
      tall:'',
      highschool:'',
      status:'',
      imageURL:'',
      comment:'',
      submit:false,
      load:false,
      err:false,
      names:[],
      grades:[],
      jobs:[],
      weightclasses:[],
      faculties:[],
      talls:[],
      highschools:[],
      statuses:[],
      imageURLs:[],
      comments:[],
      html:'',
      updatedStamp:''
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
      this.grades.push({stringValue:this.grade});
      this.jobs.push({stringValue:this.job});
      this.faculties.push({stringValue:this.faculty});
      this.talls.push({stringValue:this.tall});
      this.highschools.push({stringValue:this.highschool});
      this.statuses.push({stringValue:this.status});
      this.imageURLs.push({stringValue:this.imageURL});
      this.comments.push({stringValue:this.comment});
      this.html = this.html + this.name + '<br>';
      this.weightclass ='';
      this.name ='';
      this.grade = '';
      this.job = '';
      this.faculty = '';
      this.tall = '';
      this.highschool = '';
      this.status = '';
      this.imageURL = '';
      this.comment = '';
    },
    update() {
      this.load = true;

      axios.patch(
        process.env.VUE_APP_MEMBERS_PATH,
        {
          fields: {
            names:{
              arrayValue:{
                values:this.names
              }
            },
            grades:{
              arrayValue:{
                values:this.grades
              }
            },
            jobs:{
              arrayValue:{
                values:this.jobs
              }
            },
            weightclasses:{
              arrayValue:{
                values:this.weightclasses
              }
            },
            faculties:{
              arrayValue:{
                values:this.faculties
              }
            },
            talls:{
              arrayValue:{
                values:this.talls
              }
            },
            highschools:{
              arrayValue:{
                values:this.highschools
              }
            },
            statuses:{
              arrayValue:{
                values:this.statuses
              }
            },
            imageURLs:{
              arrayValue:{
                values:this.imageURLs
              }
            },
            comments:{
              arrayValue:{
                values:this.comments
              }
            }
          }
        },{headers: {Authorization: `Bearer ${this.idToken}`}}
      ).then(response => {
        if (response) {
          // 更新成功
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
              this.name = '';
              this.grade = '';
              this.job = '';
              this.weightclass ='';
              this.faculty = '';
              this.tall = '';
              this.highschool ='';
              this.status ='';
              this.imageURL = '';
              this.comment = '';
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
          // 更新失敗
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
  margin-bottom: 508px;
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

input, textarea{
  margin-bottom: 10px;
  width: 100%;
}

button{
  background-color: orange;
  color:black;
  padding: 5px 10px;
  cursor:pointer;
}

@media (max-width:1000px){
#register{
  margin-top: 21px;
}
}
</style>
