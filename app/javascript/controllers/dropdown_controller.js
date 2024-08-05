import { Controller } from "@hotwired/stimulus"
import { enter, leave, toggle } from "el-transition"

export default class extends Controller {
  static targets = [ "menu", "button" ]

  open() {
    enter(this.menuTarget)
  }

  close(event) {
    if (event && (this.buttonTarget.contains(event.target) || this.menuTarget.contains(event.target))) return

    leave(this.menuTarget)
  }

  toggle() {
    toggle(this.menuTarget)
  }
}
