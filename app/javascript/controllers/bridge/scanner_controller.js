import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "scanner"

  show(event) {
    if (this.enabled) {
      event.stopImmediatePropagation()
      this.#notifyBridgeOfDisplay(event.params.place, event.params.saveMode)
    }
  }

  #notifyBridgeOfDisplay(place, saveMode) {
    const element = this.bridgeElement
    const manual = element.bridgeAttribute("manual")

    this.send("display", { manual }, message => {
      const result = document.getElementById(place)
      if (result) {
        this.application.getControllerForElementAndIdentifier(result, "scan-preview").buildPreview(message.data.code, saveMode)
      }
    })
  }

  shouldPrependCode() {
    const element = this.bridgeElement
    return element.bridgeAttribute("multiple") === "true" && this.hasCodesTarget
  }
}