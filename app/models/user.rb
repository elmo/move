class User < ApplicationRecord
  rolify
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_one_attached :avatar
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :rfps
  has_many :bids
  has_many :customers
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  attr_accessor :current_step

  validates :phone, phone: {
    allow_blank: false, # Allows empty values
    possible: true,  # Validates if the number is possible (less strict)
    countries: [:us, :ca], # Restrict to US and Canada
    types: [:mobile]  # Only allow mobile numbers
  }, if: -> {current_step.to_i > 1}

  validates :first_name, presence: true, if: -> { current_step.to_i > 1 }
  validates :last_name, presence: true, if: -> { current_step.to_i > 1 }
  validates :allow_text_messages, acceptance: true, if: -> { current_step.to_i > 1 }
  validates :terms_accepted, acceptance: true, if: -> { current_step.to_i > 1 }

  def name
    if first_name? && last_name?
      "#{first_name} #{last_name}"
    elsif first_name?
      first_name
    elsif last_name?
      last_name
    else
      email_address
    end
  end

  def initials
    if first_name?
      first_initial = first_name[0]
      last_initial = last_name[0] if last_name?
      "\#{first_initial}\#{last_initial}"
    else
      email_address[0].to_s
    end
  end

  def provider?
    has_role?("provider")
  end

  def customer?
    has_role?("customer")
  end

  def first_and_last_name_present?
    first_name.present? && last_name.present?
  end

end
