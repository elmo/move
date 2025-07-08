require "twilio-ruby"
require "sendgrid-ruby"

class Message < ApplicationRecord
  include SendGrid
  include SlugGenerator

  validates :body, presence: true
  validates :slug, presence: true,
    uniqueness: true,
    format: { with: /\A[a-zA-Z0-9\-_]+\z/, message: "only allows letters, numbers, hyphens, and underscores" }

  before_validation :generate_slug, on: :create
  validates :sender_id, presence: true
  validates :recipient_id, presence: true
  belongs_to :sender_user, class_name: "User", foreign_key: :sender_id
  belongs_to :recipient_user, class_name: "User", foreign_key: :recipient_id
  after_create :deliver_asynchronously

  scope :sent_by, ->(user) { where(sender_user_id: user.id) }
  scope :sent_to, ->(user) { where(recipient_user_id: user.id) }

  EMAIL_SENDING_ADDRESS = "info@arrowlinemoving.com"
  STATUS_ENQUEUED = "enqueued"
  STATUS_SUCCESS = "success"
  STATUS_FAILED = "failed"

  def self.create_message(from:, to:, subject:, body:)
    message = Message.new
    message.sender_id = from.id
    message.recipient_id = to.id
    message.subject = subject
    message.body = body
    message.save!
  end

  def deliver_asynchronously
    deliver_sms if recipient_user.allow_text_messages?
    deliver_email
  end

  def deliver_sms
    SmsSendingJob.perform_later(message_id: id)
    update(sms_sending_status: STATUS_ENQUEUED)
  end

  def deliver_sms_now
     account_sid = Rails.application.credentials.dig(:twilio, :account_sid)
     auth_token = Rails.application.credentials.dig(:twilio, :auth_token)
     twilio_phone_number = Rails.application.credentials.dig(:twilio, :phone_number)
     api_key_sid = Rails.application.credentials.dig(:twilio, :api_key_sid)
     api_key_secret = Rails.application.credentials.dig(:twilio, :api_key_secret)

     @client = Twilio::REST::Client.new(
       api_key_sid,
       api_key_secret,
       account_sid
     )

     begin
       @client.messages.create(
         from: twilio_phone_number,
         to: recipient_user.phone,
         body: body
        )
        update(sms_sent_at: Time.zone.now, sms_sending_status: "sent")
     rescue
      update(sms_sending_status: STATUS_FAILED)
     end
  end

  def deliver_email
    Rails.logger.info "sending email to #{recipient_user.email_address}"
    EmailSendingJob.perform_later(message_id: id)
    update(email_sending_status: STATUS_ENQUEUED)
  end

  def deliver_email_now
    from = SendGrid::Email.new(email: EMAIL_SENDING_ADDRESS)
    to = SendGrid::Email.new(email: recipient_user.email_address)

    content = SendGrid::Content.new(
      type: "text/plain",
      value: body
    )

    mail = SendGrid::Mail.new(
      from,
      subject,
      to,
      content
    )

    send_grid_api = SendGrid::API.new(
      api_key: Rails.application.credentials.dig(:sendgrid, :api_key)
    )

    begin
      response = send_grid_api.client.mail._("send").post(request_body: mail.to_json)
      update(
        email_sending_status: STATUS_SUCCESS,
        email_sent_at: Time.zone.now
      )
    rescue
      update(
        email_sending_status: STATUS_FAILED,
        sms_failed_at: Time.zone.now
      )
    end
  end

  def to_param
    slug
  end

  private

  def generate_slug
    generate_random_slug
  end
end
