class NotificationJob < ApplicationJob
  queue_as :default

  def perform
    User.all.each do |user|
      Turbo::StreamsChannel.broadcast_update_to(user, target: "notification", partial: "shared/mensagem")
    end
  end
end
