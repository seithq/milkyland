import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  connect() {
    enter(this.element)
    setTimeout(() => {
      this.close()
    }, 3000)
  }

  close() {
    leave(this.element)
    this.element.remove()
  }
}
