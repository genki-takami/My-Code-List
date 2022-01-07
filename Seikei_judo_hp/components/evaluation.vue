<template>
  <div class="content_wall">
    <div class="wrapper clearfix">
      <router-view></router-view>
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
