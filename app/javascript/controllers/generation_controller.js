import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { plan: Number, fact: Number, minDelta: Number }
  static classes = [ "passing" ]
  static targets = [ "counter", "input", "submit" ]

  factValueChanged() {
    this.counterTarget.innerHTML = this.factValue
    this.changeCounterColor()
  }

  changeCounterColor() {
    if (this.isPassingCounter()) {
      this.submitTarget.disabled = false
      this.counterTarget.classList.add(this.passingClass)
    } else {
      this.submitTarget.disabled = true
      this.counterTarget.classList.remove(this.passingClass)
    }
  }

  isPassingCounter() {
    if (this.factValue < this.planValue) return false
    if (this.factValue === this.planValue) return true

    const delta = this.factValue - this.planValue
    return delta < this.minDeltaValue
  }

  refreshCounter(event) {
    const localCounter = document.getElementById(event.params.id)
    if (localCounter && event.target.value !== "") localCounter.innerHTML = (parseInt(event.params.multiplier) * parseInt(event.target.value)).toString()

    let sum = 0;
    this.inputTargets.forEach((input) => {
      const multiplier = parseInt(input.dataset.generationMultiplierParam)
      if (input.value !== "") sum += multiplier * parseInt(input.value)
    })
    this.factValue = sum
  }
}
