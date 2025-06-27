class RfpsController < ApplicationController
  include Pagy::Backend

  before_action :set_rfp, only: [ "show", "edit", "update", "destroy" , "publish", "unpublish"]

  def index
    redirect_to edit_user_path and return false if current_user.roles.empty?
    if current_user.provider?
      @rfps = Rfp.published
    else
      @rfps = current_user.rfps.published
    end

    @pagy, @rfps = pagy(@rfps, items: 12)
  end

  def choose
  end

  def new
    @rfp = Rfp.new
    if params[:type].present? and params[:type] == 'Moving'
      @rfp = MovingRequest.new
    else
      @rfp = HaulingRequest.new
    end
    @rfp.current_step = 2
  end

  def create
    @rfp = current_user.rfps.new(rfp_params)
    if @rfp.save
      redirect_to edit_rfp_path(@rfp.slug), notice: "Request was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    @rfp.current_step = 2
  end

  def update
    if @rfp.update(rfp_params)
      redirect_to edit_rfp_path(@rfp.slug), notice: "Request was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def publish
    @rfp.publish!
    redirect_to edit_rfp_path(@rfp), notice: "Your job request has been published"
  end

  def unpublish
    @rfp.unpublish!
    redirect_to edit_rfp_path(@rfp), notice: "Your job request has been published"
  end

  def destroy
    @rfp.destroy
    redirect_to rfps_path, notice: "Request was successfully destroyed."
  end

  private

  def set_rfp
    @rfp = Rfp.find_by!(slug: params[:slug])
  end

  def rfp_params
    params.require(:rfp).permit(:move_date, :type, :move_type, :load_address, :unload_address, :number_of_movers_requested, :estimated_time_in_hours, :loading_stairs, :loading_floor, :loading_stairs_details, :unloading_stairs, :unloading_stairs_details, :unloading_floor, :specialty_items_details, :need_assistance_with_moving_supplies, :donation_junk_removal, :slug, :has_specialty_items, :loading_elevator, :unloading_elevator, :earliest_move_date, :move_finish_date, :current_step, specialty_item_ids: [])
  end
end
