<template>
  <div class="content_wall">
    <div class="wrapper clearfix">
      <div class="main">
        <div class="intro_head">
            <h2>カレンダー</h2>
        </div>
        <div class="month_photo_2">
            <a :href="url1" target="_blank"><img src="https://3.bp.blogspot.com/-qiEFidRnPMk/U8XkvNrFT9I/AAAAAAAAi3I/57gfMd3GrFQ/s300/tsuki_title01.png" width="170"></a>
            <a :href="url2" target="_blank"><img src="https://1.bp.blogspot.com/-dTmHITKHw6s/U8XkvSYml8I/AAAAAAAAi3Q/kM0rjYAHiUw/s300/tsuki_title02.png" width="170"></a>
            <a :href="url3" target="_blank"><img src="https://4.bp.blogspot.com/-WsMGh5LpZN0/U8XkvkNQZqI/AAAAAAAAi3U/Eg9DY3Az4_s/s300/tsuki_title03.png" width="170"></a>
            <a :href="url4" target="_blank"><img src="https://1.bp.blogspot.com/-u6QSJJIQCZM/U8XkwJvPXmI/AAAAAAAAi3c/-g1D77EKGKc/s300/tsuki_title04.png" width="170"></a>
            <a :href="url5" target="_blank"><img src="https://2.bp.blogspot.com/-2A4dDGGKkIk/U8XkwTo5kkI/AAAAAAAAi3k/zjV3nf9O8zE/s300/tsuki_title05.png" width="170"></a>
            <a :href="url6" target="_blank"><img src="https://3.bp.blogspot.com/-v_RtDt-S6g8/U8XkwpSQiSI/AAAAAAAAi3s/ZI9rb1F2DgY/s300/tsuki_title06.png" width="170"></a>
            <a :href="url7" target="_blank"><img src="https://1.bp.blogspot.com/-dmF08LX4j_g/U8XkxIG_DZI/AAAAAAAAi3w/f5BgsGBSuJ0/s300/tsuki_title07.png" width="170"></a>
            <a :href="url8" target="_blank"><img src="https://2.bp.blogspot.com/-SL05y-_psJc/U8XkxXNcciI/AAAAAAAAi34/_edJyZzihdM/s300/tsuki_title08.png" width="170"></a>
            <a :href="url9" target="_blank"><img src="https://4.bp.blogspot.com/-I0wQNl0kuNw/U8XkxvipODI/AAAAAAAAi4I/BnRcPjSKA1w/s300/tsuki_title09.png" width="170"></a>
            <a :href="url10" target="_blank"><img src="https://2.bp.blogspot.com/-bsU7PQpPjEU/U8Xkx10jejI/AAAAAAAAi4E/BAfM-wOxnIg/s300/tsuki_title10.png" width="170"></a>
            <a :href="url11" target="_blank"><img src="https://2.bp.blogspot.com/-tDSpOOsm4Eo/U8XkyBchALI/AAAAAAAAi4M/YiawtwsFzfM/s300/tsuki_title11.png" width="170"></a>
            <a :href="url12" target="_blank"><img src="https://1.bp.blogspot.com/-8PFUVpeNfMI/U8Xky953b9I/AAAAAAAAi4Y/IebnDQBC5ck/s300/tsuki_title12.png" width="170"></a>
        </div>
        <div class="intro_head">
          <h2>スケジュール</h2>
        </div>
        <light-timeline :items='items'></light-timeline>
      </div>
      <SIDEMENU></SIDEMENU>
    </div>
  </div>
</template>

<script>
import SIDEMENU from "./sidemenu.vue";
import axios from 'axios';
export default {
  components:{
    SIDEMENU
  },
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
      idList:[],
      items: []
    };
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
          });
    axios.get('/schedules')
          .then(response => {
            let data = response.data;
            if (Object.keys(data).length !== 0) {
              this.idList = data.documents[1].fields.list.arrayValue.values;
              for (var i = 0; i < this.idList.length; i++) {
                let str = this.idList[i].stringValue;
                this.makeItems(data.documents[0].fields[str].mapValue.fields);
              }
            }
          });
  },
  methods:{
    makeItems(arg){
      let makedObject = {
        tag: arg.state.stringValue,
        htmlMode: true,
        content: `<a href="${arg.url.stringValue}" target="_blank" style="color:black;">${arg.date.stringValue} ${arg.dayofweek.stringValue}<br>${arg.title.stringValue}</a>`
      };
      this.items.push(makedObject);
    }
  }
};
</script>

<style scoped>
h2{
  margin-left: 20px;
}

.month_photo_2{
  text-align: center;
}
</style>
