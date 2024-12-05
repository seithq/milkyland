import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { restricted: Boolean }

  static targets = [ "email", "password" ]

  restrictedValueChanged() {
    this.emailTarget.disabled = this.restrictedValue
    this.passwordTarget.disabled = this.restrictedValue
  }

  toggle(event) {
    this.restrictedValue = event.target.checked
  }
}
