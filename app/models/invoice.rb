class Invoice < ApplicationRecord
  include SlugGenerator
  belongs_to :user
  belongs_to :bid
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9\-_]+\z/, message: "only allows letters, numbers, hyphens, and underscores" }




  def to_param
    slug
  end

  private

  def generate_slug
    generate_random_slug
  end
end
