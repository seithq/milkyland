import { Controller } from "@hotwired/stimulus"
import { leave } from "el-transition"

export default class extends Controller {
  close() {
    leave(this.element)
    this.element.remove()
  }
}
