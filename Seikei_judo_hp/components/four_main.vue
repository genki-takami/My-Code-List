<template>
  <div class="main">
    <div class="intro_head">
      <h2><span class="accept_space"></span>東京四大学本戦</h2>
    </div>
    <div class="match_lists">
      <!-- クラウドデータ -->
      <div v-for="match in matchesList" :key="match.idNumber.doubleValue">
        <div class="match_list">
          <h2><i>{{ match.year.stringValue }}</i></h2>
          <pre>
            1位<span class="accept_space"></span>{{ match.is1st.stringValue }}
            2位<span class="accept_space"></span>{{ match.is2nd.stringValue }}
            3位<span class="accept_space"></span>{{ match.is3rd.stringValue }}
            4位<span class="accept_space"></span>{{ match.worst.stringValue }}
          </pre>
        </div>
      </div>
      <!-- 過去データ(2008〜2018) -->
      <div class="match_list">
        <h2><i>2018年</i></h2>
        <pre>
          1位<span class="accept_space"></span>武蔵大学
          2位<span class="accept_space"></span>成城大学
          3位<span class="accept_space"></span>成蹊大学
          4位<span class="accept_space"></span>学習院大学
        </pre>
      </div>
      <div class="match_list">
        <h2><i>2017年</i></h2>
        <pre>
          1位<span class="accept_space"></span>武蔵大学
          2位<span class="accept_space"></span>成城大学
          3位<span class="accept_space"></span>成蹊大学
          4位<span class="accept_space"></span>学習院大学
        </pre>
      </div>
      <div class="match_list">
        <h2><i>2016年</i></h2>
        <pre>
          1位<span class="accept_space"></span>武蔵大学
          2位<span class="accept_space"></span>成蹊大学
          3位<span class="accept_space"></span>成城大学
          4位<span class="accept_space"></span>学習院大学
        </pre>
      </div>
      <div class="match_list">
        <h2><i>2015年</i></h2>
        <pre>
          1位<span class="accept_space"></span>武蔵大学
          2位<span class="accept_space"></span>学習院大学
          3位<span class="accept_space"></span>成蹊大学
          4位<span class="accept_space"></span>成城大学
        </pre>
      </div>
      <div class="match_list">
        <h2><i>2014年</i></h2>
        <pre>
          1位<span class="accept_space"></span>武蔵大学
          2位<span class="accept_space"></span>学習院大学
          3位<span class="accept_space"></span>成蹊大学
          4位<span class="accept_space"></span>成城大学
        </pre>
      </div>
      <div class="match_list">
        <h2><i>2013年</i></h2>
        <pre>
          1位<span class="accept_space"></span>学習院大学
          2位<span class="accept_space"></span>武蔵大学
          3位<span class="accept_space"></span>成城大学
          4位<span class="accept_space"></span>成蹊大学
        </pre>
      </div>
      <div class="match_list">
        <h2><i>2012年</i></h2>
        <pre>
          1位<span class="accept_space"></span>学習院大学
          2位<span class="accept_space"></span>武蔵大学
          3位<span class="accept_space"></span>成蹊大学
          4位<span class="accept_space"></span>成城大学
        </pre>
      </div>
      <div class="match_list">
        <h2><i>2011年</i></h2>
        <pre>
          1位<span class="accept_space"></span>成蹊大学
          2位<span class="accept_space"></span>学習院大学
          3位<span class="accept_space"></span>武蔵大学
          4位<span class="accept_space"></span>成城大学
        </pre>
      </div>
      <div class="match_list">
        <h2><i>2010年</i></h2>
        <pre>
          1位<span class="accept_space"></span>学習院大学
          2位<span class="accept_space"></span>武蔵大学
          3位<span class="accept_space"></span>成蹊大学
          4位<span class="accept_space"></span>成城大学
        </pre>
      </div>
      <div class="match_list">
        <h2><i>2009年</i></h2>
        <pre>
          1位<span class="accept_space"></span>学習院大学
          2位<span class="accept_space"></span>成蹊大学
          3位<span class="accept_space"></span>武蔵大学
          4位<span class="accept_space"></span>成城大学
        </pre>
      </div>
      <div class="match_list">
        <h2><i>2008年</i></h2>
        <pre>
          1位<span class="accept_space"></span>学習院大学
          2位<span class="accept_space"></span>武蔵大学
          3位<span class="accept_space"></span>成蹊大学
          4位<span class="accept_space"></span>成城大学
        </pre>
      </div>
    </div>
  </div>
</template>

<script>
  import axios from 'axios';
  export default{
    data() {
      return {
        matchesList:[],
        idList:[]
      };
    },
    created() {
      axios.get('/four-main')
            .then(response => {
              let data = response.data;
              if (Object.keys(data).length !== 0) {
                this.idList = data.documents[1].fields.list.arrayValue.values;
                for (var i = 0; i < this.idList.length; i++) {
                  let str = this.idList[i].stringValue;
                  this.matchesList.unshift(data.documents[0].fields[str].mapValue.fields);
                }
              }
            });
    }
  };
</script>
