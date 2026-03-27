import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="swap"
export default class extends Controller {
  static targets = ["left", "right"]

  execute() {
    var buf = this.leftTarget.value
    this.leftTarget.value = this.rightTarget.value
    this.rightTarget.value = buf
  }
}
