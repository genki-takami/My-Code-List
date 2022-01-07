<template>
  <div class="main">
    <div class="intro_head">
      <h2><span class="accept_space"></span>東京学生柔道オープン大会</h2>
    </div>
    <div class="match_lists">
      <!-- クラウドデータ -->
      <div v-for="match in matchesList" :key="match.idNumber.doubleValue">
        <div class="match_list_2">
          <h2 class="match_year">
            <i>
              {{ match.year.stringValue }}
            </i>
          </h2>
          <div v-for="n in match.names.arrayValue.values.length" :key="n">
            <h2 class="match_content">
              {{ match.weightclasses.arrayValue.values[n-1].stringValue }}
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
      <!-- 過去データ(2008〜2018) -->
      <div class="match_list_2">
        <h2 class="match_year"><i>2018年</i></h2>
        <h2 class="match_content">無段の部<span class="accept_space"></span> 村上<span class="accept_space"></span> 優勝<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 国士舘大学鶴川(生田)、東京大学(不戦勝)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2015年</i></h2>
        <h2 class="match_content">52kg級<span class="accept_space"></span> 諸橋<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 日本体育大学(塚越)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 菊地<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 日本大学(岩上)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 菊地<span class="accept_space"></span> 2回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 立正大学(金子)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 菊地<span class="accept_space"></span> 3回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 中央大学(横尾)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 原<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東洋大学(久米)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2014年</i></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 原<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 国士舘大学(藤城)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 谷<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 日本大学(桑田)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 谷<span class="accept_space"></span> 2回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 早稲田大学(伊藤)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2013年</i></h2>
        <h2 class="match_content">無段<span class="accept_space"></span> 原<span class="accept_space"></span> 1回戦<span class="accept_space"></span><span class="loser">負</span><span class="accept_space"></span> 明星大学(鵜飼)<br></h2>
        <h2 class="match_content">52kg級<span class="accept_space"></span> 橋本<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 国士舘大学(篠)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2011年</i></h2>
        <h2 class="match_content">63kg級<span class="accept_space"></span> 新井<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 帝京大学(乾)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2010年</i></h2>
        <h2 class="match_content">女子無段<span class="accept_space"></span> 橋本<span class="accept_space"></span> 準優勝<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> データなし<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 藤井<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 日本大学(鵜飼)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2009年</i></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 藤井<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 早稲田大学(太田)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 土師<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 明星大学(五十嵐)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 土師<span class="accept_space"></span> 2回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 早稲田大学(中田)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 藤沖<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 立正大学(寺林)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 藤沖<span class="accept_space"></span> 2回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 国士舘大学(菅野)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 秋元<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東海大学(柳沢)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 関山<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 早稲田大学(永野)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 関山<span class="accept_space"></span> 2回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東京都市大学(田中)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2008年</i></h2>
        <h2 class="match_content">63kg級<span class="accept_space"></span> 工藤<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東海大学(甲斐)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 土師<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 和光大学(荒井)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 藤沖<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 武蔵大学(浦田)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 藤井<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 日本大学(大森)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 関山<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 芝浦工業大学(杉山)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 関山<span class="accept_space"></span> 2回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 国士舘大学(金子)<br></h2>
        <h2 class="match_content">無段<span class="accept_space"></span> 杉元<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 立正大学(星野)<br></h2>
        <h2 class="match_content">無段<span class="accept_space"></span> 杉元<span class="accept_space"></span> 2回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 国士舘大学(林)<br></h2>
        <h2 class="match_content">無段<span class="accept_space"></span> 秋元<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 国士舘大学(長嶺)<br></h2>
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
    axios.get('/tokyo-open')
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
