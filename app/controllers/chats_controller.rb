class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @messages = current_user.chat_messages.order(created_at: :asc)
    @chat_message = ChatMessage.new
  end

end
