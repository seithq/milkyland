import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { kind: String }
  static targets = ["sender", "receiver"]

  kindValueChanged() {
    this.setSelectorStates(this.kindValue)
  }

  toggleSelectors(event) {
    this.kindValue = event.target.value
  }

  setSelectorStates(kind) {
    let senderDisabled, receiverDisabled

    switch (kind) {
      case "arrival":
        [senderDisabled, receiverDisabled] = [true, false]
        break
      case "transfer":
        [senderDisabled, receiverDisabled] = [false, false]
        break
      case "write_off":
        [senderDisabled, receiverDisabled] = [false, true]
        break
      default:
        [senderDisabled, receiverDisabled] = [true, true]
        break
    }

    this.senderTarget.disabled = senderDisabled
    this.receiverTarget.disabled = receiverDisabled
  }
}
