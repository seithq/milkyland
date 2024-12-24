import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { collectable: { type: Boolean, default: true } }
  static targets = [ "collectable", "button", "span", "sheet", "order" ]
  static classes = [ "buttonEnabled", "buttonDisabled", "spanEnabled", "spanDisabled" ]

  collectableValueChanged() {
    this.collectableTarget.value = this.collectableValue
    this.sheetTarget.required = this.collectableValue
    this.sheetTarget.disabled = !this.collectableValue
    this.orderTarget.required = !this.collectableValue
    this.orderTarget.disabled = this.collectableValue
    this.toggleButton(this.collectableValue)
    this.toggleSpan(this.collectableValue)
  }

  toggleButton(collectable) {
    if (collectable) {
      this.buttonTarget.classList.remove(this.buttonDisabledClass)
      this.buttonTarget.classList.add(this.buttonEnabledClass)
    } else {
      this.buttonTarget.classList.remove(this.buttonEnabledClass)
      this.buttonTarget.classList.add(this.buttonDisabledClass)
    }
  }

  toggleSpan(collectable) {
    if (collectable) {
      this.spanTarget.classList.remove(this.spanDisabledClass)
      this.spanTarget.classList.add(this.spanEnabledClass)
    } else {
      this.spanTarget.classList.remove(this.spanEnabledClass)
      this.spanTarget.classList.add(this.spanDisabledClass)
    }
  }

  toggleCollectable() {
    this.collectableValue = !this.collectableValue
  }
}
