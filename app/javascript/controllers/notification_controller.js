import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notification"
export default class extends Controller {
  connect() {
    console.log("oi")
  }

  closeNotification(){
    this.element.classList.add("d-none")
  }
}
