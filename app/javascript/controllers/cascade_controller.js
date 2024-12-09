import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static targets = [ "opener", "closer" ]
  static values = { open: Boolean, id: String }

  openValueChanged() {
    const selector = `[data-id='${ this.idValue }']`

    if (this.openValue) {
      leave(this.openerTarget)
      enter(this.closerTarget)
      document.querySelectorAll(selector).forEach(element => {
        enter(element)
      })
    } else {
      leave(this.closerTarget)
      enter(this.openerTarget)
      document.querySelectorAll(selector).forEach(element => {
        leave(element)
        const childController = this.application.getControllerForElementAndIdentifier(element, "cascade")
        if (childController) {
          childController.close()
        }
      })
    }
  }

  toggle(event) {
    this.openValue = !this.openValue
  }

  close() {
    this.openValue = false
  }
}
