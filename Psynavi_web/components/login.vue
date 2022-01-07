<template>
  <div class="login_form">
    <div class="login_permission">
      <div class="login_left">
        <div v-if="isLogin" class="login_area">
          <h1 style="text-align: center;">ログイン</h1>
          <div class="login_text">
            <label>メールアドレス</label><br>
            <input type="email" v-model="email" class="login_input">
          </div>
          <div class="login_text">
            <label>パスワード</label><br>
            <input type="password" v-model="password" class="login_input">
          </div>
          <div class="login_btn">
            <button type="submit" @click="login">Let's Go!</button>
            <span v-if="alertText">{{ alertText }}</span>
          </div>
        </div>
        <div v-else class="login_area">
          <h1 style="text-align: center;">新規作成</h1>
          <div class="login_text">
            <label>アカウント名</label><br>
            <input type="text" v-model="newDisplayName" class="login_input" placeholder="団体名や組織名など">
          </div>
          <div class="login_text">
            <label>メールアドレス</label><br>
            <input type="email" v-model="newEmail" class="login_input" placeholder="有効なメールアドレス">
          </div>
          <div class="login_text">
            <label>パスワード</label><br>
            <input type="password" v-model="newPassword" class="login_input" placeholder="６文字以上">
          </div>
          <div class="login_btn">
            <button type="submit" @click="signUP">Let's Start!</button>
            <span v-if="alertText2">{{ alertText2 }}</span>
          </div>
        </div>
        <button type="button" class="change_form" @click="changeField">{{ changeText }}</button>
        <div v-if="nowLoading" class="loading_text">
          <h1><i class="fas fa-sync fa-5x fa-spin"></i></h1>
        </div>
      </div>
      <div class="login_right">
        <img src="https://cdn.pixabay.com/photo/2021/03/15/07/03/programmers-6096322_960_720.png" alt="ログイン画像">
      </div>
    </div>
    <div class="login_cancel">
      <h2>※画面が小さすぎます！<br>ノートパソコンかディスプレイ幅が1000px以上の端末で操作してください！</h2>
      <img src="https://cdn.pixabay.com/photo/2013/07/13/14/08/deckchair-162188_960_720.png" alt="画面が小さい">
    </div>
  </div>
</template>

<script>
export default {
  data(){
    return {
      email: '',
      password: '',
      newDisplayName:'',
      newEmail:'',
      newPassword:'',
      changeText:'＞新規登録/作成はこちら',
      isLogin:true,
      nowLoading:false,
      alertText:'',
      alertText2:''
    };
  },
  methods: {
    login() {
      this.nowLoading = true;
      this.$store.dispatch('login', {
        email: this.email,
        password: this.password
      }).then(stopBool => {
        this.nowLoading = stopBool;
      }, error => {
        this.alertText = error.slice(5);
        this.nowLoading = false;
      });
    },
    changeField(){
      this.isLogin ? this.isLogin = false : this.isLogin = true;
      this.isLogin ? this.changeText = '＞新規登録/作成はこちら' : this.changeText = 'ログインに戻る';
    },
    signUP(){
      if (this.newEmail != '' && this.newDisplayName != '' && this.newPassword.length >= 6) {
        var reg = /^[a-zA-Z0-9.!#$&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$/;
        if (reg.test(this.newEmail)) {
          this.nowLoading = true;
          this.$store.dispatch('signin',{
            email: this.newEmail,
            password: this.newPassword,
            name: this.newDisplayName
          });
          this.newEmail = '';
          this.newPassword = '';
          this.newDisplayName = '';
        }else this.alertText2 = '入力したメールアドレスは有効ではありません';
      } else this.alertText2 = '文字が未入力かパスワードが６文字以上でないです';
    }
  }
};
</script>

<style scoped>
.login_form{
  height: 100%;
  min-height: 100vh;
  color:black;
  padding:80px 0 68px;
}

.login_cancel{
  display: none;
}

.login_permission{
  width: 100%;
  height: 100%;
  min-height: 100vh;
  position: relative;
  background-color: orange;
}

.login_left{
  position: absolute;
  top:0;
  left:0;
  width: 50%;
}

.login_right{
  position: absolute;
  top:0;
  right:0;
  width: 50%;
  padding: 30px 30px 0 0;
}

.login_area{
  margin: 110px 60px 0;
  background-color: dodgerblue;
  border-radius: 15px;
  padding: 20px 20px;
  color: white;
}

.login_text{
  font-size: 1.5rem;
  margin-bottom: 10px;
  font-weight: bold;
}

.login_input{
  width: 90%;
  border: none;
  border-radius:5px;
  line-height: 2.5rem;
}

.login_btn button{
  border: none;
  border-radius: 5px;
  background-color: deeppink;
  color: white;
  font-weight: bold;
  font-size: 1.5rem;
  padding:5px 10px;
  cursor:pointer;
}

.login_btn button:hover{
  background-color:pink;
}

.login_btn span{
  margin-left: 10px;
  padding: 5px;
  color: red;
  background-color: white;
  font-weight: bold;
  border-radius:5px;
}

.login_right img{
  width: 100%;
  object-fit: contain;
}

.change_form{
  margin-left: 60px;
  border: none;
  background-color: orange;
  color: purple;
  font-size: 1.5rem;
  font-weight: bold;
  cursor:pointer;
}

.change_form:hover{
  color:white;
}

.loading_text{
  padding:5px 60px;
  text-align: center;
  color: white;
}

@media (max-width:1000px) {
.login_permission{
  display: none;
}

.login_cancel{
  display: block;
  text-align: center;
  width: 65%;
  margin: 60px auto 0;
}

.login_cancel img{
  width: 65%;
  object-fit: contain;
}
}
</style>
