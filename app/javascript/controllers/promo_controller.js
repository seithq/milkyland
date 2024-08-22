import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["start", "end"]

  static values = { unlimited: Boolean }

  unlimitedValueChanged() {
    if (this.unlimitedValue) {
      this.startTarget.disabled = true
      this.endTarget.disabled = true
    } else {
      this.startTarget.disabled = false
      this.endTarget.disabled = false
    }
  }

  toggle(event) {
    this.unlimitedValue = !this.unlimitedValue
  }
}
