import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["alert"]

  connect() {
    // Initialize controller
  }

  showAlert() {
    const alertDiv = document.createElement("div")
    alertDiv.innerHTML = `
      <div class="custom-alert">
        <div class="alert-content">
          <div class="spinner-border text-light" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
          <p>Aguarde, seu treino está sendo criado...</p>
        </div>
      </div>
    `
    document.body.appendChild(alertDiv)

    // Remove alert after 7 seconds
    setTimeout(() => {
      alertDiv.remove()
      this.showViewTrainingButton()
    }, 7000)
  }

  showViewTrainingButton() {
    const buttonDiv = document.createElement("div")
    buttonDiv.innerHTML = `
      <div class="text-center mt-4">
        <a href="${this.element.dataset.userTrainingsPath}" class="btn btn-primary">
          Ver meu treino
        </a>
      </div>
    `
    const formCard = this.element.querySelector('.form-card')
    formCard.appendChild(buttonDiv)
  }
}
