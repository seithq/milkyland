import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { animated: Boolean }
  static classes = [ "animation" ]

  connect() {
    if (this.animatedValue) {
      this.startAnimation()
      setTimeout(() => {
        this.stopAnimation()
      }, 3000)
    }
  }

  startAnimation() {
    this.element.classList.add(this.animationClass)
  }

  stopAnimation() {
    this.element.classList.remove(this.animationClass)
  }
}
