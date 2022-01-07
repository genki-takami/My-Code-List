<template>
  <div id="post_archive">
    <h1 style="margin:0;text-align: center;">{{ title }}</h1>
    <label>作成する年時</label><span v-if="loadErr" style="color:red;font-size: 2.4rem;font-weight: bold;margin-left:13px;">エラーが発生しました。画面をリロードしてください。</span><br>
    <input type="text" placeholder="20XX年(元号XX年)" v-model="year"><br>
    <label>公開する資料の名前</label><br>
    <input type="text" placeholder="例：成蹊大学体育会柔道部活動計画書" v-model="fileName"><br>
    <label>公開する資料のURL</label><br>
    <input type="text" placeholder="https://drive.google.com/file/d/〇〇/view?usp=sharing" v-model="fileUrl"><br>
    <button @click="addFile" class="add_btn">追加</button><br>
    <div class="show_addedData">
      <p>＜ アーカイブに追加する資料 ＞</p>
      <div v-html="addedFileData"></div>
    </div>
    <label>動画の名前</label><br>
    <input type="text" placeholder="例：成蹊大学体育会柔道部PV ver.1" v-model="videoName"><br>
    <label>動画のURL</label><br>
    <input type="text" placeholder="https://〇〇〇.〇〇〇/" v-model="videoUrl"><br>
    <button @click="addVideo" class="add_btn">追加</button><br>
    <div class="show_addedData">
      <p>＜ アーカイブに追加する動画 ＞</p>
      <div v-html="addedVideoData"></div>
    </div>
    <h3 style="color:red;">※カレンダー情報および大会情報、ニュース情報は既存のものが自動的に追加されます</h3>
    <br>
    <button @click="createArchive">アーカイブを作成する</button>
    <span v-if="submit" style="color:green;font-size: 2.4rem;font-weight: bold;margin-left:13px;">送信成功！</span>
    <span v-if="load" style="color:blue;font-size: 2.4rem;font-weight: bold;margin-left:13px;">送信中...</span>
    <span v-if="err" style="color:red;font-size: 2.4rem;font-weight: bold;margin-left:13px;">送信エラー</span>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  data(){
    return {
      title:'',
      year:'',
      fileName:'',
      fileUrl:'',
      videoName:'',
      videoUrl:'',
      addedFileData:'',
      addedVideoData:'',
      submit:false,
      load:false,
      err:false,
      loadErr:false,
      updatedStamp:'',
      fileNames:[],
      fileUrls:[],
      videoNames:[],
      videoUrls:[],
      calendarObject:{},
      pathes:[
        'tokyo-student-group',
        'four-fresh',
        'tokyo-student-personal',
        'four-main',
        'suginami',
        'tokyo-second',
        'tokyo-open',
        'rikou-match',
        'news'
      ],
      taikaimei:[
        '東京学生柔道優勝大会',
        '東京四大学新人戦',
        '東京学生柔道体重別選手権大会',
        '東京四大学本戦',
        '杉並区民体育祭柔道の部',
        '東京学生柔道二部優勝大会',
        '東京学生柔道オープン大会',
        '全日本理工科学生柔道優勝大会'
      ],
      objects:{},
      newsList:[],
      collectionPart:2020,
      taskCounter:0
    };
  },
  created(){
    // アーカイブ年次を決定する
    axios.get('/archives/archive-index')
          .then(response => {
            let archiveCount = parseInt(response.data.fields.length.doubleValue);
            let settingTitle = archiveCount + 2021;
            this.collectionPart = settingTitle;
            this.title = settingTitle + '年のアーカイブを作成';

            // 大会とニュース
            this.pathes.forEach(element => {
              axios.get('/' + element)
                    .then(res => {
                      let list = res.data.documents[1].fields.list.arrayValue.values;
                      if (element == 'news') {
                        for (var j = 0; j < list.length; j++) {
                          let str = list[j].stringValue;
                          this.newsList.unshift(res.data.documents[0].fields[str].mapValue.fields);
                        }
                      } else {
                        if (res.data.documents[1].updateTime.slice(0, 4) == String(settingTitle)) {
                          let str = list.slice(-1)[0].stringValue;
                          this.objects[element] = res.data.documents[0].fields[str].mapValue.fields;
                        }
                      }
                    }).catch(error => {
                      if (error) {
                        this.loadErr = true;
                      }
                    });
            });
          }).catch(error => {
            if (error) {
              this.loadErr = true;
            }
          });
    // カレンダー
    axios.get(process.env.VUE_APP_CALENDAR_IMAGES_PATH)
          .then(response => {
            this.calendarObject = response.data.fields;
          }).catch(error => {
            if (error) {
              this.loadErr = true;
            }
          });
  },
  computed: {
    idToken() {
      return this.$store.getters.idToken;
    }
  },
  watch:{
    taskCounter(val){
      if (val >= 6) {
        this.submit = true;
        this.load = false;
        this.err = false;
      }else {
        this.submit = false;
      }
    }
  },
  methods:{
    addFile(){
      this.fileNames.push({stringValue:this.fileName});
      this.fileUrls.push({stringValue:this.fileUrl});
      this.addedFileData = this.addedFileData + this.fileName + '：' + this.fileUrl + '<br>';
      this.fileName = '';
      this.fileUrl = '';
    },
    addVideo(){
      this.videoNames.push({stringValue:this.videoName});
      this.videoUrls.push({stringValue:this.videoUrl});
      this.addedVideoData = this.addedVideoData + this.videoName + '：' + this.videoUrl + '<br>';
      this.videoName = '';
      this.videoUrl = '';
    },
    createArchive(){
      this.load = true;
      var bFile, bVideo, bNews, bMatch;
      var bCalendar = bMatch = true;
      this.fileNames.length > 0 ? bFile = true : bFile = false;
      this.videoNames.length > 0 ? bVideo = true : bVideo = false;
      this.newsList.length > 0 ? bNews = true : bNews = false;

      // カレンダー
      axios.patch(
        '/archives/archive-index/archive' + this.collectionPart + '/calendar',
        {fields: this.calendarObject},
        {headers: {Authorization: `Bearer ${this.idToken}`}}
      ).then(response => {
        if (response) {
          axios.patch(
            process.env.VUE_APP_CALENDAR_IMAGES_PATCH_PATH,
            {
              fields: {
                url1:{
                  stringValue:'https://seikei-university-judo-tg.netlify.app/not_ready'
                },
                url2:{
                  stringValue:'https://seikei-university-judo-tg.netlify.app/not_ready'
                },
                url3:{
                  stringValue:'https://seikei-university-judo-tg.netlify.app/not_ready'
                },
                url4:{
                  stringValue:'https://seikei-university-judo-tg.netlify.app/not_ready'
                },
                url5:{
                  stringValue:'https://seikei-university-judo-tg.netlify.app/not_ready'
                },
                url6:{
                  stringValue:'https://seikei-university-judo-tg.netlify.app/not_ready'
                },
                url7:{
                  stringValue:'https://seikei-university-judo-tg.netlify.app/not_ready'
                },
                url8:{
                  stringValue:'https://seikei-university-judo-tg.netlify.app/not_ready'
                },
                url9:{
                  stringValue:'https://seikei-university-judo-tg.netlify.app/not_ready'
                },
                url10:{
                  stringValue:'https://seikei-university-judo-tg.netlify.app/not_ready'
                },
                url11:{
                  stringValue:'https://seikei-university-judo-tg.netlify.app/not_ready'
                },
                url12:{
                  stringValue:'https://seikei-university-judo-tg.netlify.app/not_ready'
                }
              }
            },{headers: {Authorization: `Bearer ${this.idToken}`}}
          ).then(response => {
            if (response) {
              this.taskCounter += 1;
            }
          }).catch(error => {
            if (error) {
              this.load = false;
              this.err = true;
            }
          });
        }
      }).catch(error => {
        if (error) {
          this.load = false;
          this.err = true;
        }
      });
      // 資料
      if (bFile) {
        let fileObject = {
          name:{
            arrayValue:{
              values:this.fileNames
            }
          },
          url:{
            arrayValue:{
              values:this.fileUrls
            }
          }
        };
        axios.patch(
          '/archives/archive-index/archive' + this.collectionPart + '/file',
          {fields: fileObject},
          {headers: {Authorization: `Bearer ${this.idToken}`}}
        ).then(response => {
          if (response) {
            this.taskCounter += 1;
          }
        }).catch(error => {
          if (error) {
            this.load = false;
            this.err = true;
          }
        });
      }else {
        // アーカイブするファイルがない
        this.taskCounter += 1;
      }
      // 大会
      var nArray = [];
      var tArray = [];
      for (var path = 0; path < this.pathes.length; path++) {
        let key = this.pathes[path];
        if (this.objects[key]) {
          nArray.push({stringValue:this.taikaimei[path]});
          let fieldsValue = this.objects[key];
          let year = (key == 'tokyo-second' || key == 'tokyo-student-group') ? '20XX年' : fieldsValue.year.stringValue;
          let str;
          if (key == 'four-fresh' || key == 'four-main') {
            str = "<p><br>" + year + "<br>1位 " + fieldsValue.is1st.stringValue + "<br>2位 " + fieldsValue.is2nd.stringValue + "<br>3位 " + fieldsValue.is3rd.stringValue + "<br>4位 " + fieldsValue.worst.stringValue + "<br></p>";
          } else if (key == 'suginami') {
            str = '<p style="font-size:12px;"><br>' + year + '<br>';
            for (var param1 = 0; param1 < fieldsValue.names.arrayValue.values.length; param1++) {
              str = str + fieldsValue.statuses.arrayValue.values[param1].stringValue + '<span class="accept_space"></span>' +
              fieldsValue.names.arrayValue.values[param1].stringValue + '<span class="accept_space"></span>' +
              fieldsValue.numbers.arrayValue.values[param1].stringValue +  '<span class="accept_space"></span>' +
              fieldsValue.results.arrayValue.values[param1].stringValue + '<span class="accept_space"></span>' +
              fieldsValue.whos.arrayValue.values[param1].stringValue + "<br>";
            }
            str = str + "<br></p>";
          } else if (key == 'tokyo-second' || key == 'tokyo-student-group') {
            let mainValues = fieldsValue.main.arrayValue.values;
            str = "<p><br>";
            for (var param3 = 0; param3 < mainValues.length; param3++) {
              str = str + mainValues[param3].mapValue.fields.year.stringValue + '<span class="accept_space"></span>' +
              mainValues[param3].mapValue.fields.title.stringValue + "<br>" +
              '成蹊大学<span class="accept_space"></span><small>' + mainValues[param3].mapValue.fields.myscore.stringValue +
              '</small><span class="accept_space"></span>ー<span class="accept_space"></span><small>' +
              mainValues[param3].mapValue.fields.theirscore.stringValue +  '</small><span class="accept_space"></span>' +
              mainValues[param3].mapValue.fields.university.stringValue + "<br>";
            }
            str = str + "<br></p>";
          } else {
            str = '<p style="font-size:12px;"><br>' + year + '<br>';
            for (var param2 = 0; param2 < fieldsValue.names.arrayValue.values.length; param2++) {
              str = str + fieldsValue.weightclasses.arrayValue.values[param2].stringValue + '<span class="accept_space"></span>' +
              fieldsValue.names.arrayValue.values[param2].stringValue + '<span class="accept_space"></span>' +
              fieldsValue.numbers.arrayValue.values[param2].stringValue +  '<span class="accept_space"></span>' +
              fieldsValue.results.arrayValue.values[param2].stringValue + '<span class="accept_space"></span>' +
              fieldsValue.whos.arrayValue.values[param2].stringValue + "<br>";
            }
            str = str + "<br></p>";
          }
          tArray.push({stringValue:str});
        }
      }
      if (nArray.length && tArray.length) {
        let matchObject = {
          name:{
            arrayValue:{
              values:nArray
            }
          },
          text:{
            arrayValue:{
              values:tArray
            }
          }
        };
        axios.patch(
          '/archives/archive-index/archive' + this.collectionPart + '/match',
          {fields: matchObject},
          {headers: {Authorization: `Bearer ${this.idToken}`}}
        ).then(response => {
          if (response) {
            this.taskCounter += 1;
          }
        }).catch(error => {
          if (error) {
            this.load = false;
            this.err = true;
          }
        });
      } else {
        // アーカイブする大会結果がない
        bMatch = false;
        this.taskCounter += 1;
      }
      // ニュース
      if (bNews) {
        var cList = [];
        var dList = [];
        var tList = [];
        var uList = [];
        for (var nIndex = 0; nIndex < this.newsList.length; nIndex++) {
          cList.push({stringValue:this.newsList[nIndex].category.stringValue});
          dList.push({stringValue:this.newsList[nIndex].date.stringValue});
          tList.push({stringValue:this.newsList[nIndex].text.stringValue});
          uList.push({stringValue:this.newsList[nIndex].url.stringValue});
        }
        let newsObject = {
          category:{
            arrayValue:{
              values:cList
            }
          },
          date:{
            arrayValue:{
              values:dList
            }
          },
          text:{
            arrayValue:{
              values:tList
            }
          },
          url:{
            arrayValue:{
              values:uList
            }
          }
        };
        axios.patch(
          '/archives/archive-index/archive' + this.collectionPart + '/news',
          {fields: newsObject},
          {headers: {Authorization: `Bearer ${this.idToken}`}}
        ).then(response => {
          if (response) {
            let objectId = new Date().getTime().toString(16) + Math.floor(Math.random() * 1000).toString();
            let labelTxt = this.collectionPart + '年度のアーカイブが作成されました';
            var newsPatchObj = {};
            newsPatchObj[objectId] = {
              mapValue:{
                fields:{
                  date:{
                    stringValue:'(´・ω・)つ'
                  },
                  category:{
                    stringValue:'New!'
                  },
                  text:{
                    stringValue:labelTxt
                  },
                  url:{
                    stringValue:'https://seikei-university-judo-tg.netlify.app/archive_others'
                  },
                  idNumber:{
                    doubleValue:1.1
                  }
                }
              }
            };
            axios.patch(
              '/news/data',
              {fields:newsPatchObj},
              {headers: {Authorization: `Bearer ${this.idToken}`}}
            ).then(response => {
              if (response) {
                axios.patch(
                  '/news/idList',
                  {
                    fields:{
                      list:{
                        arrayValue:{
                          values:[{stringValue:objectId}]
                        }
                      }
                    }
                  },
                  {headers: {Authorization: `Bearer ${this.idToken}`}}
                ).then(response => {
                  if (response) {
                    this.taskCounter += 1;
                  }
                }).catch(error => {
                  if (error) {
                    this.load = false;
                    this.err = true;
                  }
                });
              }
            }).catch(error => {
              if (error) {
                this.load = false;
                this.err = true;
              }
            });
          }
        }).catch(error => {
          if (error) {
            this.load = false;
            this.err = true;
          }
        });
      } else {
        // アーカイブするニュースがない
        this.taskCounter += 1;
      }
      // 動画
      if (bVideo) {
        let videoObject = {
          name:{
            arrayValue:{
              values:this.videoNames
            }
          },
          url:{
            arrayValue:{
              values:this.videoUrls
            }
          }
        };
        axios.patch(
          '/archives/archive-index/archive' + this.collectionPart + '/video',
          {fields: videoObject},
          {headers: {Authorization: `Bearer ${this.idToken}`}}
        ).then(response => {
          if (response) {
            this.taskCounter += 1;
          }
        }).catch(error => {
          if (error) {
            this.load = false;
            this.err = true;
          }
        });
      }else {
        // アーカイブする動画がなかった
        this.taskCounter += 1;
      }
      // Config
      let configObject = {
        calendar:{
          booleanValue:bCalendar
        },
        file:{
          booleanValue:bFile
        },
        match:{
          booleanValue:bMatch
        },
        news:{
          booleanValue:bNews
        },
        title:{
          stringValue:this.year
        },
        video:{
          booleanValue:bVideo
        }
      };
      axios.patch(
        '/archives/archive-index/archive' + this.collectionPart + '/config',
        {fields: configObject},
        {headers: {Authorization: `Bearer ${this.idToken}`}}
      ).then(response => {
        if (response) {
          // アーカイブの数を増やす
          let nowLength = this.collectionPart - 2021;
          let newLength = nowLength + 1.1;
          axios.patch(
            '/archives/archive-index?updateMask.fieldPaths=length',
            {
              fields:{
                length:{
                  doubleValue:newLength
                }
              }
            },{headers: {Authorization: `Bearer ${this.idToken}`}}
          ).then(response => {
            if (response) {
              this.taskCounter += 1;
            }
          }).catch(error => {
            if (error) {
              this.load = false;
              this.err = true;
            }
          });
        }
      }).catch(error => {
        if (error) {
          this.load = false;
          this.err = true;
        }
      });
    }
  }
}
</script>

<style scoped>
label,button{
  font-size: 1.5rem;
  font-weight: bold;
}

input{
  margin-bottom: 10px;
  width: 100%;
}

button{
  background-color: orange;
  color:black;
  padding: 5px 10px;
  cursor:pointer;
}

.add_btn{
  background-color: cornflowerblue;
  color: white;
  border: none;
  border-radius: 16px;
}

.show_addedData{
  background-color: khaki;
  color: red;
  font-weight: bold;
  padding-bottom: 10px;
}

.show_addedData p{
  margin-bottom: 6px;
}
</style>
