import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { id: String, input: String }

  connect() {
    const table = document.getElementById(this.idValue)
    if (table) {
      const data = btoa(encodeURIComponent(table.outerHTML))

      const inputs = document.getElementsByName(this.inputValue)
      if (inputs) {
        inputs[0].value = data
      }
    }
  }
}
