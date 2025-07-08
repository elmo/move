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
  end

  def accepted!
    update(status: "accepted")
  end

  def accepted?
    status == "accepted"
  end

  def reject!
    update(status: "rejected")
  end

  def rejected?
    status == "rejected"
  end

  def confirm!
    update(status: "confirmed")
  end

  def confirmed?
    status == "confirmed"
  end

  private

  def generate_slug
    generate_random_slug
  end
end
