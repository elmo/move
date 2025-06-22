class RfpsController < ApplicationController
  include Pagy::Backend

  before_action :set_rfp, only: [ "show", "edit", "update", "destroy" ]

  def index
    @rfps = Rfp.all

    @pagy, @rfps = pagy(@rfps, items: 12)
  end

  def new
    @rfp = Rfp.new
  end

  def create
    @rfp = Rfp.new(rfp_params)
    if @rfp.save
      redirect_to edit_rfp_path(@rfp.slug), notice: "rfp was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @rfp.update(rfp_params)
      redirect_to edit_rfp_path(@rfp.slug), notice: "rfp was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @rfp.destroy
    redirect_to rfps_path, notice: "rfp was successfully destroyed."
  end

  def remove_image
    @rfp.image.purge
    redirect_to edit_rfp_path(rfp_slug: @rfp.slug), notice: "Image removed successfully."
  end

  private

  def set_rfp
    @rfp = Rfp.find_by!(slug: params[:slug])
  end

  def rfp_params
    params.require(:rfp).permit(:move_date, :type, :move_type, :load_address, :unload_address, :number_of_movers_requested, :estimated_time_in_hours, :loading_stairs, :loading_floor, :loading_stairs_details, :unloading_stairs, :unloading_floor, :specialty_items_details, :need_assistance_with_moving_supplies, :donation_junk_removal, :slug, :specialty_items, :loading_elevator, :unloading_elevator, :earliest_move_date, :move_finish_date)
  end
end
