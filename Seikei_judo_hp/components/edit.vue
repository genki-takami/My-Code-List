<template>
  <div id="edit">
    <div style="text-align: right;">
      <button @click="logout" class="editor_component logout_style">ログアウト</button>
    </div>
    <button class="editor_tab" @click="nowcomponent = 'Topic'">トップニュース</button>
    <button class="editor_tab" @click="nowcomponent = 'News'">ニュース</button>
    <button class="editor_tab" @click="nowcomponent = 'Articles'">アーティクル</button>
    <button class="editor_tab" @click="nowcomponent = 'IntroduceSentences'">紹介文</button>
    <button class="editor_tab" @click="nowcomponent = 'Members'">部員</button>
    <button class="editor_tab" @click="nowcomponent = 'CoachTrainer'">監督など</button>
    <button class="editor_tab" @click="nowcomponent = 'TokyoStudentGroup'">東京学生柔道優勝大会</button>
    <button class="editor_tab" @click="nowcomponent = 'FourFresh'">四大新人戦</button>
    <button class="editor_tab" @click="nowcomponent = 'TokyoStudentPersonal'">東京学生柔道体重別選手権大会</button>
    <button class="editor_tab" @click="nowcomponent = 'FourMain'">四大本戦</button>
    <button class="editor_tab" @click="nowcomponent = 'Suginami'">杉並区民大会</button>
    <button class="editor_tab" @click="nowcomponent = 'TokyoSecond'">二部大会</button>
    <button class="editor_tab" @click="nowcomponent = 'TokyoOpen'">オープン大会</button>
    <button class="editor_tab" @click="nowcomponent = 'RikouMatch'">理工大会</button>
    <button class="editor_tab" @click="nowcomponent = 'CalendearImages'">カレンダー</button>
    <button class="editor_tab" @click="nowcomponent = 'Schedules'">スケジュール</button>
    <button class="editor_tab" @click="nowcomponent = 'Archive'">アーカイブ</button>
    <keep-alive>
      <component :is="nowcomponent" class="editor_component"></component>
    </keep-alive>
    <p class="please_reload">※送信後に再編集する場合はサイトを再読み込み(リロード)する必要があります！</p>
  </div>
</template>

<script>
import Archive from "./post_archive.vue";
import Articles from "./post_articles.vue";
import CalendearImages from "./post_calendar_images.vue";
import CoachTrainer from "./post_coach_trainer.vue";
import FourFresh from "./post_four_fresh.vue";
import FourMain from "./post_four_main.vue";
import IntroduceSentences from "./post_introduce_sentences.vue";
import Members from "./post_members.vue";
import News from "./post_news.vue";
import RikouMatch from "./post_rikou_match.vue";
import Schedules from "./post_schedules.vue";
import Suginami from "./post_suginami.vue";
import TokyoOpen from "./post_tokyo_open.vue";
import TokyoSecond from "./post_tokyo_second.vue";
import TokyoStudentPersonal from "./post_tokyo_student_personal.vue";
import TokyoStudentGroup from "./post_tokyo_student_group.vue";
import Topic from "./post_topic.vue";
export default {
  data() {
    return {
      nowcomponent:'Topic'
    };
  },
  components:{
    Archive,
    Articles,
    CalendearImages,
    CoachTrainer,
    FourFresh,
    FourMain,
    IntroduceSentences,
    Members,
    News,
    RikouMatch,
    Schedules,
    Suginami,
    TokyoOpen,
    TokyoSecond,
    TokyoStudentPersonal,
    TokyoStudentGroup,
    Topic
  },
  methods: {
    logout() {
      this.$store.dispatch('logout');
    }
  }
};
</script>

<style scoped>
.editor_tab{
  padding:10px;
  margin:5px;
  font-size:1.5rem ;
  color: white;
  background-color: #2d3d54;
  font-weight: bold;
  border: none;
  cursor:pointer;
}

.editor_tab:hover{
  color:gold;
}

.editor_component{
  margin: 5px 5px;
  padding: 15px 15px;
  width: 100%;
  /* border: 1px solid black; */
}

.logout_style{
  width: 100px;
  padding: 10px 10px;
  font-weight: bold;
  border:2px solid crimson;
  cursor:pointer;
  background-color:crimson;
  color:white;
}

.logout_style:hover{
  background-color:deeppink;
  border:2px solid deeppink;
}

@media  (min-width: 500px) and (max-width:1000px){
.logout_style{
  margin-top: 17px;
  margin-right: 12px;
}

.please_reload{
  margin: 9px 22px;
  font-size: 1.5rem;
}
}

@media (max-width:499px) {
.logout_style{
  margin-top: 30px;
}

.editor_tab{
  font-size: 1.2rem;
}

.please_reload{
  margin: 9px 22px;
  font-size: 1.5rem;
}
}
</style>
