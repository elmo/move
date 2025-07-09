class Bid < ApplicationRecord
  include SlugGenerator
  include Rails.application.routes.url_helpers
  belongs_to :user
  belongs_to :provider
  belongs_to :rfp
  validates :agree_to_platform_terms, acceptance: true
  validates :name, presence: true
  validates :amount, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9\-_]+\z/, message: "only allows letters, numbers, hyphens, and underscores" }
  before_validation :generate_slug, on: :create
  scope :is_new, -> { where(status: "new") }
  scope :pending, -> { where(status: "pending") }
  scope :accepted, -> { where(status: "accepted") }
  scope :confirmed, -> { where(status: "accepted") }

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
      to: provider.user.email,
      subject: "Your bid has been placed",
      body: "Your bid has been placed. The requestor of the work has been notified."
    )

    Message.create_message(
      from: User.system_user,
      to: rfp.user.email,
      subject: "A bid has been placed on your work request.",
      body: "A bid has been placed on your work request. Please review the bid: #{full_url}"
    )
  end

  def full_url
    rfp_bid_url(rfp, self, host: Rails.application.config.action_mailer.default_url_options[:host])
  end

  def accepted?
    status == "accepted"
    Message.create_message(
      from: User.system_user,
      to: provider.user.email,
      subject: "Your bid has been accepted",
      body: "Your bid has been accepted. Please view the details now. #{rfp.full_url}"
    )

    Message.create_message(
      from: User.system_user,
      to: rfp.user.email,
      subject: "A bid has been placed on your work request.",
      body: "A bid has been placed on your work request. Please review the bid: #{full_url}"
    )
  end

  def accepted!
    update(status: "accepted")
  end

  def accepted?
    status == "accepted"
  end

  def reject!
    update(status: "rejected")
    Message.create_message(
      from: User.system_user,
      to: provider.user.email,
      subject: "Your bid has been rejected",
      body: "Your bid has been rejected by the requestor. There is nothing that you need to do. You are welcome to submit a new bid. #{full_url}\n --Arrowlinemoving"
    )
  end

  def rejected?
    status == "rejected"
  end

  def confirm!
    update(status: "confirmed")
    Message.create_message(
      from: User.system_user,
      to: rfp.user.email,
      subject: "Your work request has been confirmed.",
      body: "Good news! #{provider.name} has confirmed your moving job. They have committed to performing the work. Please reach out to them directly and make the final arrangments. If you have any questions, please feel free to contact us.\n --Arrowlinemoving "
    )
    Message.create_message(
      from: User.system_user,
      to: provider.user.email,
      subject: "You have committed to work perform a moving job",
      body: "Congratulations. You've got work. You've committed to performing moving job. You can now see all the contact information related to this work. If you have any problems Contact us.\n --Arrowlinemoving"
    )
  end

  def confirmed?
    status == "confirmed"
  end

  private

  def generate_slug
    generate_random_slug
  end
end
