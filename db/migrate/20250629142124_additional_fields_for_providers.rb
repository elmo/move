class AdditionalFieldsForProviders < ActiveRecord::Migration[8.0]
  def change
    add_column :providers, :do_you_have_license, :string
    add_column :providers, :years_in_business, :string
    add_column :providers, :number_trucks_and_crew, :string
    add_column :providers, :regions_served, :string
    add_column :providers, :general_liablity_insurance, :string
    add_column :providers, :cargo_insurance, :string
    add_column :providers, :commercial_vehichle_insurance, :string
    add_column :providers, :usdot_mc_numbers, :string
    add_column :providers, :services, :string
    add_column :providers, :written_estimates, :string
    add_column :providers, :damage_claims, :string
    add_column :providers, :yelp_reviews, :string
    add_column :providers, :google_reviews, :string
    add_column :providers, :bbb_profile, :string
    add_column :providers, :employee_types, :string
    add_column :providers, :employee_background_checks, :string
    add_column :providers, :employee_uniforms, :string
    add_column :providers, :typical_response_time, :string
    add_column :providers, :guarantee_arrival_windows, :string
    add_column :providers, :billing_style, :string
    add_column :providers, :willing_to_sign_agreement, :string
    add_column :providers, :current_step, :integer, default: 0
  end
end
