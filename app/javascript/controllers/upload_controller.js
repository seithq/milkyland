import { Controller } from "@hotwired/stimulus"
import { leave } from "el-transition"

export default class extends Controller {
  clear({ params }) {
    const hiddenField = document.getElementById(params.id)
    if (hiddenField) hiddenField.remove()
    leave(this.element)
  }
}