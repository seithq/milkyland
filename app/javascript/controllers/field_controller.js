import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static values = { kind: String }
  static targets = [ "measurement", "standard", "collection" ]

  kindValueChanged() {
    this.displayFieldsOn(this.kindValue)
  }

  reveal(event) {
    const kind = event.target.value
    if (kind !== "") {
      this.kindValue = kind
    }
  }

  displayFieldsOn(kind) {
    let enabled = [], disabled = []
    switch (kind) {
      case "measure":
        enabled = [this.measurementTarget]
        disabled = [ this.standardTarget, this.collectionTarget ]
        break
      case "normal":
        enabled = [this.standardTarget]
        disabled = [ this.measurementTarget, this.collectionTarget ]
        break
      case "collection":
        enabled = [this.collectionTarget]
        disabled = [ this.measurementTarget, this.standardTarget ]
        break
      default:
        disabled = [ this.measurementTarget, this.standardTarget, this.collectionTarget ]
    }
    enabled.forEach((target) => { this.enableField(target) })
    disabled.forEach((target) => { this.disableField(target) })
  }

  enableField(target) {
    enter(target)
    this.updateDisabledStateFor(target, false)
  }

  disableField(target) {
    leave(target)
    this.updateDisabledStateFor(target, true)
  }

  updateDisabledStateFor(target, disabled) {
    for (const selector of target.getElementsByTagName("select")) {
      selector.disabled = disabled
    }
  }
}
