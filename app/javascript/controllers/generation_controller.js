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
    const localInput = document.getElementById(`${ event.params.id }_input`)
    if (localCounter  && localInput) {
      let boxCount = 0
      if (event.target.value !== "") boxCount = Math.ceil(parseInt(event.target.value) / parseInt(event.params.multiplier))

      localCounter.innerHTML = boxCount.toString()
      localInput.value = boxCount

      let sum = 0;
      this.inputTargets.forEach((input) => {
        if (input.value !== "") sum += parseInt(input.value)
      })
      this.factValue = sum
    }
  }
}
