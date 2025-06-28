class Provider < ApplicationRecord
  include SlugGenerator

  validates :name, presence: true
  validates :address_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :license_number, presence: true
  validates :accept_provider_terms, acceptance: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9\-_]+\z/, message: "only allows letters, numbers, hyphens, and underscores" }

  belongs_to :user

  before_validation :generate_slug, on: :create

  def to_param
    slug
  end

  def application_ready_to_submit?
    required_fields.each do |field|
      return false if send(field).blank?
    end
    true
  end

  def required_fields
    [
      :name,
      :address_1,
      :city,
      :state,
      :zip,
      :license_number,
      :accept_provider_terms
    ]
  end

  def applied!
    update(status: 'pending review', applied_at: Time.zone.now)
  end

  def pending_review?
    status == 'pending review'
  end

  def self.statuses
    [
      'new',
      'pending review',
      'active'
    ]
  end

  private

  def generate_slug
    generate_slug_by_name(:name)
  end

end
