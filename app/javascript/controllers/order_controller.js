import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  static values = { searchUrl: String }

  refreshSalesPoints(event) {
    if(event.target.value !== "") {
      const params = new URLSearchParams()
      params.append("client_id", event.target.value)

      get(`${this.searchUrlValue}?${params}`, {
        responseKind: "turbo-stream"
      })
    }
  }
}
