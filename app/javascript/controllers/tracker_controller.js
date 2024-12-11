import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "counter", "trackable" ]
  static values = { count: { type: Number, default: 0 } }

  connect() {
    const config = { attributes: false, childList: true, subtree: false }
    const callback = (mutationList, observer) => {
      for (const mutation of mutationList) {
        if (mutation.type === "childList") {
          this.countValue = this.trackableTarget.childElementCount
        }
      }
    }

    this.observer = new MutationObserver(callback)
    this.observer.observe(this.trackableTarget, config)
  }

  disconnect() {
    this.observer.disconnect()
  }

  countValueChanged() {
    this.counterTarget.innerHTML = this.countValue
  }
}
