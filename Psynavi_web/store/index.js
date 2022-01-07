import Vue from 'vue';
import Vuex from 'vuex';
import router from '../router';
import { auth } from '../firebase';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    idToken: null,
    userEmail:null,
    userDisplayName:null,
    headerPosition:1
  },
  getters: {
    idToken: state => state.idToken,
    userEmail: state => state.userEmail,
    userDisplayName: state => state.userDisplayName,
    headerPosition: state => state.headerPosition
  },
  mutations: {
    updateIdToken(state, authData) {
      state.idToken = authData.idToken;
      state.userEmail = authData.userEmail;
      state.userDisplayName = authData.userDisplayName;
    },
    setHeaderPosition(state, position){
      state.headerPosition = position;
    }
  },
  actions: {
    async autoLogin({ commit }) {
      const position = localStorage.getItem('headerPositionPsynaviStudio');
      if (position) commit('setHeaderPosition', position);
      const idToken = localStorage.getItem('idTokenPsynaviStudio');
      if (!idToken) return;
      const mailAddressData = localStorage.getItem('userEmailPsynaviStudio');
      const displayNameData = localStorage.getItem('userDisplayNamePsynaviStudio');
      commit('updateIdToken', {
        idToken: idToken,
        userEmail: mailAddressData,
        userDisplayName: displayNameData
      });
    },
    signin({ dispatch }, authData){
      var newEmail = authData.email;
      var newPassword = authData.password;
      var newDisplayName = authData.name;
      auth.createUserWithEmailAndPassword(newEmail, newPassword)
          .then((userCredential) => {
            var newUser = auth.currentUser;
            newUser.updateProfile({
              displayName:newDisplayName
            }).then(() => {
              var user = userCredential.user;
              var uid = user.uid;
              var mailAddress = user.email;
              var displayName = user.displayName;
              dispatch('setAuthData', {
                idToken: uid,
                userEmail: mailAddress,
                userDisplayName: displayName
              });
              router.push('/editor');
            }).catch(() => {
              alert('アカウント名の登録に失敗しました\nログイン画面にて、先程のメールアドレスとパスワードでログインし「設定＆ログアウト」から再登録してください');
            });
          })
          .catch(() => {
            alert('新規作成に失敗しました\n再度お試しください');
          });
    },
    login({ dispatch }, authData) {
      return new Promise((resolve, reject) => {
        var email = authData.email;
        var password = authData.password;
        auth.signInWithEmailAndPassword(email, password)
            .then(userCredential => {
              var user = userCredential.user;
              var uid = user.uid;
              var mailAddress = user.email;
              var displayName = user.displayName;
              dispatch('setAuthData', {
                idToken: uid,
                userEmail: mailAddress,
                userDisplayName: displayName
              });
              router.push('/editor');
              resolve(false);
            })
            .catch(error => {
              reject(error.code);
            });
      });
    },
    logout({ commit }) {
      auth.signOut()
          .then(() => {
            commit('updateIdToken', {
              idToken: null,
              userEmail: null,
              userDisplayName: null
            });
            commit('setHeaderPosition', 2);
            localStorage.removeItem('idTokenPsynaviStudio');
            localStorage.removeItem('userEmailPsynaviStudio');
            localStorage.removeItem('userDisplayNamePsynaviStudio');
            localStorage.removeItem('headerPositionPsynaviStudio');
            router.replace('/login');
          }).catch(() => {
            alert('ログアウトに失敗しました\n再度お試しください');
          });
    },
    setAuthData({ commit }, authData) {
      commit('updateIdToken', authData);
      localStorage.setItem('idTokenPsynaviStudio', authData.idToken);
      localStorage.setItem('userEmailPsynaviStudio', authData.userEmail);
      localStorage.setItem('userDisplayNamePsynaviStudio', authData.userDisplayName);
    },
    changeHeaderPosition({ commit }, position){
      commit('setHeaderPosition', position);
      localStorage.setItem('headerPositionPsynaviStudio', position);
    },
    userDelete({ commit }){
      return new Promise((resolve, reject) => {
        commit('updateIdToken', {
          idToken: null,
          userEmail: null,
          userDisplayName: null
        });
        commit('setHeaderPosition', 1);
        localStorage.removeItem('idTokenPsynaviStudio');
        localStorage.removeItem('userEmailPsynaviStudio');
        localStorage.removeItem('userDisplayNamePsynaviStudio');
        localStorage.removeItem('headerPositionPsynaviStudio');
        var user = auth.currentUser;
        user.delete().then(() => {
          alert('アカウント及びすべてのデータを削除しました');
          resolve(false);
          router.replace('/');
        }).catch(() => {
          alert('アカウント削除に失敗しました\n再度ログインし直してから試みてください');
          reject(false);
          router.replace('/');
        });
      });
    }
  }
});
