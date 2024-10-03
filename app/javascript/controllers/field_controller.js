import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static values = { kind: String, trigger: String }
  static targets = [ "measurement", "standard", "collection", "trigger", "trackable", "timeWindow" ]

  kindValueChanged() {
    this.displayFieldsOn(this.kindValue)
  }

  triggerValueChanged() {
    this.displayTrackableOn(this.triggerValue)
  }

  reveal(event) {
    const kind = event.target.value
    if (kind !== "") {
      this.kindValue = kind
    }
  }

  track(event) {
    const trigger = event.target.value
    if (trigger !== "") {
      this.triggerValue = trigger
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

  displayTrackableOn(trigger) {
    let enabled = [], disabled = []
    switch (trigger) {
      case "on_stop":
        enabled = [ this.trackableTarget, this.timeWindowTarget ]
        break
      default:
        disabled = [ this.trackableTarget, this.timeWindowTarget ]
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
