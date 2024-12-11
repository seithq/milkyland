import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  static values = {searchUrl: String}

  refreshVendors(event) {
    const params = new URLSearchParams()
    params.append("material_asset_id", event.target.value)

    get(`${this.searchUrlValue}?${params}`, {
      responseKind: "turbo-stream"
    })
  }
}
