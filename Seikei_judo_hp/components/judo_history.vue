<template>
  <div class="content_wall">
    <div class="wrapper clearfix">
      <div class="main">
        <div class="intro_head">
          <h2>柔道の歴史</h2>
        </div>
        <div class="intro_body">
          <p>
            <span class="accept_space"></span>
            柔道は1882年に、嘉納治五郎師範によって創設されました。古武術・柔術を由来とし、
            さらには教育的な手法としての発展をつづけた柔道は、1964年の東京オリンピックで初めて正式競技に採用されました。
            柔道は、心技体を鍛えることによって自分の意のままに自分や相手の体をコントロールすることを目的としたスポーツです。
            まさに日本の国技ともいうことができます。また、柔道の競技者数は世界規模で増え続けていて、
            現在では約200の国と地域で柔道は親しまれています。柔道の知名度は世界的にも抜群です。
          </p>
        </div>
        <img class="introduce_anime_image " src="https://drive.google.com/uc?export=view&id=1J9eox-xFD6vDc1zAQOyARfezSRhFsx5n" alt="嘉納治五郎">
        <div class="inline_right">
          <p>
            <span class="accept_space"></span>
            柔道の世界ではある二つの言葉が<br>有名です。それは「精力善用」と<br>「自他共栄」です。「精力善用」<br>
            とは、幼い頃からの母の教えや父の<br>行動哲学を通して受け継いだ「心<br>身の持つすべての力を最大限に生か<br>
            して、社会のために善い方向に用い<br>る」という精神の意味です。
          </p>
        </div>
        <div class="intro_body">
          <p class="intro_hidden ">
            <span class="accept_space"></span>
            柔道の世界ではある二つの言葉が有名です。それは「精力善用」と「自他共栄」です。「精力善用」とは、
            幼い頃からの母の教えや父の行動哲学を通して受け継いだ「心身の持つすべての力を最大限に生かして、
            社会のために善い方向に用いる」という精神の意味です。
          </p>
          <p>
            「自他共栄」とは、柔道の修行を通して体得した「相手に対し敬い、感謝することで信頼し合い、助け合う心を育み、
            自分だけでなく他人と共に栄えある世の中にしようとする」ということです。
            上記の二つは人として生きるうえで大切なことだとは思いませんか？これらは自分たちだけでなく、
            後世の人々に受け継いでいくべき素晴らしい価値観だと思います。
          </p>
          <p>
            <span class="accept_space"></span>
            柔道はあらゆる年齢層の人々に親しまれています。6歳から80歳を超す高齢者まで、年齢、性別、職業、
            そして国籍に関係なく大勢の人々が柔道に励んでいます。このなかには、強くなりたい一心の人、弱いからだを鍛えたい人、
            精神力を向上させたい人、快い汗を流したい人、自分を守る力を身につけたい人、柔道の指導者になりたい人、
            現に指導に熱中している人など様々な人がいます。柔道はこれほど様々な年代の、
            多種多様な目的を持った人たちを共通にひきつけているのです。
          </p>
          <p>
            <span class="accept_space"></span>
            嘉納師範は、一般に言いならわされていた柔術を柔道として単に技を修得するだけでなく、天下の大道を学ぶものとし、
            その教育場を「講道館」と呼んだのです。講道という語には、道を学び、明らかにし、実践するという意味があります。
            講道館柔道と名付けて柔道の本質を明らかにしているところに、嘉納師範が、いかに道を重んじ、
            その修行を一生の大事としていたかを知ることができます。また師範は、柔道修行の目的は、
            攻撃・防御の練習によって身体を鍛練して強健にし、精神の修養につとめて人格の完成をはかり、社会に貢献することであると示されています。
          </p>
        </div>
      </div>
      <SIDEMENU></SIDEMENU>
    </div>
  </div>
</template>

<script>
import SIDEMENU from "./sidemenu.vue";
export default {
  components:{
    SIDEMENU
  }
};
</script>

<style scoped>
h2{
  margin-left: 20px;
}

.intro_body{
  margin:0 40px;
  font-size:1.5rem;
}

.introduce_anime_image{
  width:450px;
  margin:0 90px;
  object-fit: cover;
  height:230px;
  border-radius:15px;
}

.inline_right{
  display: none;
}

.intro_hidden{
  display: block;
}

@media  (min-width: 500px) and (max-width:1000px){
.introduce_anime_image{
  margin-left: 160px;
}
}

@media (max-width:499px) {
.introduce_anime_image{
margin-left: 13px;
width:343px;
}
}
</style>
