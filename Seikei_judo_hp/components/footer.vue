<template>
  <div class="footer">
      <ul class="horizontal-list">
        <li class="horizontal-item"><a href="https://www.seikei.ac.jp/university/">成蹊大学</a></li>
        <li class="horizontal-item"><a href="https://www.seikei.ac.jp/jsh/">成蹊中学高等学校</a></li>
        <li class="horizontal-item"><a href="#">更新日：{{ updated }}</a></li>
      </ul>
      <p class="copyright">&copy;成蹊大学体育会柔道部 <i>All rights reserved</i></p>
  </div>
</template>

<script>
import axios from 'axios';
export default{
  data(){
    return{
      updated:''
    }
  },
  created(){
    axios.get('/updated-date/updatedStamp')
          .then(response => {
            this.updated = response.data.fields.updatedStamp.stringValue;
          });
  }
};
</script>

<style scoped>
.footer{
  width:100%;
  padding:20px 0 30px;
  background-color:#2d3d54;
  color:#fff;
  z-index:3;
  position: relative;
  font-size: 1.5rem;
}

.horizontal-list{
  width:970px;
  margin:0 auto;
  text-align: right;
}

.horizontal-list .horizontal-item{
  display: inline-block;
  letter-spacing:1px;
  padding:0 15px;
}

.horizontal-list .horizontal-item + .horizontal-item{
  border-left:1px solid #bbb;
}

.horizontal-list .horizontal-item a{
  color:#bbb;
  font-size:1.3rem;
  transition: color 0.15s;
}

.horizontal-list .horizontal-item a:hover{
  color:#ddd;
}

.copyright{
  margin-top:30px;
  text-align: center;
  letter-spacing:1px;
}

@media  (min-width: 500px) and (max-width:1000px){
.horizontal-list{
  width:100%;
  text-align:center;
}

.horizontal-list .horizontal-item{
  letter-spacing:3px;
}

.horizontal-list .horizontal-item + .horizontal-item{
  border-left:none;
}

.horizontal-list .horizontal-item a{
  color:white;
  font-size:1.5rem;
}

.copyright{
  font-size:1rem;
}
}

@media (max-width:499px) {
.horizontal-list{
  width:100%;
  text-align:center;
}

.horizontal-list .horizontal-item{
  letter-spacing:3px;
}

.horizontal-list .horizontal-item + .horizontal-item{
  border-left:none;
}

.horizontal-list .horizontal-item a{
  color:white;
  font-size:1.5rem;
}

.copyright{
  font-size:1.5rem;
}
}
</style>
