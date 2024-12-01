import { Controller } from "@hotwired/stimulus"
import { get, post } from "@rails/request.js"

export default class extends Controller {
  static values = {
    previewUrl: String,
    inputName: { type: String, default: "" },
    inputValue: { type: String, default: "" },
    whitelist: String,
    codes: { type: Array, default: [] }
  }

  buildPreview(code, saveMode) {
    if (code === "") return

    const params = new URLSearchParams()
    params.append("code", code)
    params.append("action_name", saveMode)
    params.append("allowed_prefixes", this.whitelistValue)
    params.append("input_name", this.inputNameValue)
    params.append("input_value", this.inputValueValue)
    params.append("frame", this.element.id)

    get(`${this.previewUrlValue}?${params}`, {
      responseKind: "turbo-stream"
    })
  }

  savePreview(code, saveMode) {
    if (code === "") return

    post(this.previewUrlValue, {
      body: JSON.stringify({ code, allowed_prefixes: this.whitelistValue, action_name: saveMode }),
      responseKind: "turbo-stream"
    })
  }
}
