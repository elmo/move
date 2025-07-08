class EmailSendingJob < ApplicationJob 
  def perform(message_id:)
    message = Message.find(message_id)
    message.deliver_email_now
  end
end
