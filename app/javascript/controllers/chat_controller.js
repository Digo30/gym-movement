import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.scrollToBottom()
  }

  submitOnEnter(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      event.target.form.requestSubmit()
    }
  }

  scrollToBottom() {
    const messages = document.querySelector("#messages")
    if (messages) {
      messages.scrollTop = messages.scrollHeight
    }
  }
}
