<template>
  <div class="main">
    <div class="intro_head">
      <h2><span class="accept_space"></span>東京学生柔道体重別選手権大会</h2>
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
        <h2 class="match_content">66kg級<span class="accept_space"></span> 逸見<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 法政大学(石澤)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 岩田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東海大学(松永)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 新福<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東洋大学(丸)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 新井<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 日本大学(奥田)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 山藤<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 早稲田大学(間瀬)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 櫻井<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 日本文化大学(野間)<br></h2>
        <h2 class="match_content">90kg級<span class="accept_space"></span> 新福<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 帝京科学大学(伊藤)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2017年</i></h2>
        <h2 class="match_content">60kg級<span class="accept_space"></span> 新井<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 法政大学(原田)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 岩田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 大東文化大学(竹村)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 辻<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 日本体育大学(古賀)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 玉川<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 帝京科学大学(阿部)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 櫻井<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 明治大学(山本)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 松田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 専修大学(宮本)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2016年</i></h2>
        <h2 class="match_content">60kg級<span class="accept_space"></span> 菊池<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 中央大学(平沼)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 玉川<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東京理科大学(杉原)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 岩田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 拓殖大学(林)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 岩田<span class="accept_space"></span> 2回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 國學院大學(中川)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 新井<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 駒澤大学(鈴木)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 辻<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 東京経済大学(石渡)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 辻<span class="accept_space"></span> 2回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 創価大学(佐藤)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 櫻井<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 早稲田大学(浅賀)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 松田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 日本大学(伊佐々木)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2015年</i></h2>
        <h2 class="match_content">60kg級<span class="accept_space"></span> 神本<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 國學院大学(久家)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 新井<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 帝京科学大学(小野)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 岩田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 成城大学(平山)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 岩田<span class="accept_space"></span> 2回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 東京学芸大学(加藤)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 岩田<span class="accept_space"></span> 3回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東洋大学(高田)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 玉川<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 駒澤大学(森戸)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 辻<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 日本大学(福岡)<br></h2>
        <h2 class="match_content">90kg級<span class="accept_space"></span> 松田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 國學院大学(田村)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2014年</i></h2>
        <h2 class="match_content">57kg級<span class="accept_space"></span> 新井<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 早稲田大学(市場)<br></h2>
        <h2 class="match_content">60kg級<span class="accept_space"></span> 菊池<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 国士舘大学(林)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2013年</i></h2>
        <h2 class="match_content">48kg級<span class="accept_space"></span> 小谷野<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 創価大学(登藤)<br></h2>
        <h2 class="match_content">52kg級<span class="accept_space"></span> 諸橋<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東京女子大学(易)<br></h2>
        <h2 class="match_content">57kg級<span class="accept_space"></span> 新井<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 国士舘大学(柳楽)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 神本<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 武蔵大学(西村)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 神本<span class="accept_space"></span> 2回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 帝京科学大学(大木)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 林<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東京経済大学(高水)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2012年</i></h2>
        <h2 class="match_content">48kg級<span class="accept_space"></span> 橋本<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 慶応義塾大学(富岡)<br></h2>
        <h2 class="match_content">48kg級<span class="accept_space"></span> 小谷野<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 二松学舎大学(阿部)<br></h2>
        <h2 class="match_content">48kg級<span class="accept_space"></span> 小谷野<span class="accept_space"></span> 2回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 日本体育大学(腰)<br></h2>
        <h2 class="match_content">57kg級<span class="accept_space"></span> 新井<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 帝京科学大学(大森)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 福井<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 大正大学(三間)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 林<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東海大学(橋下)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 疋田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 國學院大学(井上)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 片山<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東京経済大学(飯田)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 和田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 青山学院大学(三井)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2011年</i></h2>
        <h2 class="match_content">48kg級<span class="accept_space"></span> 小谷野<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 国士舘大学(寺島)<br></h2>
        <h2 class="match_content">48kg級<span class="accept_space"></span> 橋本<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東海大学(浅香)<br></h2>
        <h2 class="match_content">63kg級<span class="accept_space"></span> 野口<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 帝京大学(若林)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 林<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 明治学院大学(麻生)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 齋藤<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 学習院大学(？？)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 疋田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 早稲田大学(星野)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 和田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 國學院大学(大畑)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 佐藤<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 中央大学(千田)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 山田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 玉川大学(齋藤)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 中村<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 駒澤大学(三原)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2010年</i></h2>
        <h2 class="match_content">52kg級<span class="accept_space"></span> 小谷野<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 日本体育大学(松本)<br></h2>
        <h2 class="match_content">63kg級<span class="accept_space"></span> 野口<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 日本体育大学(中野)<br></h2>
        <h2 class="match_content">60kg級<span class="accept_space"></span> 土師<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 駒澤大学(堀田)<br></h2>
        <h2 class="match_content">60kg級<span class="accept_space"></span> 渓<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東海大学(漆畑)<br></h2>
        <h2 class="match_content">60kg級<span class="accept_space"></span> 山田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 立正大学(飯野)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 山田<span class="accept_space"></span> 2回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東京農業大学(金子)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 佐藤<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 中央大学(渡邉)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 中村<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 専修大学(木次)<br></h2>
        <h2 class="match_content">90kg級<span class="accept_space"></span> 関山<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東京大学(寺田)<br></h2>
        <h2 class="match_content">90kg級<span class="accept_space"></span> 鈴木<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 明治大学(高橋)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2009年</i></h2>
        <h2 class="match_content">60kg級<span class="accept_space"></span> 渓<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東洋大学(森)<br></h2>
        <h2 class="match_content">63kg級<span class="accept_space"></span> 野口<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 日本大学(高橋)<br></h2>
        <h2 class="match_content">63kg級<span class="accept_space"></span> 工藤<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 帝京大学(和田)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 疋田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 専修大学(田邊)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 山田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 国士舘大学(土屋)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 下村<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 順天堂大学(後藤)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 中村<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 帝京短期大学(野杁)<br></h2>
        <h2 class="match_content">81kg級<span class="accept_space"></span> 中村<span class="accept_space"></span> 2回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 亜細亜大学(武田)<br></h2>
        <h2 class="match_content">90kg級<span class="accept_space"></span> 川島<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 日本大学(池田)<br></h2>
      </div>
      <div class="match_list_2">
        <h2 class="match_year"><i>2008年</i></h2>
        <h2 class="match_content">60kg級<span class="accept_space"></span> 丹野<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東洋大学(塚崎)<br></h2>
        <h2 class="match_content">60kg級<span class="accept_space"></span> 渓<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 桜美林大学(大和)<br></h2>
        <h2 class="match_content">66kg級<span class="accept_space"></span> 後藤<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 東海大学(松田)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 下村<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 順天堂大学(柴崎)<br></h2>
        <h2 class="match_content">73kg級<span class="accept_space"></span> 山田<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 明治大学(赤迫)<br></h2>
        <h2 class="match_content">90kg級<span class="accept_space"></span> 田辺<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="winner">勝</span><span class="accept_space"></span> 大正大学(阿部)<br></h2>
        <h2 class="match_content">90kg級<span class="accept_space"></span> 田辺<span class="accept_space"></span> 2回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 明治大学(田中)<br></h2>
        <h2 class="match_content">90kg級<span class="accept_space"></span> 川島<span class="accept_space"></span> 1回戦<span class="accept_space"></span> <span class="loser">負</span><span class="accept_space"></span> 國學院大学(樫下))<br></h2>
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
    axios.get('/tokyo-student-personal')
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
