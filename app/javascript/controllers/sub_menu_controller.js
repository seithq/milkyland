import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static targets = [ "menu", "arrow" ]
  static classes = [ "expanded", "collapsed" ]
  static values = { open: Boolean }

  openValueChanged() {
    if (this.openValue) {
      this.arrowTarget.classList.add(this.expandedClass)
      this.arrowTarget.classList.remove(this.collapsedClass)
      enter(this.menuTarget)
    } else {
      this.arrowTarget.classList.remove(this.expandedClass)
      this.arrowTarget.classList.add(this.collapsedClass)
      leave(this.menuTarget)
    }
  }

  toggle(event) {
    this.openValue = !this.openValue
  }
}
