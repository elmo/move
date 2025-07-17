class Bid < ApplicationRecord
  include SlugGenerator
  include Rails.application.routes.url_helpers
  belongs_to :user
  belongs_to :provider
  belongs_to :rfp
  has_one :acceptance

  validates :agree_to_platform_terms, acceptance: true
  validates :name, presence: true
  validates :amount, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9\-_]+\z/, message: "only allows letters, numbers, hyphens, and underscores" }
  before_validation :generate_slug, on: :create
  scope :is_new, -> { where(status: "new") }
  scope :pending, -> { where(status: "pending") }
  scope :accepted, -> { where(status: "accepted") }
  scope :confirmed, -> { where(status: "accepted") }

  after_validation :set_status_to_new_if_amount_has_changed
  before_save :send_modified_bid_message_to_users

  def to_param
    slug
  end

  def new!
    update(status: "new")
  end

  def new?
    status == "new"
  end

  def pending!
    update(status: "pending")
    Message.create_message(
      from: User.system_user,
      to: provider.user,
      subject: "Your bid has been placed",
      body: "Your bid has been placed.\nThe requestor of the work has been notified.\n\n#{provider_full_url}"
    )

    Message.create_message(
      from: User.system_user,
      to: rfp.user,
      subject: "A bid has been placed on your work request.\n",
      body: "A bid has been placed on your work request.\nPlease review the bid: #{full_url}"
    )
  end

  def pending?
    status == 'pending'
  end

  def deposit_amount_for_stripe
    amount * 10
  end

  def deposit_amount_in_dollars
    amount * 0.1
  end

  def amount_less_deposit
    amount * 0.9
  end

  def full_url
    rfp_bid_url(rfp, self, host: Rails.application.config.action_mailer.default_url_options[:host])
  end

  def provider_full_url
    provider_bid_url(self, host: Rails.application.config.action_mailer.default_url_options[:host])
  end

  def accepted?
    status == "accepted"
  end

  def accepted!
    update(status: "accepted")
    Message.create_message(
      from: User.system_user,
      to: provider.user,
      subject: "Your bid has been accepted",
      body: "Your bid has been accepted. Please view the details now. #{rfp.full_url}"
    )

    Message.create_message(
      from: User.system_user,
      to: rfp.user,
      subject: "A bid has been placed on your work request.",
      body: "A bid has been placed on your work request. Please review the bid: #{full_url}"
    )
  end

  def accepted?
    status == "accepted"
  end

  def reject!
    update(status: "rejected")
    Message.create_message(
      from: User.system_user,
      to: provider.user,
      subject: "Your bid has been rejected",
      body: "Your bid has been rejected by the requestor.\nThere is nothing that you need to do.\n
      You are welcome to submit a new bid.\n #{provider_full_url}\n\n --Arrowlinemoving"
    )
  end

  def rejected?
    status == "rejected"
  end

  def confirm!
    update(status: "confirmed")
    rfp.complete!
    Message.create_message(
      from: User.system_user,
      to: rfp.user,
      subject: "Your work request has been confirmed.",
      body: "Good news! #{provider.name} has confirmed your moving job.\nThey have committed to performing the work.\nPlease reach out to them directly and make the final arrangments.\nIf you have any questions, please feel free to contact us.\n#{full_url} --Arrowlinemoving"
    )
    Message.create_message(
      from: User.system_user,
      to: provider.user,
      subject: "You have committed to work perform a moving job",
      body: "Congratulations. You've got work.\nYou've committed to performing moving job.\nYou can now see all the contact information related to this work.\nIf you have any problems Contact us.\n #{provider_full_url}\n --Arrowlinemoving"
    )
  end

  def confirmed?
    status == "confirmed"
  end


  private

  def send_modified_bid_message_to_users 
    if status_changed? && status == 'new' && status_was == 'rejected'
    Message.create_message(
      from: User.system_user,
      to: rfp.user,
      subject: "Provider has changed their bid amount",
      body: "Good news! #{provider.name} has updated their bid amount. See the details:\n#{full_url}\n\n --Arrowlinemoving"
    )
    Message.create_message(
      from: User.system_user,
      to: provider.user,
      subject: "You have updated your bid",
      body: "See the details here:\n #{provider_full_url}\n --Arrowlinemoving"
    )
    end
  end

  def set_status_to_new_if_amount_has_changed 
    if self.amount_changed?
      self.status = 'new'
    end
  end

  def generate_slug
    generate_random_slug
  end
end
