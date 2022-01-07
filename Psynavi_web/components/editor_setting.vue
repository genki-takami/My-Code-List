<template>
  <div class="edit_setting_zone" style="padding:0;">
    <img src="https://cdn.pixabay.com/photo/2018/02/02/04/32/red-3124617__480.png" style="width:100%;height:auto;">
    <div class="setting_box">
      <div style="position:relative;">
        <h2 style="display:inline-block;"><i class="fas fa-sign-out-alt"></i> LOGOUT</h2>
        <button @click="logout" class="logout_btn">
          <i>Logout</i>
        </button>
      </div><hr>
      <h2><i class="fas fa-edit"></i> CHANGE PROFILE NAME</h2>
      <hr>
      <div class="setting_unit">
        <input v-model="newDisplayName" type="text" placeholder="新しいプロフィールネーム" class="input_editing">
        <button @click="changeDisplayName" style="margin-left:10px;cursor:pointer;">変更</button>
      </div>
      <h2><i class="fas fa-envelope"></i> CHANGE MAIL</h2>
      <hr>
      <div class="setting_unit">
        <input v-model="newEmail" type="text" placeholder="新しいメールアドレス" class="input_editing">
        <button @click="changeMail" style="margin-left:10px;cursor:pointer;">変更</button>
      </div>
      <h2><i class="fas fa-key"></i> CHANGE PASSWORD</h2>
      <hr>
      <div class="setting_unit">
        <input v-model="newPassword" type="text" placeholder="(６文字以上)" class="input_editing">
        <button @click="changePassword" style="margin-left:10px;cursor:pointer;">変更</button>
      </div>
      <div class="inner_unit">
        <div class="space_area">
          <div v-show="networking" style="color:fuchsia;text-align:center;">
            <h1><i class="fas fa-sync fa-5x fa-spin"></i></h1>
          </div>
        </div>
        <div class="inquiry_and_delete">
          <div style="position:relative;">
            <h2 style="display:inline-block;"><i class="far fa-question-circle"></i> INQUIRY</h2>
            <button @click="sendInquiry" class="logout_btn">
              <i>Submit</i>
            </button>
          </div><hr>
          <textarea v-model="inquiryText" rows="5" placeholder="お問い合わせ内容を記述(改善などのお問い合わせには、アップデートで対応します)" style="width:90%;"></textarea>
          <h2><i class="fas fa-trash-alt"></i> DELETE ALL DATA ＆ ACCOUNT</h2>
          <hr>
          <div style="position:relative;">
            <button @click="deleteAll" class="logout_btn">
              すべてのデータを削除
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { firestore, auth } from '../firebase';
import Vuex from '../store';
import { uuid } from "vue-uuid";
export default {
  data(){
    return{
      uid:'',
      newDisplayName:'',
      newEmail:'',
      newPassword:'',
      currentDisplayName:'',
      currentEmail:'',
      inquiryText:'',
      networking:false
    };
  },
  created(){
    this.uid = Vuex.getters.idToken;
    this.currentDisplayName = Vuex.getters.userDisplayName;
    this.currentEmail = Vuex.getters.userEmail;
  },
  methods: {
    logout() {
      this.$store.dispatch('logout');
    },
    changeDisplayName(){
      if (this.newDisplayName != '' && this.currentEmail != '' && this.currentDisplayName != '' && this.uid != '') {
        this.networking = true;
        var user = auth.currentUser;
        if (user){
          user.updateProfile({displayName: this.newDisplayName}).then(() => {
            this.currentDisplayName = this.newDisplayName;
            this.$store.dispatch('setAuthData',{
              idToken: this.uid,
              userEmail: this.currentEmail,
              userDisplayName: this.currentDisplayName
            });
            alert('プロフィールネームが変更されました\nメニューバーのプロフィールネームは画面をリロードすることで反映されます');
            this.newDisplayName = '';
            this.networking = false;
          }).catch(() => {
            alert('プロフィールネームの変更に失敗しました\nもう一度お試しください\n(何度も失敗する場合は、再度ログインし直してから試みてください)');
            this.networking = false;
          });
        }else {
          alert('ログインが確認されませんでした\n再度ログインし直してから試みてください');
          this.networking = false;
        }
      }
    },
    changeMail(){
      if (this.newEmail != '' && this.currentEmail != '' && this.currentDisplayName != '' && this.uid != '') {
        this.networking = true;

        var reg = /^[a-zA-Z0-9.!#$&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$/;
        if (reg.test(this.newEmail)) {
          var user = auth.currentUser;
          auth.languageCode = 'jp';
          if (user){
            user.updateEmail(this.newEmail).then(() => {
              this.currentEmail = this.newEmail;
              this.$store.dispatch('setAuthData',{
                idToken: this.uid,
                userEmail: this.currentEmail,
                userDisplayName: this.currentDisplayName
              });
              user = auth.currentUser;
              user.sendEmailVerification({url:'https://psynavi-86643.web.app/'}).then(() => {
                alert('メールアドレスが変更されました\n確認メールを送信します\nセキュリティ上、自動的にログアウトします');
                this.logout();
              }).catch(() => {
                alert('メールアドレスが変更されました\nしかし、確認メールの送信に失敗しました\nセキュリティ上、自動的にログアウトします');
                this.logout();
              });
              this.newEmail = '';
              this.networking = false;
            }).catch(() => {
              alert('メールアドレスの変更に失敗しました\nもう一度お試しください\n(何度も失敗する場合は、再度ログインし直してから試みてください)');
              this.networking = false;
            });
          }else {
            alert('ログインが確認されませんでした\n再度ログインし直してから試みてください');
            this.networking = false;
          }
        }else {
          alert('このメールアドレスは有効でありません\nまたは、誤字脱字の可能性があります');
          this.networking = false;
        }
      }
    },
    changePassword(){
      if (this.newPassword.length >= 6 && this.uid != '') {
        this.networking = true;
        var user = auth.currentUser;
        if (user){
          user.updatePassword(`${this.newPassword}`).then(() => {
            alert('パスワードが変更されました\nセキュリティ上、自動的にログアウトします');
            this.newPassword = '';
            this.networking = false;
            this.logout();
          }).catch(() => {
            alert('パスワードの変更に失敗しました\nもう一度お試しください\n(何度も失敗する場合は、再度ログインし直してから試みてください)');
            this.networking = false;
          });
        }else {
          alert('ログインが確認されませんでした\n再度ログインし直してから試みてください');
          this.networking = false;
        }
      }
    },
    sendInquiry(){
      if (this.inquiryText != '') {
        this.networking = true;
        let inquiryID = uuid.v4();
        var docRef = firestore.collection("inquiry").doc(inquiryID);
        docRef.set({title:'Psyなび Studio より',content:this.inquiryText}).then(() => {
          alert('ありがとうございます！\nお問い合わせは送信されました');
          this.inquiryText = '';
          this.networking = false;
        }).catch(() => {
          alert('申し訳ありません\nお問い合わせの送信に失敗しました\nもう一度お試しください');
          this.networking = false;
        });
      }
    },
    deleteAll(){
      this.networking = true;

      this.$store.dispatch('userDelete').then(stop => {
        this.networking = stop;
      }, error => {
        this.networking = error;
      });
    }
  }
};
</script>

<style scoped>
.edit_setting_zone{
  height: 100%;
  min-height: 100vh;
  color:black;
  position: relative;
  background-color:#040433;
}

h2{
  margin:0;
}

.setting_box{
  display: inline-block;
  position: absolute;
  top:0;
  right:0;
  width:75%;
  padding-top:30px;
}

.setting_unit{
  margin:0 0 10px 10px;
}

.inner_unit{
  position:relative;
}

.space_area{
  position: absolute;
  top:0;
  left:0;
  width:50%;
}

.inquiry_and_delete{
  position:absolute;
  top:0;
  right:0;
  width:50%;
}

.logout_btn{
  font-size:1.8rem;
  text-align:center;
  position:absolute;
  top:0;
  right:15px;
  cursor:pointer;
}

.input_editing{
  font-size:1.8rem;
  padding:3px;
  width:35%;
}

@media (max-width:1195px){
.edit_setting_zone{
  font-size:0.8rem;
}

.logout_btn{
  font-size:1.2rem;
}

.input_editing{
  font-size:1.2rem;
}
}
</style>
