import { BridgeComponent, BridgeElement } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
    static component = "dropdown"
    static targets = ["item"]

    connect() {
        super.connect()
        this.#notifyBridgeOfConnect()
    }

    #notifyBridgeOfConnect() {
        const rootElement = this.bridgeElement
        const title = rootElement.bridgeAttribute("title")
        const side = rootElement.bridgeAttribute("side") || "right"

        const items = []
        this.itemTargets.forEach(item => {
            const element = new BridgeElement(item)
            const title = item.text
            const index = element.bridgeAttribute("index")
            const image = element.bridgeAttribute("image")
            items.push({ title, image, index })
        })

        this.send("connect", { title, side, items }, (message) => {
            const clickedIndex = message.data.index
            this.itemTargets.forEach(item => {
                const element = new BridgeElement(item)
                const index = element.bridgeAttribute("index")
                if (clickedIndex === index) {
                    item.click()
                }
            })
        })
    }
}
