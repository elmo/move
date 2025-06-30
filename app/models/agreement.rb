class Agreement < ApplicationRecord
  include SlugGenerator

  belongs_to :user
  belongs_to :provider

  validates :provider_company_name, presence: true
  validates :provider_company_signature, presence: true
  validates :provider_company_signed_date, presence: true

  validates :provider_user_name, presence: true
  validates :provider_user_signature, presence: true
  validates :provider_user_signed_date, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9\-_]+\z/, message: "only allows letters, numbers, hyphens, and underscores" }

  before_validation :generate_slug, on: :create

  def to_param
    slug
  end

  private

  def generate_slug
    generate_slug_by_name(:provider_company_name)
  end

end
