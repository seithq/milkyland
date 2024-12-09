import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { period: { type: String, default: "day" } }

  static targets = [ "from", "to" ]

  periodValueChanged() {
    switch (this.periodValue) {
      case "day":
        this.fromTarget.disabled = true
        this.toTarget.disabled = true
        break
      case "month":
        this.fromTarget.disabled = false
        this.toTarget.disabled = true
        break
      case "year":
        this.fromTarget.disabled = false
        this.toTarget.disabled = false
        break
    }
  }

  selectPeriod(event) {
    this.periodValue = event.target.value
  }
}
