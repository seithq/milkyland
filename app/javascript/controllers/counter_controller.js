import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    min: Number,
    max: Number,
    base: Number,
    inputId: String
  }

  static targets = [ "input" ]

  baseValueChanged() {
    this.inputTarget.innerHTML = this.baseValue
    this.copyValue()
  }

  copyValue() {
    const input = document.getElementById(this.inputIdValue)
    if (input) input.value = this.baseValue
  }

  increment() {
    if (this.baseValue < this.maxValue) this.baseValue++
  }

  decrement() {
    if (this.baseValue > this.minValue) this.baseValue--
  }
}
