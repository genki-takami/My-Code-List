<template>
  <div class="main main_extra">
    <NEWS></NEWS>
    <ARTICLES></ARTICLES>
  </div>
</template>

<script>
  import NEWS from "./news.vue";
  import ARTICLES from "./articles.vue";
  export default{
    components:{
      NEWS,
      ARTICLES
    }
  };
</script>
