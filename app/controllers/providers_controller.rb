class ProvidersController < ApplicationController
  before_action :set_provider, only: [ "show", "edit", "update", "destroy", "apply" ]

  def index
    @providers = Provider.all

    @providers = @providers
  end

  def new
    @provider = current_user.provider.present? ? current_user.provider : Provider.new
    @provider.user = current_user
  end

  def create
    @provider = current_user.provider.present? ? current_user.provider : Provider.new(provider_params)
    @provider.user = current_user
    if @provider.save
      redirect_to edit_provider_path(@provider.slug), notice: "provider was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def apply
    @provider.applied!
  end

  def show
  end

  def edit
  end

  def update
    if @provider.update(provider_params)
      redirect_to edit_provider_path(@provider.slug), notice: "provider was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @provider.destroy
    redirect_to providers_path, notice: "provider was successfully destroyed."
  end

  def remove_image
    @provider.image.purge
    redirect_to edit_provider_path(provider_slug: @provider.slug), notice: "Image removed successfully."
  end

  private

  def set_provider
    @provider = Provider.find_by!(slug: params[:slug])
  end

  def provider_params
    params.require(:provider).permit(
      :name,
      :address_1,
      :address_2,
      :city,
      :state,
      :zip,
      :license_number,
      :accept_provider_terms,
      :description,
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
      :willing_to_sign_agreement,
      :current_step
    )
  end
end
