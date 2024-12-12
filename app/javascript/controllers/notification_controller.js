import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notification"
export default class extends Controller {
  connect() {
    if (window.location.pathname === "/") {
      // Exibir notificações apenas na root_path
      this.element.classList.remove("hidden");
    } else {
      // Esconde o elemento em outras páginas
      this.element.classList.add("hidden");
    }
  }

  closeNotification(event){
    event.preventDefault();
    this.element.classList.add("d-none")
  }
}
