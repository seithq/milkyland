import { Controller } from "@hotwired/stimulus"
import Choices from "choices.js"

export default class extends Controller {
  static values = {
    placeholder: { type: String, default: "" },
    results: { type: String, default: "" },
    choices: { type: String, default: "" }
  }

  connect() {
    new Choices(this.element, {
      searchPlaceholderValue: this.placeholderValue,
      noResultsText: this.resultsValue,
      noChoicesText: this.choicesValue
    })
  }
}
