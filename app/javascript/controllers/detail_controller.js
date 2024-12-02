import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static targets = [ "opener", "closer", "summary" ]
  static values = { open: Boolean }

  openValueChanged() {
    if (this.openValue) {
      leave(this.openerTarget)
      enter(this.closerTarget)
      enter(this.summaryTarget)
    } else {
      leave(this.closerTarget)
      enter(this.openerTarget)
      leave(this.summaryTarget)
    }
  }

  toggle(event) {
    this.openValue = !this.openValue
  }
}
