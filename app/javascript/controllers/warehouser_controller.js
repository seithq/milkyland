import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static values = { duty: String }
  static targets = [ "selector" ]

  dutyValueChanged() {
    if (this.dutyValue === "replacing")
      enter(this.selectorTarget)
    else
      leave(this.selectorTarget)
  }

  showReplaceables(event) {
    this.dutyValue = event.target.value
  }
}
