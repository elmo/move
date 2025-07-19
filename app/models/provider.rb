class Provider < ApplicationRecord
  include SlugGenerator
  include Rails.application.routes.url_helpers
  validates :name, presence: true, if: -> { current_step.to_i >= 0 }
  validates :address_1, presence: true, if: -> { current_step.to_i > 0 }
  validates :city, presence: true, if: -> { current_step.to_i > 0 }
  validates :state, presence: true, if: -> { current_step.to_i > 0 }
  validates :zip, presence: true, if: -> { current_step.to_i > 0 }
  validates :license_number, presence: true, if: -> { current_step.to_i > 0 }
  validates :accept_provider_terms, acceptance: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9\-_]+\z/, message: "only allows letters, numbers, hyphens, and underscores" }
  belongs_to :user
  has_one :agreement
  has_many :bids

  has_many_attached :images

  before_validation :generate_slug, on: :create
  after_validation :geocode, on: :create

  geocoded_by :zip

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

  def has_bid_on?(rfp)
    bids.exists?(provider_id: id, rfp_id: rfp.id)
  end

  def bid_on(rfp)
    bids.where(provider_id: id, rfp_id: rfp.id).first
  end

  def applied!
    update(status: "pending review", applied_at: Time.zone.now)
    Message.create_message(
      from: User.system_user,
      to: user,
      subject: "An provider application needs to be reviewed.",
      body: "Please review the application here.\n #{review_url}"
    )
  end

  def pending_review?
    status == "pending review"
  end

  def approve!
    update(status: "approved")
    user.add_role('provider')
    Message.create_message(
      from: User.system_user,
      to: user,
      subject: "Your application has been approved",
      body: "Congratulations! Your application to be a trusted moving services in our network has been approved. You can now bid on jobs."
    )
  end

  def approved?
    status == 'approved'
  end

  def reject!
    update(status: "rejected")
    user.remove_role('provider')
    Message.create_message(
      from: User.system_user,
      to: user,
      subject: "Your application has been rejected",
      body: "Your application to be a trusted moving services in our network has been rejected. If you'd like more information and, please contact us."
    )
  end

  def rejected?
    status == 'rejected'
  end

  def self.statuses
    [
      "new",
      "pending review",
      "active"
    ]
  end

  def questionnaire_fields
    [
      :name,
      :address_1,
      :address_2,
      :city,
      :state,
      :zip,
      :license_number,
      :do_you_have_license,
      :years_in_business,
      :number_trucks_and_crew,
      :regions_served,
      :general_liablity_insurance,
      :cargo_insurance,
      :commercial_vehichle_insurance,
      :usdot_mc_numbers,
      :services,
      :written_estimates,
      :damage_claims,
      :yelp_reviews,
      :google_reviews,
      :bbb_profile,
      :employee_types,
      :employee_background_checks,
      :employee_uniforms,
      :typical_response_time,
      :guarantee_arrival_windows,
      :billing_style,
      :willing_to_sign_agreement
    ]
   end

 def question_map
  {
      name: "What is your registered business name?",
      address_1: "Address",
      address_2: "Addres line 2 (optional)",
      city: "City",
      state: "State",
      zip: "Zip",
      license_number:  "License number",
      do_you_have_license: "Do you have an active business license in your state(s) of operation?",
      years_in_business: "How many years have you been in business?",
      number_trucks_and_crew: "How many trucks and crew members do you have?",
      regions_served: "What areas do you primarily serve?",
      general_liablity_insurance: "Do you carry general liability insurance?",
      cargo_insurance: "Do you have cargo insurance for customers’ belongings?",
      commercial_vehichle_insurance: "Do your crews have commercial vehicle insurance?",
      usdot_mc_numbers: "Do you have USDOT or MC numbers?",
      services: "What services do you offer?",
      written_estimates: "Do you provide written estimates for jobs?",
      damage_claims: "How do you handle damage claims?",
      yelp_reviews: "Yelp reviews",
      google_reviews: "Google reviews",
      bbb_profile: "BBB profile",
      employee_types: "Are your movers employees or independent contractors?",
      employee_background_checks: "Do you background-check your workers?",
      employee_uniforms: "Do your crews wear uniforms or branded clothing?",
      typical_response_time: "What is your typical response time for new job requests?",
      guarantee_arrival_windows: "Do you guarantee arrival windows?",
      billing_style: "Do you charge hourly, by weight, or flat fee?",
      willing_to_sign_agreement: "Are you willing to sign our Provider Agreement and abide by our platform rules, including reporting completed jobs and not bypassing our system?"
    }
end

  def full_url
    provider_url(self, host: Rails.application.config.action_mailer.default_url_options[:host])
  end

  def review_url
    admin_provider_url(self, host: Rails.application.config.action_mailer.default_url_options[:host])
  end

  def total_bid_amount
    bids.pluck(:amount).sum
  end 

  private

  def generate_slug
    generate_slug_by_name(:name)
  end
end
