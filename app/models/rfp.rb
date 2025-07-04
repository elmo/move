class Rfp < ApplicationRecord
  include SlugGenerator
  belongs_to :user
  has_and_belongs_to_many :specialty_items, dependent: :destroy
  has_and_belongs_to_many :loading_stairs, dependent: :destroy
  has_and_belongs_to_many :unloading_stairs, dependent: :destroy

  accepts_nested_attributes_for :specialty_items
  accepts_nested_attributes_for :loading_stairs
  accepts_nested_attributes_for :unloading_stairs

  has_many :bids

  scope :is_new, -> { where(status: "new") }
  scope :published, -> { where(status: "published") }
  scope :complete, -> { where(status: "complete") }

  before_validation :generate_slug, on: :create
  after_validation :calculate_distance

  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9\-_]+\z/, message: "only allows letters, numbers, hyphens, and underscores" }

  # geocoded_by :load_address

  def ready_to_publish?
    required_fields.each do |field|
      return false if send(field).blank?
    end
  end

  def is_new?
    status == "new"
  end

  def publish!
    update(status: "published") if user.roles.empty?
  end

  def published?
    status == "published"
  end

  def unpublish!
    update(status: "new")
    user.add_role(:customer)
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

  def calculate_distance
     if self.load_address.present?
       coordinates = Geocoder.search(load_address).first.coordinates
       self.latitude = coordinates[0]
       self.longitude = coordinates[1]
     end

     if self.unload_address.present?
       coordinates = Geocoder.search(unload_address).first.coordinates
       self.unload_latitude = coordinates[0]
       self.unload_longitude = coordinates[1]
     end
  end

  def set_move_distance
    update(move_distance: Geocoder::Calculations.distance_between(
      [ latitude, longitude ],
      [ unload_latitude, unload_longitude ]).to_i
     ) if move_distance.blank?
  end


  def center_coordinates
    center_longitude = (longitude + unload_longitude) / 2
    center_latitude = (latitude + unload_latitude) / 2
    [center_longitude, center_latitude]
  end

  private

  def generate_slug
    generate_random_slug
  end
end
