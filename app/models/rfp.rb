class Rfp < ApplicationRecord
  include SlugGenerator
  belongs_to :user
  has_and_belongs_to_many :specialty_items, dependent: :destroy
  accepts_nested_attributes_for :specialty_items
  attr_accessor :current_step

  before_validation :generate_slug, on: :create
  validates :load_address, presence: true, if: -> { current_step.to_i > 2 } 
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9\-_]+\z/, message: "only allows letters, numbers, hyphens, and underscores" }
  validates :move_date, presence: true, if: -> { current_step.to_i > 2 }
  validates :move_type, presence: true, if: -> { current_step.to_i > 2 }
  validates :load_address, presence: true, if: -> { current_step.to_i > 2 }
  validates :unload_address, presence: true, if: -> { current_step.to_i > 2 }
  validates :number_of_movers_requested, presence: true, if: -> { current_step.to_i > 2 }
  validates :estimated_time_in_hours, presence: true, if: -> { current_step.to_i > 2 }
  validates :loading_stairs, presence: true, if: -> { current_step.to_i > 2 }
  validates :loading_floor, presence: true, if: -> { current_step.to_i > 2 }
  validates :loading_elevator, presence: true, if: -> { current_step.to_i > 2 }
  validates :loading_stairs_details, presence: true, if: -> { current_step.to_i > 2 && loading_stairs == "Yes" }
  validates :unloading_floor, presence: true, if: -> { current_step.to_i > 2 }
  validates :unloading_elevator, presence: true, if: -> { current_step.to_i > 2 }
  validates :unloading_stairs_details, presence: true, if: -> { current_step.to_i > 2 && loading_stairs == "Yes" }
  validates :earliest_move_date, presence: true, if: -> { current_step.to_i > 2 }
  validates :move_finish_date, presence: true, if: -> { current_step.to_i > 2 }
  validates :specialty_items, presence: true, if: -> { current_step.to_i > 2 }
  validates :specialty_items, presence: true, if: -> { current_step.to_i > 2 }
  validates :specialty_items_details, presence: true, if: -> { current_step.to_i > 2 }
  validates :need_assistance_with_moving_supplies, presence: true, if: -> { current_step.to_i > 2 }
  validates :donation_junk_removal, presence: true, if: -> { current_step.to_i > 2 }

  def to_param
    slug
  end

  private

  def generate_slug
    generate_random_slug
  end
end
