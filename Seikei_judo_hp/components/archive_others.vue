<template>
  <div class="content_wall">
    <div class="wrapper clearfix">
      <div class="main">
        <span v-if="err" style="color:red;font-size: 2.4rem;font-weight: bold;margin-left:13px;">データ受信エラー</span>
        <!-- インデックスボタン -->
        <div class="index_block">
          <div v-for="index in archiveObjects.length" :key="index" style="display:inline-block;margin:5px;">
            <button @click="showArchive(archiveObjects[index - 1].title)">{{ archiveObjects[index - 1].title }}</button>
          </div>
        </div>
        <!-- アーカイブ -->
        <div v-for="n in archiveObjects.length" :key="n">
          <template v-if="selected == archiveObjects[n - 1].title">
            <!-- ヘッダー -->
            <div class="archive_head">
              <h2><span class="accept_space"></span>{{ archiveObjects[n - 1].title }}</h2>
            </div>
            <!-- 運営体制ファイル -->
            <template v-if="Object.keys(archiveObjects[n - 1].file).length !== 0">
              <div class="calendar_head ">
                <h1>運営体制</h1>
              </div>
              <div class="plan">
                <ul>
                  <div v-for="planIndex in archiveObjects[n - 1].file.name.arrayValue.values.length" :key="planIndex">
                    <li>
                      <a :href="archiveObjects[n - 1].file.url.arrayValue.values[planIndex - 1].stringValue" target="_blank">
                        {{ archiveObjects[n - 1].file.name.arrayValue.values[planIndex - 1].stringValue }}
                      </a>
                    </li>
                  </div>
                </ul>
              </div>
            </template>
            <!-- カレンダー -->
            <template v-if="Object.keys(archiveObjects[n - 1].calendar).length !== 0">
              <div class="calendar_head ">
                <h1>スケジュールカレンダー</h1>
              </div>
              <div class="month_photo_2 ">
                <a :href="archiveObjects[n - 1].calendar.url1.stringValue" target="_blank"><img src="https://3.bp.blogspot.com/-qiEFidRnPMk/U8XkvNrFT9I/AAAAAAAAi3I/57gfMd3GrFQ/s300/tsuki_title01.png" width="170"></a>
                <a :href="archiveObjects[n - 1].calendar.url2.stringValue" target="_blank"><img src="https://1.bp.blogspot.com/-dTmHITKHw6s/U8XkvSYml8I/AAAAAAAAi3Q/kM0rjYAHiUw/s300/tsuki_title02.png" width="170"></a>
                <a :href="archiveObjects[n - 1].calendar.url3.stringValue" target="_blank"><img src="https://4.bp.blogspot.com/-WsMGh5LpZN0/U8XkvkNQZqI/AAAAAAAAi3U/Eg9DY3Az4_s/s300/tsuki_title03.png" width="170"></a>
                <a :href="archiveObjects[n - 1].calendar.url4.stringValue" target="_blank"><img src="https://1.bp.blogspot.com/-u6QSJJIQCZM/U8XkwJvPXmI/AAAAAAAAi3c/-g1D77EKGKc/s300/tsuki_title04.png" width="170"></a>
                <a :href="archiveObjects[n - 1].calendar.url5.stringValue" target="_blank"><img src="https://2.bp.blogspot.com/-2A4dDGGKkIk/U8XkwTo5kkI/AAAAAAAAi3k/zjV3nf9O8zE/s300/tsuki_title05.png" width="170"></a>
                <a :href="archiveObjects[n - 1].calendar.url6.stringValue" target="_blank"><img src="https://3.bp.blogspot.com/-v_RtDt-S6g8/U8XkwpSQiSI/AAAAAAAAi3s/ZI9rb1F2DgY/s300/tsuki_title06.png" width="170"></a>
                <a :href="archiveObjects[n - 1].calendar.url7.stringValue" target="_blank"><img src="https://1.bp.blogspot.com/-dmF08LX4j_g/U8XkxIG_DZI/AAAAAAAAi3w/f5BgsGBSuJ0/s300/tsuki_title07.png" width="170"></a>
                <a :href="archiveObjects[n - 1].calendar.url8.stringValue" target="_blank"><img src="https://2.bp.blogspot.com/-SL05y-_psJc/U8XkxXNcciI/AAAAAAAAi34/_edJyZzihdM/s300/tsuki_title08.png" width="170"></a>
                <a :href="archiveObjects[n - 1].calendar.url9.stringValue" target="_blank"><img src="https://4.bp.blogspot.com/-I0wQNl0kuNw/U8XkxvipODI/AAAAAAAAi4I/BnRcPjSKA1w/s300/tsuki_title09.png" width="170"></a>
                <a :href="archiveObjects[n - 1].calendar.url10.stringValue" target="_blank"><img src="https://2.bp.blogspot.com/-bsU7PQpPjEU/U8Xkx10jejI/AAAAAAAAi4E/BAfM-wOxnIg/s300/tsuki_title10.png" width="170"></a>
                <a :href="archiveObjects[n - 1].calendar.url11.stringValue" target="_blank"><img src="https://2.bp.blogspot.com/-tDSpOOsm4Eo/U8XkyBchALI/AAAAAAAAi4M/YiawtwsFzfM/s300/tsuki_title11.png" width="170"></a>
                <a :href="archiveObjects[n - 1].calendar.url12.stringValue" target="_blank"><img src="https://1.bp.blogspot.com/-8PFUVpeNfMI/U8Xky953b9I/AAAAAAAAi4Y/IebnDQBC5ck/s300/tsuki_title12.png" width="170"></a>
              </div>
            </template>
            <!-- 試合結果 -->
            <template v-if="Object.keys(archiveObjects[n - 1].match).length !== 0">
              <div class="calendar_head ">
                <h1>大会成績</h1>
              </div>
              <div>
                <div v-for="matchIndex in archiveObjects[n - 1].match.name.arrayValue.values.length" :key="matchIndex" style="display:inline-block;">
                  <div class="ribbon13-wrapper">
                    <div class="ribbon13">
                      <h3>{{ archiveObjects[n - 1].match.name.arrayValue.values[matchIndex - 1].stringValue }}</h3>
                    </div>
                    <p class="no1" v-html="archiveObjects[n - 1].match.text.arrayValue.values[matchIndex - 1].stringValue"></p>
                  </div>
                </div>
              </div>
            </template>
            <!-- 動画 -->
            <template v-if="Object.keys(archiveObjects[n - 1].video).length !== 0">
              <div class="calendar_head ">
                <h1>制作動画</h1>
              </div>
              <div class="match_box ">
                <div v-for="videoIndex in archiveObjects[n - 1].video.name.arrayValue.values.length" :key="videoIndex">
                  <div class="ribbon20-wrapper">
                    <h3 class="ribbon20">動画</h3>
                    <p>
                      <a :href="archiveObjects[n - 1].video.url.arrayValue.values[videoIndex - 1].stringValue">
                        {{ archiveObjects[n - 1].video.name.arrayValue.values[videoIndex - 1].stringValue }}
                      </a>
                    </p>
                  </div>
                </div>
              </div>
            </template>
            <!-- ニュース -->
            <template v-if="Object.keys(archiveObjects[n - 1].news).length !== 0">
              <div class="calendar_head">
                <h1>デイリートピックス</h1>
              </div>
              <section class="news">
                <ul class="scroll-list archive_scroll-list">
                  <div v-for="newsIndex in archiveObjects[n - 1].news.date.arrayValue.values.length" :key="newsIndex">
                    <li class="scroll-item" style="border-bottom:1px dashed black;">
                      <a :href="archiveObjects[n - 1].news.url.arrayValue.values[newsIndex - 1].stringValue">
                        <time class="date">{{ archiveObjects[n - 1].news.date.arrayValue.values[newsIndex - 1].stringValue }}</time>
                        <span class="category">
                          <span class="accept_space"></span>{{ archiveObjects[n - 1].news.category.arrayValue.values[newsIndex - 1].stringValue }}<span class="accept_space"></span>
                        </span>
                        <span class="title">{{ archiveObjects[n - 1].news.text.arrayValue.values[newsIndex - 1].stringValue }}</span>
                      </a>
                    </li>
                  </div>
                </ul>
              </section>
            </template>
          </template>
        </div>
      </div>
      <SIDEMENU></SIDEMENU>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import SIDEMENU from "./sidemenu.vue";
export default {
  components:{
    SIDEMENU
  },
  data(){
    return{
      err:false,
      selected:'',
      archiveObjects:[]
    };
  },
  created(){
    axios.get('/archives/archive-index')
          .then(response => {
            let archiveCount = parseInt(response.data.fields.length.doubleValue);
            if (archiveCount > 0) {
              const pageArray = [...Array(archiveCount).keys()].map(i => ++i);
              const addArchive = async (pages) => {
                for (var page of pages) {
                  let year = parseInt(page) + 2020;
                  await axios.get('/archives/archive-index/archive' + year)
                              .then(response => {
                                let data = response.data.documents;
                                let config = data[1].fields;
                                let title = config.title.stringValue;
                                var file, calendar, match, video, news;
                                config.file.booleanValue ? file = data[2].fields : file = {} ;
                                config.calendar.booleanValue ? calendar = data[0].fields : calendar = {} ;
                                config.match.booleanValue ? match = data[3].fields : match = {} ;
                                config.video.booleanValue ? video = data[5].fields : video = {} ;
                                config.news.booleanValue ? news = data[4].fields : news = {} ;
                                let object = {
                                  title:title,
                                  file:file,
                                  calendar:calendar,
                                  match:match,
                                  video:video,
                                  news:news
                                };
                                this.archiveObjects.push(object);
                              }).catch(error => {
                                if (error) {
                                  // エラー
                                  this.err = true;
                                }
                              });
                }
              };
              // ページの配列をパラメータに関数を実行
              addArchive(pageArray);
            }
          }).catch(error => {
            if (error) {
              // エラー
              this.err = true;
            }
          });
  },
  methods:{
    showArchive(arg){
      this.selected = arg;
    }
  }
};
</script>
