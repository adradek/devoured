import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["components"]

  toggle() {
    this.componentsTarget.hidden = !this.componentsTarget.hidden
  }
}
