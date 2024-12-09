class ChatMessage < ApplicationRecord
  belongs_to :user

  validates :content, presence: true
  validates :sender, presence: true, inclusion: { in: ['user', 'ai'] }

  def to_partial_path
    'chat_messages/chat_message'
  end
end
