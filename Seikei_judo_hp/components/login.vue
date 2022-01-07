<template>
  <div id="login">
    <form id="login_form">
      <div>
        <label for="login_email">Mail</label><br>
        <input id="login_email" type="email" required v-model="email">
      </div>
      <div>
        <label for="login_password">Password</label><br>
        <input id="login_password" type="password" required v-model="password">
      </div>
      <div>
        <button id="login_submit_button" type="submit" @click="login">Done</button>
      </div>
    </form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      email: '',
      password: ''
    };
  },
  methods: {
    login() {
      this.$store.dispatch('login', {
        email: this.email,
        password: this.password
      });
      this.email = '';
      this.password = '';
    }
  }
};
</script>

<style scoped>
#login {
  padding:272px 0;
  display: block;
  background-image: url("https://cdn.pixabay.com/photo/2016/05/05/02/37/sunset-1373171_960_720.jpg");
  background-size: cover;
  position: relative;
}

#login::before{
  background-color: rgba(0,0,0,0.3);
	position: absolute;
	top: 0;
	right: 0;
	bottom: 0;
	left: 0;
	content: ' ';
}

#login_form{
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  margin-top: 50px;
  text-align: center;
  font-size: 2.5rem;
  font-family: serif;
}

#login_form label{
  color:white;
  font-weight:bold;
}

#login_email,#login_password{
  width:246px;
  margin: 14px 0;
  line-height: 20px;
}

#login_submit_button{
  font-size: 2rem;
  margin-top: 30px;
  width: 168px;
  height: 43px;
  cursor:pointer;
}
</style>
