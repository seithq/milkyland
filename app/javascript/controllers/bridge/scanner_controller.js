import { BridgeComponent } from "@hotwired/hotwire-native-bridge"
import { get } from "@rails/request.js"

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
      if (this.shouldPrependCode()) {
        const url = this.codesTarget.getAttribute("data-bridge-preview-url")
        const whitelist = this.codesTarget.getAttribute("data-bridge-allowed-prefixes")
        const frame = this.codesTarget.getAttribute("data-bridge-frame")

        const params = new URLSearchParams()
        params.append("code", message.data.code)
        params.append("allowed_prefixes", whitelist)
        params.append("frame", frame)

        get(`${url}?${params}`, {
          responseKind: "turbo-stream"
        })
      }
      else {
        this.codeTarget.value = message.data.code
      }
    })
  }

  shouldPrependCode() {
    const element = this.bridgeElement
    return element.bridgeAttribute("multiple") === "true" && this.hasCodesTarget
  }
}