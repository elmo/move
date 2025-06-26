class Bid < ApplicationRecord
  include SlugGenerator
  belongs_to :user
  belongs_to :rfp
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
