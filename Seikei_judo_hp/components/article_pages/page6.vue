<template>
  <div class="clearfix">
    <div v-for="article in articlesList" :key="article.name">
      <div class="article_frame ">
        <div class="article_content">
          <div class="article_mask">
            <img :src="article.fields.imageurl.stringValue">
          </div>
          <h3>
            {{ article.fields.title.stringValue }}
          </h3>
          <p>
            {{ article.fields.text.stringValue }}
            <span class="accept_space"></span>
            <a :href="article.fields.url.stringValue" style="color:blue;">
              <i class="fas fa-external-link-alt"></i>
            </a>
          </p>
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
      articlesList:[]
    };
  },
  created() {
    axios.get('/articles/article-index/page6')
          .then(response => {
            this.articlesList = response.data.documents;
            // 降順に並び替え
            this.articlesList.sort(function(a,b){
              if(a.fields.idNumber.doubleValue > b.fields.idNumber.doubleValue) return -1;
              if(a.fields.idNumber.doubleValue < b.fields.idNumber.doubleValue) return 1;
              return 0;
            });
          });
  }
};
</script>
