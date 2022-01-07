<template>
  <div id="post_articles">
    <h1 style="margin:0;text-align: center;">アーティクルの追加</h1>
    <label>タイトル</label><span v-if="loadErr" style="color:red;font-size: 2.4rem;font-weight: bold;margin-left:13px;">エラーが発生しました。画面をリロードしてください。</span><br>
    <input type="text" v-model="title" placeholder="短く簡潔なタイトル"><br>
    <label>内容</label><br>
    <textarea v-model="text" placeholder="簡潔で詳細な内容"></textarea><br>
    <label>リンク先のURL</label><br>
    <input type="text" v-model="url" placeholder="https://〇〇〇.〇〇〇/"><br>
    <label>画像のURL</label><br>
    <input type="text" v-model="imageurl" placeholder="https://〇〇〇.〇〇〇/"><br>
    <button @click="update">UPDATE</button>
    <span v-if="submit" style="color:green;font-size: 2.4rem;font-weight: bold;margin-left:13px;">送信成功！</span>
    <span v-if="load" style="color:blue;font-size: 2.4rem;font-weight: bold;margin-left:13px;">送信中...</span>
    <span v-if="err" style="color:red;font-size: 2.4rem;font-weight: bold;margin-left:13px;">送信エラー</span>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  data() {
    return {
      title:'',
      text:'',
      url:'',
      imageurl:'',
      loadErr:false,
      submit:false,
      load:false,
      err:false,
      idNumber:0,
      updatedStamp:'',
      articleLength:0,
      quotient:0,
      remainder:0,
      deleteList:[],
      taskCounter:0
    };
  },
  computed: {
    idToken() {
      return this.$store.getters.idToken;
    }
  },
  created() {
    // ARTICLEの数を参照する
    axios.get('/articles-config/article-info')
          .then(response => {
            // データの参照に成功
            this.articleLength = parseInt(response.data.fields.length.doubleValue);
            this.idNumber = parseFloat(this.articleLength) + 1.1;
            // ARTICLEの数が１０以上であれば削除する可能性があるデータを特定する
            if (this.articleLength >= 10) {
              this.quotient = parseInt(Math.ceil(this.articleLength / 10)); // 既存のページ数
              this.remainder = parseInt(this.articleLength % 10);           // 最終ページのARTICLEの数
              const pageArray = [...Array(this.quotient).keys()].map(i => ++i);

              // 削除する可能性があるデータを特定する関数を定義
              const getDeleteList = async (pages) => {
                for (var page of pages) {
                  await axios.get('/articles/article-index/page' + page)
                              .then(response => {
                                // データの参照に成功
                                var dataList = response.data.documents;
                                // データを降順に並び替え
                                dataList.sort(function(a,b){
                                  if(a.fields.idNumber.doubleValue > b.fields.idNumber.doubleValue) return -1;
                                  if(a.fields.idNumber.doubleValue < b.fields.idNumber.doubleValue) return 1;
                                  return 0;
                                });
                                // 削除する可能性のあるデータをdeleteListに格納していく
                                if (page == 1) {
                                  this.deleteList[page - 1] = dataList[9];
                                }else if (page >= 2) {
                                  if (page < this.quotient) {
                                    // ページが「２」以上で既存のページ数未満の場合
                                    this.deleteList[page - 1] = dataList[9];
                                  }else if (page == this.quotient) {
                                    // ページが「２」以上で既存のページ数に達した場合
                                    if (this.remainder == 0) {
                                      // 最終ページのARTICLEの数が「１０」の場合
                                      this.deleteList[page - 1] = dataList[9];
                                    }
                                  }
                                }
                              }).catch(error => {
                                if (error) {
                                  this.loadErr = true;
                                }
                              });
                }
              };
              // ページの配列をパラメータに関数を実行
              getDeleteList(pageArray);
            }
          }).catch(error => {
            if (error) {
              this.loadErr = true;
            }
          });
  },
  methods: {
    update() {
      this.load = true;

      axios.post(
        '/articles/article-index/page1',
        {
          fields: {
            title:{
              stringValue:this.title
            },
            text:{
              stringValue:this.text
            },
            url:{
              stringValue:this.url
            },
            imageurl:{
              stringValue:this.imageurl
            },
            idNumber:{
              doubleValue:this.idNumber
            }
          }
        },{headers: {Authorization: `Bearer ${this.idToken}`}}
      ).then(response => {
        if (response) {
          // 新しいARTICLEの送信に成功
          this.articleLength = parseFloat(this.articleLength + 1);
          axios.patch(
            '/articles-config/article-info?updateMask.fieldPaths=length',
            {
              fields:{
                length:{
                  doubleValue:this.articleLength
                }
              }
            },{headers: {Authorization: `Bearer ${this.idToken}`}}
          ).then(response => {
            if (response) {
              // ARTICLEの数の更新に成功
              if (this.deleteList.length >= 1) {
                // 削除したデータを次のページコレクションに追加する
                const movedArticleArray = [...Array(this.deleteList.length).keys()].map(i => i + 2);

                const postMoveArticle = async (posts) => {
                  for (var post of posts) {
                    let z1 = post - 2;
                    await axios.post(
                            '/articles/article-index/page' + post,
                            {
                              fields: {
                                title:{
                                  stringValue:this.deleteList[z1].fields.title.stringValue
                                },
                                text:{
                                  stringValue:this.deleteList[z1].fields.text.stringValue
                                },
                                url:{
                                  stringValue:this.deleteList[z1].fields.url.stringValue
                                },
                                imageurl:{
                                  stringValue:this.deleteList[z1].fields.imageurl.stringValue
                                },
                                idNumber:{
                                  doubleValue:this.deleteList[z1].fields.idNumber.doubleValue
                                }
                              }
                            },{headers: {Authorization: `Bearer ${this.idToken}`}}
                    ).then(response => {
                      if (response) {
                        // ページデータの移動成功
                        this.taskCounter += 1;// タスクカウンターをインクリメント
                        if (this.taskCounter == posts.length) {
                          // 全てのタスクが完了
                          // もとあったページコレクションから削除
                          this.deleteList.forEach((item) => {
                            axios.delete('https://firestore.googleapis.com/v1/' + item.name,{headers: {Authorization: `Bearer ${this.idToken}`}});
                          });
                          // 更新日の更新
                          const date = new Date();
                          this.updatedStamp = date.getFullYear() + "/" + (date.getMonth() + 1) + "/" + date.getDate();
                          axios.patch(
                            '/updated-date/updatedStamp?updateMask.fieldPaths=updatedStamp',
                            {
                              fields:{
                                updatedStamp:{
                                  stringValue:this.updatedStamp
                                }
                              }
                            },{headers: {Authorization: `Bearer ${this.idToken}`}}
                          ).then(response => {
                            if (response) {
                              // 更新日の更新に成功
                              this.load = false;
                              this.err = false;
                              this.title = '';
                              this.text = '';
                              this.url = '';
                              this.imageurl = '';
                              this.idNumber = 0;
                              this.submit = true;
                              this.articleLength = 0;
                              this.quotient = 0;
                              this.remainder = 0;
                              this.updatedStamp = '';
                            }
                          }).catch(error => {
                            if (error) {
                              // 更新日の更新に失敗
                              this.load = false;
                              this.err = true;
                            }
                          });
                        }
                      }
                    }).catch(error => {
                      if (error) {
                        // 既存データのページ移動に失敗
                        this.load = false;
                        this.err = true;
                      }
                    });
                  }
                };
                // データの移動先ページの配列をパラメータに関数を実行
                postMoveArticle(movedArticleArray);
              }
            }
          }).catch(error => {
            if (error) {
              // ARTICLEの数の更新に失敗
              this.load = false;
              this.err = true;
            }
          });
        }
      }).catch(error => {
        if (error) {
          // 新しいARTICLEの送信に失敗
          this.load = false;
          this.err = true;
        }
      });
    }
  }
};
</script>

<style scoped>
label,button{
  font-size: 1.5rem;
  font-weight: bold;
}

input{
  margin-bottom: 10px;
}

textarea,input{
  width: 100%;
}

textarea{
  height: 100px;
}

button{
  background-color: orange;
  color:black;
  padding: 5px 10px;
  cursor:pointer;
}
</style>
