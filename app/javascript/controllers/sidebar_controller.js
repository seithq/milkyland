import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static targets = ["mobileMenu", "mobileOverlay", "mobileContent"]

  open() {
    enter(this.mobileMenuTarget)
    enter(this.mobileOverlayTarget)
    enter(this.mobileContentTarget)
  }

  close() {
    leave(this.mobileMenuTarget)
    leave(this.mobileOverlayTarget)
    leave(this.mobileContentTarget)
  }
}
