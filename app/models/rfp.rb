class Rfp < ApplicationRecord
  include SlugGenerator
  include Rails.application.routes.url_helpers
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

  scope :with_active_bids, -> { joins(:bids) }

  before_validation :generate_slug, on: :create
  after_validation :calculate_distance

  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9\-_]+\z/, message: "only allows letters, numbers, hyphens, and underscores" }

  after_validation :calculate_distance
  after_save :set_move_distance

  def ready_to_publish?
    required_fields.each do |field|
      return false if send(field).blank?
    end
  end

  def is_new?
    status == "new"
  end

  def publish!
    update(status: "published")
    Message.create_message(
      from: User.system_user,
      to: self,
      subject: "Welcome to Arrowline Moving",
      body: publication_message
    )
  end

  def publication_message
    "Your job request has been published.  Our provider network has been alerted."
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
    if self.load_address.present? && self.latitude.blank?
       coordinates = Geocoder.search(load_address).first.coordinates
       self.latitude = coordinates[0]
       self.longitude = coordinates[1]
     end

    if self.unload_address.present? && self.unload_latitude.blank?
       coordinates = Geocoder.search(unload_address).first.coordinates
       self.unload_latitude = coordinates[0]
       self.unload_longitude = coordinates[1]
     end
  end

  def set_move_distance
    update(move_distance: Geocoder::Calculations.distance_between(
      [ latitude, longitude ],
      [ unload_latitude, unload_longitude ]).to_i
          ) if move_distance.blank? && latitude.present? && longitude.present?
  end

  def center_coordinates
    center_longitude = (longitude + unload_longitude) / 2
    center_latitude = (latitude + unload_latitude) / 2
    [center_longitude, center_latitude]
  end

  def full_url
    rfp_url(self, host: Rails.application.config.action_mailer.default_url_options[:host])
  end

  def invoice_description
    "Deposit for moving job"
  end

  private

  def generate_slug
    generate_random_slug
  end
end
