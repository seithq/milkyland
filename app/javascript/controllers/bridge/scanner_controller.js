import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "scanner"
  static targets = [ "code" ]

  show(event) {
    if (this.enabled) {
      event.stopImmediatePropagation()
      this.#notifyBridgeOfDisplay()
    }
  }

  #notifyBridgeOfDisplay() {
    const element = this.bridgeElement
    const title = element.bridgeAttribute("title")
    this.send("display", { title }, message => {
      this.codeTarget.value = message.data.code
    })
  }
}