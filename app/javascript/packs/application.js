// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")
require('jquery') //追記

import '@fortawesome/fontawesome-free/js/all';

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
import { deleteTr } from '../lib/task'
deleteTr();





// $(document).ready(function(){
// // PAY.JPの公開鍵をセットします。
// Payjp.setPublicKey('sk_test_581f9e453c903f8476caf973');

// //formのsubmitを止めるために, クレジットカード登録のformを定義します。
// var form = $(".form");

// form.submit(function() {
//   // submitが完了する前に、formを止めます。
//   // form.find("input[type=submit]").prop("disabled", true);
//   // submitを止められたので、PAY.JPの登録に必要な処理をします。

//   // formで入力された、カード情報を取得します。
//   var card = {
//     number: $("#card_number").val(),
//     cvc: $("#card_cvc").val(),
//     exp_month: $("#card_month").val(),
//     exp_year: $("#card_year").val(),
//   };
//   // PAYJPに登録するためのトークン作成
//   let retVal = true;
//   Payjp.createToken(card, function(status, response) {
//     if (response.error){
//       // エラーがある場合処理しない。
//       alert(JSON.stringify(response.error))
//       form.find('#error_explanation').text(response.error.message);
//       form.find('.btn-primary').prop('disabled', false);
//       retVal = false;
//     } else {
//       alert('no error')
//       // エラーなく問題なく進めた場合
//       // formで取得したカード情報を削除して、Appにカード情報を残さない。
//       $("#card_number").removeAttr("name");
//       $("#card_cvc").removeAttr("name");
//       $("#card_month").removeAttr("name");
//       $("#card_year").removeAttr("name");
//       var token = response.id;
      
//       alert(token)

//       form.append($('<input type="hidden" name="payjp-token" />').val(token));
//       form.get(0).submit();
//     };
//   });
//   return retVal;
// });
// });