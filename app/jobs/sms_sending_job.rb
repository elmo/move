class SmsSendingJob < ApplicationJob
  def perform(message_id:)
    return true # TODO remove when once account has bee approved 
    message = Message.find(message_id)
    message.deliver_sms_now
  end
end
