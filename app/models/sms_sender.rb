require "aws-sdk-sns"
class SmsSender
  attr_accessor :client, :response, :phone_number

  def initialize(phone_number:)
    @phone_number = phone_number
    @client = Aws::SNS::Client.new(credentials: credentials, region: region)
  end

  def deliver_transactional(message_text:)
    begin
      @response = client.publish(
      phone_number: phone_number,
      message: message_text,
      message_attributes: {
        "AWS.SNS.SMS.SMSType" => {
          data_type: "String",
          string_value: "Transactional" # Or 'Promotional'
        }
       }
      )
       Rails.logger.info "SMS sent successfully! Message ID: #{response.message_id}"
     rescue Aws::SNS::Errors::ServiceError => e
       Rails.logger.info "Error sending SMS: #{e.message}"
     end
  end

  def deliver_promotional(message_text:)
    begin
      @response = client.publish(
      phone_number: phone_number,
      message: message_text,
      message_attributes: {
        "AWS.SNS.SMS.SMSType" => {
          data_type: "String",
          string_value: "Promotional"
        }
       }
      )
       Rails.logger.info "SMS sent successfully! Message ID: #{response.message_id}"
     rescue Aws::SNS::Errors::ServiceError => e
       Rails.logger.info "Error sending SMS: #{e.message}"
     end
  end

  private

  def credentials
    Aws::Credentials.new(
      Rails.application.credentials.dig(:aws, :access_key_id),
      Rails.application.credentials.dig(:aws, :secret_access_key)
    )
  end

  def region
     Rails.application.credentials.dig(:aws, :region)
  end
end
