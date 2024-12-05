import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { foreign: Boolean }

  static targets = [ "bin", "number" ]

  foreignValueChanged() {
    this.binTarget.disabled = this.foreignValue
    this.numberTarget.disabled = !this.foreignValue
  }

  toggle(event) {
    this.foreignValue = event.target.checked
  }
}
