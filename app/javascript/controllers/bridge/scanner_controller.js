import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "scanner"
  static targets = [ "code", "codes" ]

  show(event) {
    if (this.enabled) {
      event.stopImmediatePropagation()
      this.#notifyBridgeOfDisplay()
    }
  }

  #notifyBridgeOfDisplay() {
    const element = this.bridgeElement
    const manual = element.bridgeAttribute("manual")

    this.send("display", { manual }, message => {
      if (this.shouldKeepCode())
        this.codesTarget.prepend(message.data.code)
      else
        this.codeTarget.value = message.data.code
    })
  }

  shouldKeepCode() {
    const element = this.bridgeElement
    return element.bridgeAttribute("multiple") === "true" && this.hasCodesTarget
  }
}