<template>
  <div>
    <section class="hot-topic ">
      <a :href="topicsUrl" target="_blank" class="hot-topic-content clearfix">
        <img class="image" :src="topicsImageurl" alt="画像">
        <div class="content">
          <h3 class="title">{{ topicsTitle }}<i class="fas fa-external-link-alt accept_space"></i></h3>
          <p class="desc">{{ topicsText }}</p>
          <time class="date">{{ topicsDate }}</time>
        </div>
      </a>
    </section>
    <iframe
    id="iframe_top"
    allow="microphone;"
    src="https://console.dialogflow.com/api-client/demo/embedded/9f65cc0d-3eb0-477b-816c-87d5ddce431b">
    </iframe>
    <section class="news ">
      <h2 class="heading">NEWS</h2>
      <ul class="scroll-list">
        <div v-for="news in newsList" :key="news.idNumber.doubleValue">
          <li class="scroll-item">
            <a :href="news.url.stringValue" target="_blank">
              <time class="date">{{ news.date.stringValue }}</time>
              <span class="category">{{ news.category.stringValue }}</span>
              <span class="title">{{ news.text.stringValue }}</span>
              <span class="link_icon"><i class="fas fa-external-link-alt"></i></span>
            </a>
          </li>
        </div>
      </ul>
    </section>
  </div>
</template>

<script>
import axios from 'axios';
export default{
  data() {
    return {
      topicsDate:'',
      topicsTitle:'',
      topicsText:'',
      topicsUrl:'',
      topicsImageurl:'',
      newsList:[],
      idList:[]
    };
  },
  created() {
    axios.get(process.env.VUE_APP_TOPICS_PATH)
          .then(response => {
            this.topicsDate = response.data.fields.date.stringValue;
            this.topicsTitle = response.data.fields.title.stringValue;
            this.topicsText = response.data.fields.text.stringValue;
            this.topicsUrl = response.data.fields.url.stringValue;
            this.topicsImageurl = response.data.fields.imageurl.stringValue;
          });
    axios.get('/news')
          .then(response => {
            let data = response.data;
            if (Object.keys(data).length !== 0) {
              this.idList = data.documents[1].fields.list.arrayValue.values;
              for (var i = 0; i < this.idList.length; i++) {
                let str = this.idList[i].stringValue;
                this.newsList.unshift(data.documents[0].fields[str].mapValue.fields);
              }
            } else {
              let noneObject = {
                idNumber:{
                  doubleValue:1.1
                },
                url:{
                  stringValue:'https://seikei-university-judo-tg.netlify.app/not_ready'
                },
                date:{
                  stringValue:'----.--.-- ---'
                },
                category:{
                  stringValue:'ーーーー'
                },
                text:{
                  stringValue:'今年のニュースはまだありません'
                }
              };
              this.newsList.unshift(noneObject);
            }
            // // 降順に並び替え
            // this.newsList.sort(function(a,b){
            //   if(a.fields.idNumber.doubleValue > b.fields.idNumber.doubleValue) return -1;
            //   if(a.fields.idNumber.doubleValue < b.fields.idNumber.doubleValue) return 1;
            //   return 0;
            // });
          });
  }
};
</script>

<style scoped>
.hot-topic-content{
  display: block;
  height:300px;
  margin-bottom:30px;
  box-shadow:0 6px 4px -4px rgba(0,0,0,0.15);
  transition: opacity 0.15s;
}

.hot-topic-content:hover{
  opacity:0.85;
}

.hot-topic-content .image{
  float: left;
  width:50%;
  height:100%;
  object-fit:cover;
}

.hot-topic-content .content{
  float: right;
  width:50%;
  height:100%;
  padding:105px 25px 0;
  background-color:#2d3d54;
  position: relative;
  line-height:1.6;
}

.hot-topic-content .title{
  margin-bottom:15px;
  color:#fff;
  font-weight:normal;
  font-size:2rem;
}

.hot-topic-content .desc{
  color:#ddc;
}

.hot-topic-content .date{
  position: absolute;
  top:60px;
  left:0;
  width:140px;
  padding:4px;
  background-color:#ec7211;
  color:white;
  text-align: center;
  letter-spacing:1px;
  font-weight: bold;
  font-size:1.1rem;
  line-height:1;
}

#iframe_top{
  display: none;
}

.heading{
  text-align: center;
  padding:10px 12px;
  background-color:#2d3d54;
  letter-spacing:1px;
  font-size:1.6rem;
  color:white;
}

.news h2{
  margin-bottom: 0;
}

.news .scroll-list{
  margin-top: 0;
}

.scroll-list{
  max-height:220px;
  overflow-y: auto;
  margin-bottom:30px;
  list-style-type: none;
  background-color: white;
}

.scroll-list .scroll-item a{
  display: block;
  padding: 10px 15px;
  color:#333;
  transition:background-color 0.1s;
}

.scroll-list .scroll-item{
  border-bottom:1px dashed black;
}

.scroll-list .scroll-item a:hover{
  background-color:#fafaf8;
}

.scroll-list .date{
  display: inline-block;
  width:25%;
  letter-spacing:1px;
  font-weight: bold;
}

.scroll-list .category{
  text-align: center;
  display:inline-block;
  width:12%;
  letter-spacing:1px;
  line-height: 16px;
}

.scroll-list .title{
  display: inline-block;
  width:53%;
  padding-left:15px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  line-height:1;
}

.scroll-list .link_icon{
  display:inline-block;
  width:10%;
  letter-spacing:1px;
  padding-left:25px;
}

@media  (min-width: 500px) and (max-width:1000px){
.hot-topic-content{
  height:300px;
  margin-bottom: 0;
}

.hot-topic-content .image{
  width:60%;
}

.hot-topic-content .content{
  width:40%;
  padding:50px 25px 0 25px;
}

.hot-topic-content .title{
  font-size:2.5rem;
  font-weight: bold;
}

.hot-topic-content .desc{
  font-size:1.8rem;
}

.hot-topic-content .date{
  position: absolute;
  top:15px;
  left:0;
  width:210px;
  padding:8px 0;
  background-color:#FF9933;
  color:white;
  text-align: center;
  letter-spacing:1px;
  font-weight: bold;
  font-size:2rem;
}

#iframe_top{
  display:block;
  height: 360px;
  width:100%;
  border-width: 0;
  border-style: none;
}

#header{
  display:none;
}

.heading{
  text-align: center;
  letter-spacing:8px;
  font-size:2rem;
  color:white;
  margin-top:0;
}

.scroll-list{
  max-height:250px;
  margin-bottom:0;
}

.scroll-list .scroll-item a{
  font-size:1.7rem;
  font-weight: bold;
  padding: 10px 0;
}

.scroll-list .scroll-item+.scroll-item a{
  border-top:1px dashed black;
}
}

@media (min-width: 500px) and (max-width:801px){
.hot-topic-content .title{
  font-size:26px;
}

.hot-topic-content .desc{
  font-size:15px;
}

.scroll-list .scroll-item a{
  font-size:1.4rem;
}
}

@media (max-width:499px) {
.hot-topic-content{
  height:200px;
  margin-bottom: 0;
}

.hot-topic-content .image{
  width:48%;
}

.hot-topic-content .content{
  width:52%;
  padding:50px 25px 0 25px;
}

.hot-topic-content .title{
  font-size:1.4rem;
  font-weight: bold;
}

.hot-topic-content .desc{
  font-size:1rem;
}

.hot-topic-content .date{
  position: absolute;
  top:15px;
  left:0;
  width:120px;
  padding:8px 0;
  background-color:#ec7211;
  color:white;
  text-align: center;
  letter-spacing:1px;
  font-weight: bold;
  font-size:1rem;
}

#iframe_top{
  display: block;
  height: 335px;
  width:100%;
  border-width: 0;
  border-style: none;
}

#header{
  display:none;
}

.heading{
  text-align: center;
  letter-spacing:8px;
  font-size:1.3rem;
  color:white;
  margin-top:0;
}

.scroll-list{
  max-height:250px;
  margin-bottom:0;
  padding:0 10px;
}

.scroll-list .scroll-item a{
  font-size:1rem;
  font-weight: bold;
  padding: 10px 0;
}

.scroll-list .scroll-item+.scroll-item a{
  border-top:1px dashed black;
}

.scroll-list .date{
  width:25%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  vertical-align: middle;
}

.scroll-list .category{
  width:17%;

}

.scroll-list .title{
  width:48%;
  padding-left:10px;
  vertical-align: middle;
}

.scroll-list .link_icon{
  width:10%;
  padding-left:22px;
}
}

@media (max-width:321px){
.hot-topic-content .content{
padding:50px 10px 0 10px;
}
}

</style>
