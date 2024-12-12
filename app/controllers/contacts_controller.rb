class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      ContactMailer.contact_email(@contact).deliver_now
      redirect_to root_path, notice: "Mensagem enviada com sucesso!"
    else
      render :new
    end
  end

private

  def contact_params
    params.required(:contact).permit(:nome, :email, :mensagem)
  end
end
