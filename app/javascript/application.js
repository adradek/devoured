import "./native_confirm"
import Rails from "@rails/ujs"
Rails.start()

Rails.confirm = function(message, element) {
  return window.__nativeConfirm(message)
}

import "@hotwired/turbo-rails"
import "./controllers"

import "bootstrap"
import "./jquery-global"
// import "./packs/modals"
// import "./packs/compilation_collapse"
