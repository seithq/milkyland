import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { kind: String }
  static targets = [ "selector" ]

  kindValueChanged() {
    this.selectorTarget.disabled = this.kindValue != "external";
  }

  toggleSelector(event) {
    this.kindValue = event.target.value
  }
}
