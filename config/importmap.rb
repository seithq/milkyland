# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@rails/request.js", to: "rails-requestjs.js"
pin "el-transition" # @0.0.7
pin "@github/hotkey", to: "@github--hotkey.js" # @3.1.1

pin_all_from "app/javascript/controllers", under: "controllers"
