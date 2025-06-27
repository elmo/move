class Rfp < ApplicationRecord
  include SlugGenerator
  belongs_to :user
  has_and_belongs_to_many :specialty_items, dependent: :destroy
  accepts_nested_attributes_for :specialty_items
  has_many :bids

  scope :is_new, -> { where(status: "new") }
  scope :published, -> { where(status: "published") }
  scope :complete, -> { where(status: "complete") }

  before_validation :generate_slug, on: :create
  validates :load_address, presence: true, if: -> { current_step.to_i > 1 }
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9\-_]+\z/, message: "only allows letters, numbers, hyphens, and underscores" }
  validates :move_date, presence: true, if: -> { current_step.to_i > 1 }
  validates :move_type, presence: true, if: -> { current_step.to_i > 1 }
  validates :load_address, presence: true, if: -> { current_step.to_i > 1 }
  validates :unload_address, presence: true, if: -> { current_step.to_i > 1 }
  validates :number_of_movers_requested, presence: true, if: -> { current_step.to_i > 1 }
  # validates :estimated_time_in_hours, presence: true, if: -> { current_step.to_i > 1 }
  validates :loading_stairs, presence: true, if: -> { current_step.to_i > 1 }
  validates :loading_floor, presence: true, if: -> { current_step.to_i > 1 }
  validates :loading_elevator, presence: true, if: -> { current_step.to_i > 1 }
  validates :loading_stairs_details, presence: true, if: -> { current_step.to_i > 1 && loading_stairs == "Yes" }
  validates :unloading_floor, presence: true, if: -> { current_step.to_i > 1 }
  validates :unloading_elevator, presence: true, if: -> { current_step.to_i > 1 }
  validates :unloading_stairs_details, presence: true, if: -> { current_step.to_i > 1 && loading_stairs == "Yes" }
  validates :earliest_move_date, presence: true, if: -> { current_step.to_i > 1 }
  validates :move_finish_date, presence: true, if: -> { current_step.to_i > 1 }
  validates :specialty_items, presence: true, if: -> { current_step.to_i > 1 }
  validates :specialty_items, presence: true, if: -> { current_step.to_i > 1 }
  validates :specialty_items_details, presence: true, if: -> { current_step.to_i > 1 }
  validates :need_assistance_with_moving_supplies, presence: true, if: -> { current_step.to_i > 1 }
  validates :donation_junk_removal, presence: true, if: -> { current_step.to_i > 1 }

  def ready_to_publish?
    required_fields.each do |field|
      return false if send(field).blank?
    end
  end

  def is_new?
    status == 'new'
  end

  def publish!
    update(status: "published")
  end

  def published?
    status == "published"
  end

  def unpublish!
    update(status: "new")
  end

  def complete!
    update(status: "complete")
  end

  def complete?
    status == "complete"
  end

  def pending!
    update(status: "pending")
  end

  def pending?
    status == "pending"
  end

  def name
    "rfp-#{id}-#{slug}"
  end

  def long_name
    "#{load_address} - #{unload_address}"
  end

  def type_name
    {
      "MovingRequest" => "moving job",
      "HaulingRequest" => "hauling job",
      "CourierRequest" => "courier job"
    }[self.class.to_s]
  end

  def to_param
    slug
  end

  private

  def generate_slug
    generate_random_slug
  end
end
