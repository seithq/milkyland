import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
    static component = "overflow-scanner"

    connect() {
        super.connect()
        this.#notifyBridgeOfConnect()
    }

    #notifyBridgeOfConnect() {
        const element = this.bridgeElement
        this.send("connect", { title: element.title }, () => {
            this.element.click()
        })
    }
}