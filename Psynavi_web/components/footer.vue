<template>
  <div class="footer">
    <div class="footer_left">
      &copy;<i>Psyなび Studio. All rights reserved</i>
    </div>
    <div class="footer_left">
      <i><a href="https://forms.gle/N5oPqd3vBTxUc2JC8" target="_blank">お問い合わせ</a></i>
    </div>
    <div class="footer_right">
      <i>Managed and developed dy</i>
      <a href="https://genki-takami-portfolio.netlify.app/" class="footer_link" target="_blank"></a>
    </div>
  </div>
</template>

<script>
export default {
}
</script>

<style scoped>
.footer{
  height: 68px;
  width: 100%;
  z-index: 9;
  position: fixed;
  bottom: 0;
  line-height: 68px;
  background-color:#27282c;
  color: white;
  font-weight: bold;
}

.footer_left{
  float: left;
  margin-left: 30px;
}

.footer_left a{
  color:white;
}

.footer_left a:hover{
  color:skyblue;
}

.footer_right{
  float: right;
  margin-right: 30px;
}

.footer_link{
  vertical-align: middle;
  width: 68px;
  height: 68px;
  float: right;
  margin-left: 10px;
  background-image: url(https://drive.google.com/uc?export=view&id=1hO0H4-eyCEa8LWqJ-peuZk56AFOBC_Np);
}

@media (max-width:684px){
.footer_right{
  display:none;
}
}

@media (max-width:375px) {
.footer{
  line-height:34px;
}

.footer_left{
  padding-right:30px;
}
}
</style>
