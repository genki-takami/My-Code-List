<template>
  <div class="main">
    <div class="intro_head">
      <h2><span class="accept_space"></span>杉並区民体育祭柔道の部</h2>
    </div>
    <div class="match_lists">
      <div v-for="match in matchesList" :key="match.idNumber.doubleValue">
        <div class="match_list_2">
          <h2 class="match_year">
            <i>
              {{ match.year.stringValue }}
            </i>
          </h2>
          <div v-for="n in match.names.arrayValue.values.length" :key="n">
            <h2 class="match_content">
              {{ match.statuses.arrayValue.values[n-1].stringValue }}
              <span class="accept_space"></span>
              {{ match.names.arrayValue.values[n-1].stringValue }}
              <span class="accept_space"></span>
              {{ match.numbers.arrayValue.values[n-1].stringValue }}
              <span class="accept_space"></span>
              <span :class='[match.results.arrayValue.values[n-1].stringValue === "勝" ? "winner" : "loser"]'>
                {{ match.results.arrayValue.values[n-1].stringValue }}
              </span>
              <span class="accept_space"></span>
              {{ match.whos.arrayValue.values[n-1].stringValue }}
              <br>
            </h2>
          </div>
        </div>
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
    axios.get('/suginami')
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
