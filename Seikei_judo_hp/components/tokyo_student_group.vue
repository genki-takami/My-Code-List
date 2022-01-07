<template>
  <div class="main">
    <div class="intro_head">
      <h2><span class="accept_space"></span>東京学生柔道優勝大会(団体)</h2>
    </div>
    <div class="match_lists">
      <!-- クラウドデータ -->
      <div v-for="match in matchesList" :key="match.idNumber.doubleValue">
        <div class="match_list">
          <div v-for="unit in match.main.arrayValue.values.length" :key="unit">
            <h2>
              <i>
                {{ match.main.arrayValue.values[unit - 1].mapValue.fields.year.stringValue }}
                <span class="accept_space"></span>
                <span class="accept_space"></span>
                {{ match.main.arrayValue.values[unit - 1].mapValue.fields.title.stringValue }}
              </i>
            </h2>
            <p>
              <span :class='[match.main.arrayValue.values[unit - 1].mapValue.fields.result.stringValue === "成蹊大学" ? "winner" : "loser_normal"]'>成蹊大学</span>
              <span class="score">{{ match.main.arrayValue.values[unit - 1].mapValue.fields.myscore.stringValue }}</span>
              <span class="accept_space"></span>
              <span class="line">ー</span>
              <span class="accept_space"></span>
              <span class="score">{{ match.main.arrayValue.values[unit - 1].mapValue.fields.theirscore.stringValue }}</span>
              <span :class='[match.main.arrayValue.values[unit - 1].mapValue.fields.result.stringValue === match.main.arrayValue.values[unit - 1].mapValue.fields.university.stringValue ? "winner" : "loser_normal"]'>{{ match.main.arrayValue.values[unit - 1].mapValue.fields.university.stringValue }}</span>
            </p>
          </div>
        </div>
      </div>
      <!-- 過去のデータ(2008〜2018) -->
      <div class="match_list">
        <h2><i>2018年  1回戦</i></h2>
        <p>成蹊大学<span class="score">1</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">6</span><span class="winner">立教大学</span></p>
      </div>
      <div class="match_list">
        <h2><i>2016年  1回戦</i></h2>
        <p>成蹊大学<span class="score">3</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">4</span><span class="winner">東京大学</span></p>
      </div>
      <div class="match_list">
        <h2><i>2015年  1回戦</i></h2>
        <p>成蹊大学<span class="score">2</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">4</span><span class="winner">東京経済大学</span></p>
      </div>
      <div class="match_list">
        <h2><i>2014年  1回戦</i></h2>
        <p>成蹊大学<span class="score">1</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">6</span><span class="winner">桜美林大学</span></p>
      </div>
      <div class="match_list">
        <h2><i>2014年  1回戦女子</i></h2>
        <p>成蹊大学<span class="score">1</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">2</span><span class="winner">東京有明医療大</span></p>
      </div>
      <div class="match_list">
        <h2><i>2013年  1回戦</i></h2>
        <p>成蹊大学<span class="score">0</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">7</span><span class="winner">國學院大学</span></p>
      </div>
      <div class="match_list">
        <h2><i>2013年  1回戦女子</i></h2>
        <p>成蹊大学<span class="score">0</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">3</span><span class="winner">東京学芸大学</span></p>
        <p>成蹊大学<span class="score">1</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">2</span><span class="winner">日本文化大学</span></p>
      </div>
      <div class="match_list">
        <h2><i>2012年  1回戦</i></h2>
        <p><span class="winner">成蹊大学</span><span class="score">3</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">3</span>武蔵大学</p>
        <h2><i>2回戦</i></h2>
        <p>成蹊大学<span class="score">0</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">7</span><span class="winner">順天堂大学</span></p>
        <h2><i>敗者復活戦</i></h2>
        <p>成蹊大学<span class="score">0</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">7</span><span class="winner">明治学院大学</span></p>
      </div>
      <div class="match_list">
        <h2><i>2012年  1回戦 女子</i></h2>
        <p>成蹊大学<span class="score">1</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">2</span><span class="winner">駒澤大学</span></p>
      </div>
      <div class="match_list">
        <h2><i>2011年  1回戦</i></h2>
        <p>成蹊大学<span class="score">3</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">3</span><span class="winner">日本文化大学</span></p>
      </div>
      <div class="match_list">
        <h2><i>2011年  1回戦 女子</i></h2>
        <p>成蹊大学<span class="score">0</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">3</span><span class="winner">創価大学</span></p>
      </div>
      <div class="match_list">
        <h2><i>2010年  1回戦</i></h2>
        <p>成蹊大学<span class="score">0</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">7</span><span class="winner">拓殖大学</span></p>
      </div>
      <div class="match_list">
        <h2><i>2010年  1回戦女子</i></h2>
        <p>成蹊大学<span class="score">0</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">3</span><span class="winner">創価大学</span></p>
      </div>
      <div class="match_list">
        <h2><i>2009年  1回戦</i></h2>
        <p>成蹊大学<span class="score">0</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">7</span><span class="winner">國學院大学</span></p>
      </div>
      <div class="match_list">
        <h2><i>2009年  1回戦女子</i></h2>
        <p>成蹊大学<span class="score">1</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">2</span><span class="winner">東京大学</span></p>
      </div>
      <div class="match_list">
        <h2><i>2008年  1回戦</i></h2>
        <p><span class="winner">成蹊大学</span><span class="score">3</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">1</span>東京大学</p>
        <h2><i>2回戦</i></h2>
        <p>成蹊大学<span class="score">0</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">7</span><span class="winner">東京農業大学</span></p>
        <h2><i>敗者復活戦</i></h2>
        <p>成蹊大学<span class="score">0</span><span class="accept_space"></span><span class="line">ー</span><span class="accept_space"></span><span class="score">5</span><span class="winner">大正大学</span></p>
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
    axios.get('/tokyo-student-group')
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
