import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static values = { kind: String }
  static targets = [ "measurement", "standard", "collection", "trigger" ]

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
        disabled = [ this.standardTarget, this.collectionTarget, this.triggerTarget ]
        break
      case "normal":
        enabled = [this.standardTarget]
        disabled = [ this.measurementTarget, this.collectionTarget, this.triggerTarget ]
        break
      case "collection":
        enabled = [this.collectionTarget]
        disabled = [ this.measurementTarget, this.standardTarget, this.triggerTarget ]
        break
      case "time":
        enabled = [this.triggerTarget]
        disabled = [ this.measurementTarget, this.standardTarget, this.collectionTarget ]
        break
      default:
        disabled = [ this.measurementTarget, this.standardTarget, this.collectionTarget, this.triggerTarget ]
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
