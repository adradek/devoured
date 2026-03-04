import "./native_confirm"
import Rails from "@rails/ujs"
Rails.start()

Rails.confirm = function(message, element) {
  return window.__nativeConfirm(message)
}

// const originalHandleMethod = Rails.handleMethod

// console.log("oooops")

// Rails.handleMethod = function(e) {
//   console.log('handleMethod called', e.target)
//   const result = originalHandleMethod.call(this, e)
//   console.log('handleMethod result:', result)

//   // Проверим, создалась ли форма
//   const form = document.querySelector('form[data-ujs]')
//     || document.body.lastElementChild
//   console.log('last element in body:', form?.tagName, form?.action, form?.innerHTML)

//   return result
// }


import "bootstrap"
import "./jquery-global"

import "./modules/books"
// import "./packs/modals"
// import "./packs/compilation_collapse"
