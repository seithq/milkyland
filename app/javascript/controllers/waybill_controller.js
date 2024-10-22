import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sender", "receiver"]

  connect() {
    this.setSelectorStates("arrival")
  }

  toggleSelectors(event) {
    this.setSelectorStates(event.target.value)
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
    }

    this.senderTarget.disabled = senderDisabled
    this.receiverTarget.disabled = receiverDisabled
  }
}
