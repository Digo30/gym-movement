class NotificationJob < ApplicationJob
  queue_as :default

  def perform
      Turbo::StreamsChannel.broadcast_update_to("root_notifications", target: "notification", partial: "shared/mensagem")
  end
end
