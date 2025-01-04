import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static classes = [ "rotation" ]
  static targets = [ "opener" ]
  static values = { open: Boolean, id: String }

  openValueChanged() {
    const selector = `[data-id='${ this.idValue }']`

    if (this.openValue) {
      this.openerTarget.classList.add(this.rotationClass)
      document.querySelectorAll(selector).forEach(element => {
        enter(element)
      })
    } else {
      this.openerTarget.classList.remove(this.rotationClass)
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
