<template>
  <div class="main">
    <div class="intro_head">
      <h2>大会成績</h2>
    </div>
    <div class="evaluation_rect ">
      <router-link to="/evaluation/tokyo_student_group" class="evaluation_link">
        <div class="evaluation_image_mask">
          <img src="https://drive.google.com/uc?export=view&id=1g9fZ3kBJJb6n6z-FyEGS3kQbNB9daNIo">
          <p>東京学生柔道優勝大会</p>
        </div>
      </router-link>
    </div>
    <div class="evaluation_rect ">
      <router-link to="/evaluation/four_fresh" class="evaluation_link">
        <div class="evaluation_image_mask">
          <img src="https://drive.google.com/uc?export=view&id=1kU5TlzhY-cGfiuV9DtabfatJigr0Amyb">
          <p>東京四大学新人戦</p>
        </div>
      </router-link>
    </div>
    <div class="evaluation_rect ">
      <router-link to="/evaluation/tokyo_student_personal" class="evaluation_link">
        <div class="evaluation_image_mask">
          <img src="https://drive.google.com/uc?export=view&id=1rleDM481oS_UnPY8D9mq9wlupiAVurDO">
          <p>東京学生柔道体重別選手権大会</p>
        </div>
      </router-link>
    </div>
    <div class="evaluation_rect ">
      <router-link to="/evaluation/four_main" class="evaluation_link">
        <div class="evaluation_image_mask">
          <img src="https://drive.google.com/uc?export=view&id=1PMLKZ7qh2qQAJVjBZ2gINACAyLvtAT9a">
          <p>東京四大学本戦</p>
        </div>
      </router-link>
    </div>
    <div class="evaluation_rect ">
      <router-link to="/evaluation/suginami" class="evaluation_link">
        <div class="evaluation_image_mask">
          <img src="https://drive.google.com/uc?export=view&id=17WadmzUztHbYRsaYAWjeUeTYYrazkr7x">
          <p>杉並区民体育祭柔道の部</p>
        </div>
      </router-link>
    </div>
    <div class="evaluation_rect ">
      <router-link to="/evaluation/tokyo_second" class="evaluation_link">
        <div class="evaluation_image_mask">
          <img src="https://drive.google.com/uc?export=view&id=157q0a-CC9wrn9TB3qkl9yEOQkJLnaMXL">
          <p>東京学生柔道二部優勝大会</p>
        </div>
      </router-link>
    </div>
    <div class="evaluation_rect ">
      <router-link to="/evaluation/tokyo_open" class="evaluation_link">
        <div class="evaluation_image_mask">
          <img src="https://drive.google.com/uc?export=view&id=1KSLzRC_ahXq9UHTEgRwAnJPjwkgjraOG">
          <p>東京学生柔道オープン大会</p>
        </div>
      </router-link>
    </div>
    <div class="evaluation_rect ">
      <router-link to="/evaluation/rikou_match" class="evaluation_link">
        <div class="evaluation_image_mask">
          <img src="https://drive.google.com/uc?export=view&id=15tLdwTMA0Vd6ojqzfoG72wb7FKGY9Ikx">
          <p>全日本理工科学生柔道優勝大会</p>
        </div>
      </router-link>
    </div>
  </div>
</template>

<style scoped>
h2{
  margin-left: 20px;
}

.evaluation_rect{
  overflow: hidden;
  background-color:#EEEEEE;
  border-top-left-radius: 45px;
  margin-bottom:35px;
  position: relative;
}

.evaluation_link{
  display: inline-block;
}

.evaluation_image_mask{
  height: 200px;
  width:800px;
  position:relative;
  background-color: #EEEEEE;/*evaluation_rectと同じ色*/
  top:-60px;
  left:-50px;
}

.evaluation_image_mask img{
  height: 200px;
  width:100%;
  transform: rotate(-10deg);/*親要素を斜めにする*/
  display: block;
  opacity: 1;/* 元々は0 */
  position: relative;
  transition:all .5s .3s ease;
  z-index: 0;
}

.evaluation_rect:before{
    background: #333;
    content: '';
    display: block;
    height: 100%;
    position: absolute;
    transform: translateX(-100%);
    transition:all .8s 0s ease;
    width: 100%;
    z-index: 1;
}

/*アニメーションするプロパティを設定します*/
.evaluation_rect.active img{
    opacity: 1;
}

.evaluation_rect.active:before{
    transform: translateX(100%);
}

.evaluation_image_mask p{
  margin: 0;
  color:red;
  text-align: center;
  position: absolute;
  bottom:-65px;
  right:100px;
  font-size: 37px;
  font-family:serif;
  font-weight: bold;
  border-bottom: solid 2px black;
}

@media  (min-width: 500px) and (max-width:1000px){
.evaluation_image_mask p{
  right: -3px;
}
}

@media (min-width: 500px) and (max-width:601px){
.evaluation_image_mask p{
  right: 167px;
}
}

@media (max-width:499px) {
.evaluation_rect{
  margin-bottom: 0;
  border-top-left-radius:0;
}

.evaluation_image_mask{
  width:150%;
}

.evaluation_image_mask p{
  font-size: 23px;
  right: 160px;
  bottom:-42px;
  transform: rotate(-10deg);
  border-bottom:none;
}
}
</style>
