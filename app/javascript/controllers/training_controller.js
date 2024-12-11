import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content", "indicator"];

  connect() {
    this.content = this.element.querySelector(".training-content");
    this.indicator = this.element.querySelector(".training-toggle-indicator");
  }

  toggle() {
    if (this.content.classList.contains("hidden")) {
      this.content.classList.remove("hidden");
      this.indicator.textContent = "−"; // Indica que está expandido
    } else {
      this.content.classList.add("hidden");
      this.indicator.textContent = "+"; // Indica que está colapsado
    }
  }
}
