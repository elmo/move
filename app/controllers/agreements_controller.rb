class AgreementsController < ApplicationController
  include Pagy::Backend
  before_action :set_provider
  before_action :set_agreement, only: [ "show", "edit", "update", "destroy" ]

  def index
    @agreements = Agreement.all
    @pagy, @agreements = pagy(@agreements, items: 12)
  end

  def new
    @agreement = Agreement.new
    @agreement.user = current_user
    @agreement.provider = @provider
    @agreement.provider_company_name = @provider.name
    @agreement.provider_company_signed_date = Time.zone.now.to_date.to_date
    @agreement.provider_user_signed_date = Time.zone.now.to_date.to_date
  end

  def create
    @agreement = Agreement.new(agreement_params)
    @agreement.user = current_user
    @agreement.provider = @provider
    if @agreement.save
      redirect_to edit_provider_path(@provider), notice: "Agreement was successfully signed."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @agreement.update(agreement_params)
      redirect_to edit_agreement_path(@agreement.slug), notice: "agreement was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @agreement.destroy
    redirect_to agreements_path, notice: "agreement was successfully destroyed."
  end

  def remove_image
    @agreement.image.purge
    redirect_to edit_agreement_path(agreement_slug: @agreement.slug), notice: "Image removed successfully."
  end

  private

  def set_provider
    @provider = Provider.find_by(slug: params[:provider_slug]) 
  end

  def set_agreement
    @agreement = Agreement.find_by!(slug: params[:slug])
  end

  def agreement_params
    params.require(:agreement).permit(:user_id, :provider_id, :provider_company_name, :provider_company_signature, :provider_company_signed_date, :provider_user_name, :provider_user_signature, :provider_user_signed_date, :slug)
  end
end
