import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];
  static values = {};

  toggle(event) {
    this.menuTarget.classList.toggle("hidden");
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
    }
  }

  openOnHover() {
    this.menuTarget.classList.remove("hidden");
  }

  closeOnHoverOut() {
    this.menuTarget.classList.add("hidden");
  }
}
