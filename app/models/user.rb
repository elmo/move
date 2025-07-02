class User < ApplicationRecord
  attr_accessor :invite

  has_many :account_users, dependent: :destroy
  has_many :accounts, through: :account_users
  has_many :invitations, dependent: :nullify

  after_create :create_account
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
  has_one :provider

  validates :phone, phone: {
    allow_blank: false, # Allows empty values
    possible: true,  # Validates if the number is possible (less strict)
    countries: [ :us, :ca ], # Restrict to US and Canada
    types: [ :mobile ]  # Only allow mobile numbers
  }, if: -> { current_step.to_i > 1 }

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

  def type_declared?
    provider? || customer?
  end

  def first_and_last_name_present?
    first_name.present? && last_name.present?
  end

  def basic_information_present?
    first_name.present? &&
    last_name.present? &&
    phone.present? &&
    allow_text_messages.present? &&
    terms_accepted.present?
  end

  def account_user(account)
    account.account_users.find_by(user: self)
  end

  def account_user?(account)
    account_user(account).present?
  end

  def account_role(account)
    account_user(account)&.role
  end

  def account_owner?(account)
    account.owner_id == self.id
  end

  def account_admin?(account)
    account_role(account) == "admin"
  end

  def account_member?(account)
    account_role(account) == "member"
  end


  private


  def create_account
    return if self.invite

    account_name = self.email_address.split("@").first
    account = Account.create(name: account_name, owner_id: self.id)
    account_user = AccountUser.create(account: account, user: self, role: "admin")
  end


end
